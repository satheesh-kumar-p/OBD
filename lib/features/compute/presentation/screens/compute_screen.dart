import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/ugv_subsystem_version_model.dart';
import '../../di/ugv_subsystem_providers.dart';
import '../../enums/firmware_version_type.dart';

class ComputeScreen extends ConsumerWidget {
  const ComputeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionsAsync = ref.watch(ugvVersionsProvider);

    final size = MediaQuery.of(context).size;
    final leftPadding = size.width * 0.20;
    final topPadding = size.height * 0.10;

    // Force showing the loading screen if we are currently fetching fresh data,
    // even if we had a previous error or result.
    if (versionsAsync.isLoading) {
      return _buildLoading(leftPadding, topPadding);
    }

    return versionsAsync.when(
      data: (models) => _buildContent(models, leftPadding, topPadding),
      loading: () => _buildLoading(leftPadding, topPadding),
      error: (err, stack) => _buildError(err, leftPadding, topPadding),
    );
  }

  Widget _buildLoading(double leftPadding, double topPadding) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: leftPadding, top: topPadding),
        child: const Text('REQUESTING VERSIONS...',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 32,
                fontFamily: 'monospace')),
      ),
    );
  }

  Widget _buildError(Object err, double leftPadding, double topPadding) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: leftPadding, top: topPadding, right: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SYSTEM ERROR',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('$err',
                style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 24,
                    fontFamily: 'monospace')),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<UgvSubsystemVersionModel> models,
      double leftPadding, double topPadding) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 36,
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
      fontSize: 30,
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
      padding: EdgeInsets.only(
          left: leftPadding, top: topPadding, right: 20, bottom: 60),
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

          const SizedBox(width: 20),

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
                softWrap: true, style: checksumStyle),
        ],
      ),
    );
  }
}
