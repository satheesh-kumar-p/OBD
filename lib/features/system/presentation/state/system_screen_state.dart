import '../../../../core/constants/subsystem_list_constants.dart';
import '../../domain/entities/system_info_entity.dart';
import '../../domain/entities/compute_comm_info_entity.dart';
import '../../enums/subsystem_status_enum.dart';

class SystemScreenState {
  final SystemInfoEntity? systemInfo;
  final ComputeCommInfoEntity? computeCommInfo;
  final DateTime? lastUpdateTime;

  const SystemScreenState({
    this.systemInfo,
    this.computeCommInfo,
    this.lastUpdateTime,
  });

  SystemScreenState copyWith({
    SystemInfoEntity? systemInfo,
    ComputeCommInfoEntity? computeCommInfo,
    DateTime? lastUpdateTime,
  }) {
    return SystemScreenState(
      systemInfo: systemInfo ?? this.systemInfo,
      computeCommInfo: computeCommInfo ?? this.computeCommInfo,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
    );
  }

  Map<Subsystem, SubsystemStatus> get subsystemStatuses {
    return {
      Subsystem.frontMotorController: systemInfo?.frontMotorController ?? SubsystemStatus.unknown,
      Subsystem.rearMotorController: systemInfo?.rearMotorController ?? SubsystemStatus.unknown,
      Subsystem.hvBattery: systemInfo?.hvBattery ?? SubsystemStatus.unknown,
      Subsystem.lvBattery: systemInfo?.lvBattery ?? SubsystemStatus.unknown,
      Subsystem.lvPdu: systemInfo?.lvPdu ?? SubsystemStatus.unknown,
      Subsystem.dcDc48v12v: systemInfo?.dcDc48v12v ?? SubsystemStatus.unknown,
      Subsystem.dcDc12v5v: systemInfo?.dcDc12v5v ?? SubsystemStatus.unknown,
      Subsystem.vcu: systemInfo?.vcu ?? SubsystemStatus.unknown,
      Subsystem.frontLeftMotor: systemInfo?.frontLeftMotor ?? SubsystemStatus.unknown,
      Subsystem.rearLeftMotor: systemInfo?.rearLeftMotor ?? SubsystemStatus.unknown,
      Subsystem.frontRightMotor: systemInfo?.frontRightMotor ?? SubsystemStatus.unknown,
      Subsystem.rearRightMotor: systemInfo?.rearRightMotor ?? SubsystemStatus.unknown,
      Subsystem.uhfRadio: computeCommInfo?.uhfRadio ?? SubsystemStatus.unknown,
      Subsystem.lBandRadio: computeCommInfo?.lBandRadio ?? SubsystemStatus.unknown,
      Subsystem.compute: computeCommInfo?.compute ?? SubsystemStatus.unknown,
    };
  }
}
