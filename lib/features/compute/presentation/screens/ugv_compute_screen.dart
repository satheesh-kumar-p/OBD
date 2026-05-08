import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/di/dashboard_providers.dart';
import '../../data/models/ugv_subsystem_version_model.dart';
import '../../di/ugv_subsystem_providers.dart';
import '../../enums/firmware_version_type.dart';

class UgvComputeScreen extends ConsumerWidget {
  const UgvComputeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionsAsync = ref.watch(ugvVersionsProvider);

    final size = MediaQuery.of(context).size;
    final leftPadding = size.width * 0.20;
    final topPadding = size.height * 0.10;

    return versionsAsync.when(
      data: (models) => _buildContent(models, leftPadding, topPadding),
      loading: () => Center(
        child: Padding(
          padding: EdgeInsets.only(left: leftPadding, top: topPadding),
          child: const Text('REQUESTING VERSIONS...',
              style: TextStyle(
                  color: Colors.white24,
                  fontSize: 32,
                  fontFamily: 'monospace')),
        ),
      ),
      error: (err, stack) => Center(
        child: Padding(
          padding: EdgeInsets.only(left: leftPadding, top: topPadding),
          child: Text('ERROR: $err',
              style: const TextStyle(
                  color: Colors.red, fontSize: 32, fontFamily: 'monospace')),
        ),
      ),
    );
  }

  Widget _buildContent(
      List<UgvSubsystemVersionModel> models, double leftPadding, double topPadding) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 36, // Increased SW version size further
      height: 1.3,
      fontFamily: 'monospace',
      fontWeight: FontWeight.w600,
    );
    const headerStyle = TextStyle(
      color: Colors.cyanAccent,
      fontSize: 34,
      fontWeight: FontWeight.bold,
      height: 2.2,
      letterSpacing: 1.2,
    );
    const checksumStyle = TextStyle(
      color: Colors.white38,
      fontSize: 30, // SHA font size is now almost equal to sw version
      fontFamily: 'monospace',
      height: 1.1,
    );

    UgvSubsystemVersionModel? swModel;
    UgvSubsystemVersionModel? hwModel;

    for (final m in models) {
      if (m.type == 2) swModel = m;
      if (m.type == 3) hwModel = m;
    }

    return SingleChildScrollView(
      padding:
          EdgeInsets.only(left: leftPadding, top: topPadding, right: 20, bottom: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Software
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('--- SOFTWARE ---', style: headerStyle),
                if (swModel != null) ...[
                  _versionItem('ATLAS ', swModel.component1Sw,
                      swModel.component1Checksum, textStyle, checksumStyle),
                  _versionItem('VCU   ', swModel.component2Sw,
                      swModel.component2Checksum, textStyle, checksumStyle),
                  _versionItem('OBD   ', swModel.component3Sw,
                      swModel.component3Checksum, textStyle, checksumStyle),
                  _versionItem('H-CTRL', swModel.component4Sw,
                      swModel.component4Checksum, textStyle, checksumStyle),
                  _versionItem('GCS   ', swModel.component5Sw,
                      swModel.component5Checksum, textStyle, checksumStyle),
                ] else
                  const Text('NO SW DATA', style: textStyle),
              ],
            ),
          ),

          const SizedBox(width: 20), // Reduced gap between columns

          // Right Column: Hardware
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('--- HARDWARE ---', style: headerStyle),
                if (hwModel != null) ...[
                  _versionItem('MOTOR ', hwModel.component1Sw,
                      hwModel.component1Checksum, textStyle, checksumStyle),
                  _versionItem('UHF   ', hwModel.component2Sw,
                      hwModel.component2Checksum, textStyle, checksumStyle),
                  _versionItem('L-BAND', hwModel.component3Sw,
                      hwModel.component3Checksum, textStyle, checksumStyle),
                ] else
                  const Text('NO HW DATA', style: textStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _versionItem(String label, int swValue, List<int>? checksum,
      TextStyle textStyle, TextStyle checksumStyle) {
    // Decode the uint32 version using the FirmwareVersion32 logic
    final versionStr = FirmwareVersion32.fromUint32(swValue).toString();

    String toHex(List<int> bytes) {
      return bytes
          .map((b) => (b & 0xFF).toRadixString(16).padLeft(2, '0'))
          .join();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: $versionStr', style: textStyle),
          if (checksum != null && checksum.any((b) => b != 0))
            Text('SHA: ${toHex(checksum)}',
                softWrap: true, // Ensure it wraps to next row
                style: checksumStyle),
        ],
      ),
    );
  }
}
