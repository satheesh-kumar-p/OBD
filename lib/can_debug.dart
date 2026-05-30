import 'dart:async';
import 'package:flutter/material.dart';
import 'core/comm/can_bus/can_bus.dart';
import 'core/enums/can_enums.dart';
import 'core/logger/logger.dart';
import 'features/drive/data/repositories/drive_info_repository.dart';
import 'features/system/data/repositories/system_info_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = Logger('CAN_DEBUG');

  // 1. Manually setup the stack without Riverpod DI
  final mockService = MockCanService(logger);
  final canManager = CanCommManager(logger: logger);
  final systemInfoRepo = SystemInfoRepository(canManager: canManager, logger: logger);
  final driveInfoRepo = DriveInfoRepository(canManager: canManager, logger: logger);

  print('\x1B[2J\x1B[0;0H'); // Clear console
  print('=========================================');
  print('      WAVESHARE CAN DEBUG (MOCK)         ');
  print('=========================================');

  // 2. Start Repositories
  systemInfoRepo.startCanData();
  driveInfoRepo.startCanData();
  print(' [INFO] Repositories listening for messages...');

  // 3. Listen for System Info (0x203)
  systemInfoRepo.watchCanData().listen((entity) {
    print('\n[${DateTime.now().toLocal().toString().split('.')[0]}] --- Decoded System Info (0x203) ---');
    entity.subsystemHealthMap.forEach((name, status) {
      final statusStr = status.toString().split('.').last.toUpperCase();
      print('  • $name: $statusStr');
    });
  });

  // 4. Listen for Drive Info (0x204)
  driveInfoRepo.watchCanData().listen((entity) {
    print('\n[${DateTime.now().toLocal().toString().split('.')[0]}] --- Decoded Drive Info (0x204) ---');
    print('  • Front Left Motor: ${entity.frontLeftMotor}');
    print('  • Front Right Motor: ${entity.frontRightMotor}');
    print('  • Rear Left Motor: ${entity.rearLeftMotor}');
    print('  • Rear Right Motor: ${entity.rearRightMotor}');
    print('  • Left Motor Controller: ${entity.leftMotorController}');
    print('  • Right Motor Controller: ${entity.rightMotorController}');
  });

  // 5. Listen for connection status
  canManager.connectionStream.listen((connected) {
    final status = connected ? 'CONNECTED' : 'DISCONNECTED';
    print(' [STATUS] Connection changed: $status');
  });

  // 6. Connect the mock service
  try {
    print('\n Attempting to start Mock CAN service...');
    
    await canManager.connect(
      portName: 'MOCK_ADAPTER',
      config: const CanConfig(
        baudRate: CanBaudRate.bps500k,
      ),
    );

    print(' *** SUCCESS: Mock Service Active ***');
    print(' Watch the logs below for transformed CAN data...');

    // Keep the process alive
    await Completer<void>().future;

  } catch (e, st) {
    print(' [!] FATAL ERROR: $e');
    print(st);
  }
}
