import 'dart:async';
import 'dart:io';

import 'package:comm_module/comm_module.dart';
import 'package:mavlink_nrt/mavlink_dialect.dart';
import 'package:mavlink_nrt/mavlink_frame.dart';
import 'package:mavlink_nrt/mavlink_message.dart';
import 'package:mavlink_nrt/mavlink_parser.dart';
import 'package:scout_obd/core/comm/comm_link_config.dart';
import 'package:scout_obd/core/comm/mavlink_service_impl.dart';
import 'package:scout_obd/core/comm/mock_mavlink_service.dart';
import 'package:scout_obd/core/constants/app_constants.dart';
import 'package:scout_obd/core/enums/transport_type.dart';
import 'package:scout_obd/core/logger/logger.dart';
import 'package:scout_obd/core/comm/mavlink_service.dart';

/// Useful for filtering frames from multiple links as [MavlinkFrame] doesn't have linkId
class TaggedFrame {
  const TaggedFrame({required this.linkId, required this.frame});

  final String linkId;
  final MavlinkFrame frame;
}

class CommManager {
  CommManager({required MavlinkDialect dialect, required Logger logger})
    : _dialect = dialect,
      _logger = logger;

  final MavlinkDialect _dialect;
  final Logger _logger;

  final Map<String, MavlinkService> _links = {};
  final Map<String, StreamSubscription<MavlinkFrame>> _subs = {};
  final _allFramesCtrl = StreamController<TaggedFrame>.broadcast();

  void addLink(CommLinkConfig config) {
    if (_links.containsKey(config.id)) {
      _logger.warn(
        'CommManager: duplicate link ignored',
        context: {'id': config.id},
      );
      return;
    }

    final service = AppConstants.useMockBackends
        ? MockMavlinkService(Logger('MOCK_LOGGER')) as MavlinkService
        : _buildRealService(config);

    _links[config.id] = service;

    // Tag every frame that arrives on this link and forward to merged stream.
    _subs[config.id] = service.frameStream.listen(
      (frame) {
        _logger.debug(
          'Frame received',
          context: {
            'linkId': config.id,
            'msgId': frame.message.mavlinkMessageId,
            'sysId': frame.systemId,
            'message': frame.message,
          },
        );
        _allFramesCtrl.add(TaggedFrame(linkId: config.id, frame: frame));
      },
      onError: (Object e) => _logger.error(
        'Frame stream error',
        error: e,
        context: {'linkId': config.id},
      ),
    );

    _logger.info('Link registered', context: {'id': config.id});
  }

  MavlinkService _buildRealService(CommLinkConfig config) {
    final transport = switch (config.transportType) {
      TransportType.udp => UdpTransport(
        address: InternetAddress("0.0.0.0"),
        port: 7500,
        remoteAddress: InternetAddress(config.host),
        remotePort: config.port,
      ),
      TransportType.tcp => TcpTransport(host: config.host, port: config.port),
    };

    return MavlinkServiceImpl(
      transport: transport,
      parser: MavlinkParser(_dialect),
      logger: _logger,
    );
  }

  Future<void> connectAll() async {
    _logger.info(
      'connectAll starting',
      context: {'links': _links.keys.toList()},
    );
    try {
      await Future.wait(_links.values.map((s) => s.connect()));
      _logger.info('All links connected');
    } catch (e, st) {
      _logger.error('connectAll failed', error: e, stack: st);
      rethrow;
    }
  }

  Future<void> disconnectAll() async {
    _logger.info('Disconnecting all links');
    await Future.wait(_links.values.map((s) => s.disconnect()));
    for (final s in _subs.values) {
      await s.cancel();
    }
    _subs.clear();
    _links.clear();
    _logger.info('All links disconnected');
  }

  // ── Streams ───────────────────────────────────────────────────────────────

  /// Merged stream of every frame from every link, with link tag.
  Stream<TaggedFrame> get allFrames => _allFramesCtrl.stream;

  /// Frames from [linkId] where message id == [messageId].
  Stream<MavlinkFrame> watchMessage({
    required String linkId,
    required int messageId,
  }) =>
      _allFramesCtrl.stream
          .where((tf) =>
      tf.linkId == linkId &&
          tf.frame.message.mavlinkMessageId == messageId)
          .map((tf) => tf.frame);

  Stream<bool> watchConnectionStatus(String linkId) =>
      _links[linkId]?.connectionStream ?? const Stream.empty();

  Future<void> send({
    required String linkId,
    required MavlinkMessage message,
  }) async {
    final service = _links[linkId];
    if (service == null) {
      _logger.warn(
        'CommManager.send: unknown link',
        context: {'linkId': linkId, 'msgId': message.mavlinkMessageId},
      );
      return;
    }
    _logger.debug(
      'Sending message',
      context: {'linkId': linkId, 'msgId': message.mavlinkMessageId},
    );
    await service.send(message);
  }

  /// Send the same message on every registered link.
  Future<void> broadcast(MavlinkMessage message) =>
      Future.wait(_links.values.map((s) => s.send(message)));
}
