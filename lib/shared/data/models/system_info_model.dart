import 'dart:typed_data';

typedef UgvMotorError = int;
const UgvMotorError ugvMotorErrorOverSpeed = 1;
const UgvMotorError ugvMotorErrorOverload = 2;
const UgvMotorError ugvMotorErrorPhaseLoss = 4;
const UgvMotorError ugvMotorErrorBrakeFault = 8;
const UgvMotorError ugvMotorErrorEncoderFault = 16;
const UgvMotorError ugvMotorErrorOverTemperature = 32;
const UgvMotorError ugvMotorErrorHallFault = 64;
const UgvMotorError ugvMotorErrorStalled = 128;

typedef UgvMotorCtrlError = int;
const UgvMotorCtrlError ugvMotorCtrlErrorDrive = 1;
const UgvMotorCtrlError ugvMotorCtrlErrorOverCurrent = 2;
const UgvMotorCtrlError ugvMotorCtrlErrorOverPressure = 4;
const UgvMotorCtrlError ugvMotorCtrlErrorUnderVoltage = 8;
const UgvMotorCtrlError ugvMotorCtrlErrorOverTemperature = 16;
const UgvMotorCtrlError ugvMotorCtrlErrorCanComm = 32;

typedef UgvSubMode = int;

const UgvSubMode none = 0;

const UgvSubMode hold = 10;

typedef ModeChangeReason = int;

const ModeChangeReason gcsCommand = 0;

const ModeChangeReason failsafe = 1;

const ModeChangeReason sensorFault = 2;

const ModeChangeReason commLoss = 3;


typedef UgvMainMode = int;

const UgvMainMode modeA = 1;

const UgvMainMode modeB = 2;

typedef UgvHealthState = int;

const UgvHealthState reservedState = 0;

const UgvHealthState noCommunicationState = 1;

const UgvHealthState communicatingHealthyState = 2;

const UgvHealthState faultState = 3;

class UgvSystemInfo {
  static const int length = 20;

  int get messageId => length;

  final UgvHealthState subsystemHealth1;

  final UgvHealthState subsystemHealth2;

  final UgvHealthState subsystemHealth3;

  final UgvHealthState subsystemHealth4;

  final int batterySoc;

  final UgvMainMode mainMode;

  final UgvSubMode subMode;

  final UgvMainMode intendedMainMode;

  final UgvSubMode intendedSubMode;

  final ModeChangeReason modeChangeReason;

  final UgvMotorError rearLeftMotorFaults;

  final UgvMotorError rearRightMotorFaults;

  final UgvMotorError frontLeftMotorFaults;

  final UgvMotorError frontRightMotorFaults;

  final UgvMotorCtrlError leftMcFaults;

  final UgvMotorCtrlError rightMcFaults;

  final int leftMcVoltage;

  final int rightMcVoltage;

  final int leftMcTemperature;

  final int rightMcTemperature;

  UgvSystemInfo({
    required this.subsystemHealth1,
    required this.subsystemHealth2,
    required this.subsystemHealth3,
    required this.subsystemHealth4,
    required this.batterySoc,
    required this.mainMode,
    required this.subMode,
    required this.intendedMainMode,
    required this.intendedSubMode,
    required this.modeChangeReason,
    required this.rearLeftMotorFaults,
    required this.rearRightMotorFaults,
    required this.frontLeftMotorFaults,
    required this.frontRightMotorFaults,
    required this.leftMcFaults,
    required this.rightMcFaults,
    required this.leftMcVoltage,
    required this.rightMcVoltage,
    required this.leftMcTemperature,
    required this.rightMcTemperature,
  });

  UgvSystemInfo copyWith({
    UgvHealthState? subsystemHealth1,
    UgvHealthState? subsystemHealth2,
    UgvHealthState? subsystemHealth3,
    UgvHealthState? subsystemHealth4,
    int? batterySoc,
    UgvMainMode? mainMode,
    UgvSubMode? subMode,
    UgvMainMode? intendedMainMode,
    UgvSubMode? intendedSubMode,
    ModeChangeReason? modeChangeReason,
    UgvMotorError? rearLeftMotorFaults,
    UgvMotorError? rearRightMotorFaults,
    UgvMotorError? frontLeftMotorFaults,
    UgvMotorError? frontRightMotorFaults,
    UgvMotorCtrlError? leftMcFaults,
    UgvMotorCtrlError? rightMcFaults,
    int? leftMcVoltage,
    int? rightMcVoltage,
    int? leftMcTemperature,
    int? rightMcTemperature,
  }) {
    return UgvSystemInfo(
      subsystemHealth1: subsystemHealth1 ?? this.subsystemHealth1,
      subsystemHealth2: subsystemHealth2 ?? this.subsystemHealth2,
      subsystemHealth3: subsystemHealth3 ?? this.subsystemHealth3,
      subsystemHealth4: subsystemHealth4 ?? this.subsystemHealth4,
      batterySoc: batterySoc ?? this.batterySoc,
      mainMode: mainMode ?? this.mainMode,
      subMode: subMode ?? this.subMode,
      intendedMainMode: intendedMainMode ?? this.intendedMainMode,
      intendedSubMode: intendedSubMode ?? this.intendedSubMode,
      modeChangeReason: modeChangeReason ?? this.modeChangeReason,
      rearLeftMotorFaults: rearLeftMotorFaults ?? this.rearLeftMotorFaults,
      rearRightMotorFaults: rearRightMotorFaults ?? this.rearRightMotorFaults,
      frontLeftMotorFaults: frontLeftMotorFaults ?? this.frontLeftMotorFaults,
      frontRightMotorFaults:
      frontRightMotorFaults ?? this.frontRightMotorFaults,
      leftMcFaults: leftMcFaults ?? this.leftMcFaults,
      rightMcFaults: rightMcFaults ?? this.rightMcFaults,
      leftMcVoltage: leftMcVoltage ?? this.leftMcVoltage,
      rightMcVoltage: rightMcVoltage ?? this.rightMcVoltage,
      leftMcTemperature: leftMcTemperature ?? this.leftMcTemperature,
      rightMcTemperature: rightMcTemperature ?? this.rightMcTemperature,
    );
  }

  factory UgvSystemInfo.parse(ByteData data_) {
    if (data_.lengthInBytes < UgvSystemInfo.length) {
      var len = UgvSystemInfo.length - data_.lengthInBytes;
      var d = data_.buffer.asUint8List().sublist(0, data_.lengthInBytes) +
          List<int>.filled(len, 0);
      data_ = Uint8List.fromList(d).buffer.asByteData();
    }
    var subsystemHealth1 = data_.getUint8(0);
    var subsystemHealth2 = data_.getUint8(1);
    var subsystemHealth3 = data_.getUint8(2);
    var subsystemHealth4 = data_.getUint8(3);
    var batterySoc = data_.getUint8(4);
    var mainMode = data_.getUint8(5);
    var subMode = data_.getUint8(6);
    var intendedMainMode = data_.getUint8(7);
    var intendedSubMode = data_.getUint8(8);
    var modeChangeReason = data_.getUint8(9);
    var rearLeftMotorFaults = data_.getUint8(10);
    var rearRightMotorFaults = data_.getUint8(11);
    var frontLeftMotorFaults = data_.getUint8(12);
    var frontRightMotorFaults = data_.getUint8(13);
    var leftMcFaults = data_.getUint8(14);
    var rightMcFaults = data_.getUint8(15);
    var leftMcVoltage = data_.getUint8(16);
    var rightMcVoltage = data_.getUint8(17);
    var leftMcTemperature = data_.getUint8(18);
    var rightMcTemperature = data_.getUint8(19);

    return UgvSystemInfo(
        subsystemHealth1: subsystemHealth1,
        subsystemHealth2: subsystemHealth2,
        subsystemHealth3: subsystemHealth3,
        subsystemHealth4: subsystemHealth4,
        batterySoc: batterySoc,
        mainMode: mainMode,
        subMode: subMode,
        intendedMainMode: intendedMainMode,
        intendedSubMode: intendedSubMode,
        modeChangeReason: modeChangeReason,
        rearLeftMotorFaults: rearLeftMotorFaults,
        rearRightMotorFaults: rearRightMotorFaults,
        frontLeftMotorFaults: frontLeftMotorFaults,
        frontRightMotorFaults: frontRightMotorFaults,
        leftMcFaults: leftMcFaults,
        rightMcFaults: rightMcFaults,
        leftMcVoltage: leftMcVoltage,
        rightMcVoltage: rightMcVoltage,
        leftMcTemperature: leftMcTemperature,
        rightMcTemperature: rightMcTemperature);
  }

  @override
  List<Object?> get props => [
    subsystemHealth1,
    subsystemHealth2,
    subsystemHealth3,
    subsystemHealth4,
    batterySoc,
    mainMode,
    subMode,
    intendedMainMode,
    intendedSubMode,
    modeChangeReason,
    rearLeftMotorFaults,
    rearRightMotorFaults,
    frontLeftMotorFaults,
    frontRightMotorFaults,
    leftMcFaults,
    rightMcFaults,
    leftMcVoltage,
    rightMcVoltage,
    leftMcTemperature,
    rightMcTemperature
  ];

  @override
  ByteData serialize() {
    var data_ = ByteData(length);
    data_.setUint8(0, subsystemHealth1);
    data_.setUint8(1, subsystemHealth2);
    data_.setUint8(2, subsystemHealth3);
    data_.setUint8(3, subsystemHealth4);
    data_.setUint8(4, batterySoc);
    data_.setUint8(5, mainMode);
    data_.setUint8(6, subMode);
    data_.setUint8(7, intendedMainMode);
    data_.setUint8(8, intendedSubMode);
    data_.setUint8(9, modeChangeReason);
    data_.setUint8(10, rearLeftMotorFaults);
    data_.setUint8(11, rearRightMotorFaults);
    data_.setUint8(12, frontLeftMotorFaults);
    data_.setUint8(13, frontRightMotorFaults);
    data_.setUint8(14, leftMcFaults);
    data_.setUint8(15, rightMcFaults);
    data_.setUint8(16, leftMcVoltage);
    data_.setUint8(17, rightMcVoltage);
    data_.setUint8(18, leftMcTemperature);
    data_.setUint8(19, rightMcTemperature);
    return data_;
  }

  @override
  String toString() {
    return 'subsystemHealth1: $subsystemHealth1, '
        'subsystemHealth2: $subsystemHealth2, '
        'subsystemHealth3: $subsystemHealth3, '
        'subsystemHealth4: $subsystemHealth4, '
        'batterySoc: $batterySoc, '
        'mainMode: $mainMode, '
        'subMode: $subMode, '
        'intendedMainMode: $intendedMainMode, '
        'intendedSubMode: $intendedSubMode, '
        'modeChangeReason: $modeChangeReason, '
        'rearLeftMotorFaults: $rearLeftMotorFaults, '
        'rearRightMotorFaults: $rearRightMotorFaults, '
        'frontLeftMotorFaults: $frontLeftMotorFaults, '
        'frontRightMotorFaults: $frontRightMotorFaults, '
        'leftMcFaults: $leftMcFaults, '
        'rightMcFaults: $rightMcFaults, '
        'leftMcVoltage: $leftMcVoltage, '
        'rightMcVoltage: $rightMcVoltage, '
        'leftMcTemperature: $leftMcTemperature, '
        'rightMcTemperature: $rightMcTemperature, ';
  }
}
