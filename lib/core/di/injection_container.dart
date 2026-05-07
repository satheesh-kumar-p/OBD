import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mavlink_module/dialects/ugvcustom.dart';
import 'package:scout_obd/core/comm/comm_link_config.dart';
import 'package:scout_obd/core/comm/comm_manager.dart';
import 'package:scout_obd/core/constants/app_constants.dart';
import 'package:scout_obd/core/enums/transport_type.dart';
import 'package:scout_obd/core/logger/logger.dart';

final commManagerProvider = Provider<CommManager>((ref) {
  final logger = Logger("COMM_MANAGER");

  final manager = CommManager(
      dialect: MavlinkDialectUgvcustom(), logger: logger);

  manager.addLink(const CommLinkConfig(
      id: AppConstants.primaryLinkId,
      transportType: TransportType.udp,
      host: AppConstants.mavlinkHost,
      port: AppConstants.mavlinkPort));

  ref.onDispose(manager.disconnectAll);
  return manager;
});

final commConnectionProvider = FutureProvider<void>((ref) async {
  final manager = ref.read(commManagerProvider);
  final logger = Logger('COMM_CONNECTION');

  try {
    await manager.connectAll();
  } catch (e) {
    logger.error(
      'Exception in Comm connection',
      context: {'error': e.toString()},
    );
  }
});
