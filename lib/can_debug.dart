import 'dart:async';
import 'package:flutter/material.dart';
import 'core/comm/can_bus/can_bus.dart';
import 'core/comm/can_bus/can_comm_manager.dart';
import 'core/comm/can_bus/mock_can_service.dart';
import 'core/enums/can_enums.dart';
import 'core/logger/logger.dart';
import 'features/system/domain/repositories/system_info_repository.dart';

void main() async {
  // Initialize Flutter bindings (required by some plugins even in mock mode)
  WidgetsFlutterBinding.ensureInitialized();

  final logger = Logger('CAN_DEBUG');

  // 1. Manually setup the stack without Riverpod DI
  final mockService = MockCanService(logger: Logger('MOCK_CAN'));
  final canManager = CanCommManager(service: mockService, logger: Logger('CAN_MANAGER'));
  final systemInfoRepo = SystemInfoRepository(canManager: canManager, logger: Logger('SYSTEM_INFO_REPO'));

  print('\x1B[2J\x1B[0;0H'); // Clear console
  print('=========================================');
  print('      WAVESHARE CAN DEBUG (MOCK)         ');
  print('=========================================');

  // 2. Start the Repository
  systemInfoRepo.startCanData();
  print(' [INFO] SystemInfoRepository listening for messages...');

  // 3. Listen for transformed (parsed) values
  systemInfoRepo.watchCanData().listen((entity) {
    print('\n[${DateTime.now().toLocal().toString().split('.')[0]}] --- Decoded System Info ---');
    entity.subsystemHealthMap.forEach((name, status) {
      final statusStr = status.toString().split('.').last.toUpperCase();
      print('  • $name: $statusStr');
    });
  });

  // 4. Listen for connection status
  canManager.connectionStream.listen((connected) {
    final status = connected ? 'CONNECTED' : 'DISCONNECTED';
    print(' [STATUS] Connection changed: $status');
  });

  // 5. Connect the mock service
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
