import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:comm_module/comm_module.dart';
import '../dispatcher/message_dispatcher.dart';
import '../logger/logger.dart';
import '../enums/transport_type.dart';
import '../constants/app_constants.dart';
import 'can_bus/can_frame.dart';
import 'can_bus/can_frame_parser.dart';

/// Orchestrates the communication lifecycle, including reconnection and dispatching.
/// Bridges the [Transport] from comm_module with the application's CAN logic.
class CommManager {
  Transport? _transport;
  final Logger _logger;
  final MessageDispatcher _dispatcher;
  final CanFrameParser _parser;
  final TransportType _transportType;
  
  StreamSubscription<Uint8List>? _transportDataSub;
  StreamSubscription<CanFrame>? _parserFrameSub;
  final StreamController<bool> _connectionCtrl = StreamController<bool>.broadcast();
  
  Timer? _reconnectTimer;
  bool _isDisposed = false;

  CommManager({
    required TransportType transportType,
    required Logger logger,
    MessageDispatcher? dispatcher,
    CanFrameParser? parser,
  })  : _transportType = transportType,
        _logger = logger,
        _dispatcher = dispatcher ?? MessageDispatcher(),
        _parser = parser ?? CanFrameParser();

  void _createTransport() {
    _transport?.dispose();
    
    switch (_transportType) {
      case TransportType.udp:
        _transport = UdpTransport(
          address: InternetAddress.anyIPv4,
          port: AppConstants.listenPort,
          remoteAddress: InternetAddress(AppConstants.sendAddress),
          remotePort: AppConstants.sendPort,
        );
        break;
      case TransportType.tcp:
        _transport = TcpTransport(
          host: AppConstants.tcpHost,
          port: AppConstants.tcpPort,
        );
        break;
    }
    
    _setupListeners();
  }

  void _setupListeners() {
    _transportDataSub?.cancel();
    
    // Pipe Transport -> Parser
    _transportDataSub = _transport?.onData.listen(
      _parser.feed,
      onError: (e, st) {
        _logger.error('CommManager: Transport data error', error: e, stack: st);
        _handleDisconnect();
      },
      onDone: () {
        _logger.warn('CommManager: Transport stream closed');
        _handleDisconnect();
      },
    );

    _parserFrameSub?.cancel();
    // Pipe Parser -> Dispatcher
    _parserFrameSub = _parser.frames.listen(
      _dispatcher.dispatch,
      onError: (e, st) => _logger.error('CommManager: Parser frame error', error: e, stack: st),
    );
  }

  /// Stream of connection status.
  Stream<bool> get connectionStream => _connectionCtrl.stream;

  /// Whether the service is currently connected.
  bool get isConnected => _transport?.isConnected ?? false;

  /// Stream of all incoming CAN frames (the firehose).
  Stream<CanFrame> get rawFrameStream => _parser.frames;

  /// Returns a filtered stream of frames with a specific [messageId].
  /// Emits [null] if the data goes stale.
  Stream<CanFrame?> watchMessage(int messageId) {
    return _dispatcher.streamFor(messageId);
  }

  /// Initializes the connection.
  Future<void> connect() async {
    if (_isDisposed) return;
    
    if (isConnected) {
      _logger.info('CommManager: Already connected');
      return;
    }

    if (_transport == null) {
      _createTransport();
    }

    try {
      _logger.info('CommManager: Attempting to connect transport: $_transportType');
      await _transport?.connect();
      _logger.info('CommManager: Connected successfully');
      _connectionCtrl.add(true);
      _reconnectTimer?.cancel();
    } catch (e, st) {
      _logger.error('CommManager: Connection failed', error: e, stack: st);
      _handleDisconnect();
      rethrow;
    }
  }

  void _handleDisconnect() {
    if (_isDisposed) return;
    _connectionCtrl.add(false);
    _startReconnectTimer();
  }

  /// Starts a periodic timer to attempt reconnection every 5 seconds.
  void _startReconnectTimer() {
    if (_isDisposed || (_reconnectTimer?.isActive ?? false)) return;
    
    _logger.info('CommManager: Reconnection will be attempted every 5 seconds.');
    _reconnectTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      
      if (!isConnected) {
        _logger.info('CommManager: Reconnection attempt starting...');
        try {
          await connect();
          if (isConnected) {
            _logger.info('CommManager: Reconnected successfully.');
            timer.cancel();
          }
        } catch (_) {
          _logger.warn('CommManager: Reconnection attempt failed. Retrying in 5s.');
        }
      } else {
        timer.cancel();
      }
    });
  }

  /// Manually disconnects the service and stops reconnection attempts.
  Future<void> disconnect() async {
    _logger.info('CommManager: Manual disconnect requested.');
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _transport?.close();
    _connectionCtrl.add(false);
  }

  /// Sends a [CanFrame] to the bus.
  Future<void> send(CanFrame frame) async {
    if (!isConnected) {
      _logger.warn('CommManager: Cannot send, service not connected');
      return;
    }
    
    try {
      final bytes = CanFrameParser.serialize(frame);
      await _transport?.send(bytes);
    } catch (e, st) {
      _logger.error('CommManager: Failed to send frame', error: e, stack: st);
      rethrow;
    }
  }

  /// Disposes of the manager and any active connections.
  void dispose() {
    if (_isDisposed) return;
    _logger.info('CommManager: Disposing');
    _isDisposed = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _transportDataSub?.cancel();
    _parserFrameSub?.cancel();
    _connectionCtrl.close();
    _parser.dispose();
    _dispatcher.dispose();
    _transport?.dispose();
  }
}
