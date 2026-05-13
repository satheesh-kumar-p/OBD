import 'dart:async';
import 'dart:typed_data';

import 'package:comm_module/comm_module.dart';
import 'package:mavlink_nrt/mavlink.dart';
import 'package:scout_obd/core/comm/mavlink_service.dart';
import 'package:scout_obd/core/constants/app_constants.dart';
import 'package:scout_obd/core/logger/logger.dart';

class MavlinkServiceImpl implements MavlinkService {
  final Transport _transport;
  final Logger _logger;
  final MavlinkParser _mavlinkParser;

  final StreamController<bool> _connectionCtrl = StreamController<bool>.broadcast();
  StreamSubscription<Uint8List>? _transportSub;
  
  int _sequence = 0;

  MavlinkServiceImpl({
    required Transport transport,
    required Logger logger,
    required MavlinkParser parser,
  }) : _transport = transport,
       _logger = logger,
       _mavlinkParser = parser;

  @override
  Stream<bool> get connectionStream => _connectionCtrl.stream;

  @override
  Stream<MavlinkFrame> get frameStream => _mavlinkParser.stream;

  @override
  bool get isConnected => _transport.isConnected;

  @override
  Future<void> connect() async {
    _logger.info('Mavlink Service connecting...');
    try {
      await _transport.connect();
      
      _transportSub = _transport.onData.listen(
        _mavlinkParser.parse,
        onError: (Object err) {
          _logger.error('Transport stream error', error: err);
          _connectionCtrl.add(false);
        },
        onDone: () {
          _logger.warn('Transport stream closed');
          _connectionCtrl.add(false);
        },
      );
      _connectionCtrl.add(true);
      _logger.info('MAVLink connected');
    } catch (err, st) {
      _connectionCtrl.add(false);
      _logger.error("MAVLink connection failed", error: err, stack: st);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    await _transportSub?.cancel();
    _transportSub = null;
    await _transport.close();
    _connectionCtrl.add(false);
    _logger.info("MAVLink Disconnected");
  }

  @override
  Future<void> send(MavlinkMessage message) async {
    if (!_transport.isConnected) {
      _logger.warn('Connect to transport before sending a message!', context: {
        'msgId': message.mavlinkMessageId
      });
      return;
    }
    try {
      final frame = MavlinkFrame.v2(_sequence++ & 0xFF, AppConstants.obdSystemId, AppConstants.obdComponentId, message);
      await _transport.send(frame.serialize());
    } catch (err, st) {
      _logger.error("MAVLink send failed", error: err, stack: st, context: {
        'msgId': message.mavlinkMessageId,
      });
      rethrow;
    }
  }
}
