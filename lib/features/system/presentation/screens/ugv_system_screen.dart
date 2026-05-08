import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/domain/entities/ugv_system_entity.dart';
import '../../../../shared/enums/ugv_motor_error.dart';
import '../../../../shared/enums/ugv_sensor_error.dart';
import '../../di/ugv_health_providers.dart';

class UgvSystemScreen extends ConsumerWidget {
  const UgvSystemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthDataAsync = ref.watch(ugvHealthDataProvider(AppConstants.primaryLinkId));
    
    // Calculate safe margins based on screen size to avoid HUD elements
    final size = MediaQuery.of(context).size;
    // Sidebar is up to 20% of width, so 25% left padding provides a safe margin.
    // Top HUD bar is ~12-15% of height, so 20% top padding clears it.
    final leftPadding = size.width * 0.20;
    final topPadding = size.height * 0.10;

    return healthDataAsync.when(
      data: (data) => _buildPlainList(data, leftPadding, topPadding),
      loading: () => const Center(child: Text('LOADING...', style: TextStyle(color: Colors.white24, fontSize: 32))),
      error: (err, stack) => Center(child: Text('ERROR: $err', style: const TextStyle(color: Colors.red, fontSize: 32))),
    );
  }

  Widget _buildPlainList(UgvSystemEntity data, double leftPadding, double topPadding) {
    const textStyle = TextStyle(
      color: Colors.white, 
      fontSize: 32,
      height: 1.5, 
      fontFamily: 'monospace',
      fontWeight: FontWeight.w500,
    );
    const headerStyle = TextStyle(
      color: Colors.cyanAccent, 
      fontSize: 32,
      fontWeight: FontWeight.bold, 
      height: 2.2,
      letterSpacing: 1.2,
    );

    // Scaling data based on ICD:
    // Compute Load: d% -> % (divide by 10)
    final computeLoad = (data.computeLoad / 10.0).toStringAsFixed(1);
    // Main Voltage: mV -> V (divide by 1000)
    final mainVoltage = (data.mainVoltage / 1000.0).toStringAsFixed(2);
    // Main Current: cA -> A (divide by 100)
    final mainCurrent = (data.mainCurrent / 100.0).toStringAsFixed(2);
    // Comm Drop Rate: c% -> % (divide by 100)
    final dropRate = (data.dropRateComm / 100.0).toStringAsFixed(2);

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: leftPadding, top: topPadding, right: 60, bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('--- UGV SYSTEM HEALTH REPORT ---', style: headerStyle),
          Text('BATTERY REMAINING : ${data.batteryRemaining}%', style: textStyle),
          Text('MAIN VOLTAGE      : $mainVoltage V', style: textStyle),
          Text('MAIN CURRENT      : $mainCurrent A', style: textStyle),
          Text('COMPUTE LOAD      : $computeLoad%', style: textStyle),
          Text('VCU FAULT ERRORS  : ${data.vcuFaultErrors}', style: textStyle),
          Text('COMM DROP RATE    : $dropRate%', style: textStyle),
          
          const SizedBox(height: 30),
          const Text('--- SUBSYSTEM STATUS ---', style: headerStyle),
          Text('PRESENT : ${data.subsystems.present.map((e) => e.name.toUpperCase()).join(", ")}', style: textStyle),
          Text('ENABLED : ${data.subsystems.enabled.map((e) => e.name.toUpperCase()).join(", ")}', style: textStyle),
          Text('HEALTHY : ${data.subsystems.healthy.map((e) => e.name.toUpperCase()).join(", ")}', style: textStyle),

          const SizedBox(height: 30),
          const Text('--- MOTOR ERROR MAP ---', style: headerStyle),
          ...UgvMotorError.values.map((error) {
            final left = data.leftMotorErrors.errors.contains(error) ? "FAULT" : "OK";
            final right = data.rightMotorErrors.errors.contains(error) ? "FAULT" : "OK";
            final label = error.name.replaceAll(RegExp(r'(?=[A-Z])'), '_').toUpperCase();
            return Text('${label.padRight(15)} : L[$left] R[$right]', style: textStyle);
          }),

          const SizedBox(height: 30),
          const Text('--- SENSOR ERROR MAP ---', style: headerStyle),
          ...UgvSensorError.values.map((error) {
            final status = data.sensorBusErrors.errors.contains(error) ? "FAULT" : "OK";
            final label = error.name.replaceAll(RegExp(r'(?=[A-Z])'), '_').toUpperCase();
            return Text('${label.padRight(15)} : [$status]', style: textStyle);
          }),

        ],
      ),
    );
  }
}
