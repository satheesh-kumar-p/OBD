import 'package:scout_obd/core/enums/transport_type.dart';

class CommLinkConfig {
  const CommLinkConfig({
    required this.id,
    required this.transportType,
    required this.host,
    required this.port,
  });

  final String id;
  final TransportType transportType;
  final String host;
  final int port;
}