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
import 'checksum/checksum_packet.dart';

/// Orchestrates the communication lifecycle, including reconnection and dispatching.
/// Bridges the [Transport] from comm_module with the application's CAN logic.
///
/// A SINGLE UDP socket, bound to [AppConstants.listenPort] (5005), now
/// carries both CAN frames and checksum/version JSON heartbeats. Every
/// incoming datagram is routed by its first byte before being handed to
/// either [CanFrameParser] or the checksum stream — see
/// [_routeIncomingData] for why this split is safe and deterministic,
/// not a fragile guess.
class CommManager {
  Transport? _transport;
  final Logger _logger;
  final MessageDispatcher _dispatcher;
  final CanFrameParser _parser;
  final TransportType _transportType;

  StreamSubscription<Uint8List>? _transportDataSub;
  StreamSubscription<CanFrame>? _parserFrameSub;
  final StreamController<bool> _connectionCtrl =
      StreamController<bool>.broadcast();

  /// Raw checksum/version packets, demultiplexed out of the shared
  /// socket. JSON decoding still happens downstream in
  /// ChecksumJsonParser, not here.
  final StreamController<ChecksumPacket> _checksumDataCtrl =
      StreamController<ChecksumPacket>.broadcast();

  Timer? _reconnectTimer;
  bool _isDisposed = false;

  /// CAN frames on this transport always start with this Waveshare
  /// framing header byte (see CanFrameParser._tryParseFrame). In UTF-8,
  /// 0xAA (0b10101010) is a continuation byte — illegal as the first
  /// byte of any valid UTF-8 text — so a well-formed JSON payload
  /// (which always starts with '{', '[', or whitespace) can never begin
  /// with 0xAA. That makes checking the first byte a deterministic,
  /// collision-free way to tell the two payload types apart on one
  /// shared socket, not a heuristic guess.
  static const int _canFrameHeaderByte = 0xAA;

  CommManager({   //initialization of the manager and created, storing the dependencies like logger and transport type with default fallbacks
    required TransportType transportType,
    required Logger logger,
    MessageDispatcher? dispatcher,
    CanFrameParser? parser,
  }) : _transportType = transportType,
       _logger = logger,
       _dispatcher =
           dispatcher ??
           MessageDispatcher(staleThreshold: AppConstants.staleThreshold),
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
    _transportDataSub?.cancel();  // Cancel the existing subscription

    // Single socket -> route each datagram to CAN parser or checksum
    // stream based on its first byte, instead of piping straight to
    // _parser.feed like before.
    _transportDataSub = _transport?.onData.listen(
      _routeIncomingData,
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
      onError: (e, st) =>
          _logger.error('CommManager: Parser frame error', error: e, stack: st),
    );
  }

  /// Demultiplexes one incoming UDP datagram. Each UDP datagram is a
  /// complete, independent message (unlike TCP), so this per-packet
  /// check is safe — there's no risk of a CAN frame and a JSON payload
  /// ever being split across the same buffer boundary.
  void _routeIncomingData(Uint8List data) {
    if (data.isEmpty) return;

    if (data[0] == _canFrameHeaderByte) {
      _parser.feed(data);
      return;
    }

    // Not CAN-framed -> treat as a checksum/version JSON heartbeat.
    if (!_checksumDataCtrl.isClosed) {
      _checksumDataCtrl.add(
        ChecksumPacket(timestamp: DateTime.now(), data: data),
      );
    }
  }

  /// Stream of connection status (one socket now covers both streams).
  Stream<bool> get connectionStream => _connectionCtrl.stream;    //expose the stream to the whole app  can be access anywhere in the app by ref.listen()

  /// Whether the shared transport is currently connected.
  bool get isConnected => _transport?.isConnected ?? false;

  /// Raw checksum/version packets as they arrive, demultiplexed from
  /// the shared socket.
  Stream<ChecksumPacket> get checksumDataStream => _checksumDataCtrl.stream;

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
      _logger.info(
        'CommManager: Attempting to connect transport: $_transportType',
      );
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

    _logger.info(
      'CommManager: Reconnection will be attempted every 5 seconds.',
    );
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
          _logger.warn(
            'CommManager: Reconnection attempt failed. Retrying in 5s.',
          );
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
    _checksumDataCtrl.close();
    _parser.dispose();
    _dispatcher.dispose();
    _transport?.dispose();
  }
}