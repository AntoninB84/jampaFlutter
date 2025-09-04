part of 'save_alarm_cubit.dart';

class SaveAlarmState extends Equatable {

  const SaveAlarmState({
    this.isSavingPersistentAlarm = false,
    this.scheduleId,
    this.initialAlarmFormElementIndex,
    required this.newAlarmFormElements,
    this.offsetNumberValidator = const PositiveValueValidator.pure(),
    this.isValidOffsetNumber = true,
    this.isValidAlarm = true,
    this.hasSubmitted = false,
  });

  // Whether saving to a persistent schedule or just in-memory
  final bool? isSavingPersistentAlarm;
  // If saving to a persistent note, this holds the schedule ID
  final int? scheduleId;
  // If editing an existing alarm, these fields hold the initial data
  final int? initialAlarmFormElementIndex;

  final AlarmFormElements newAlarmFormElements;

  final PositiveValueValidator offsetNumberValidator;
  final bool isValidOffsetNumber;

  final bool isValidAlarm;
  final bool hasSubmitted;

  SaveAlarmState copyWith({
    bool? isSavingPersistentAlarm,
    int? scheduleId,
    int? initialAlarmFormElementIndex,
    AlarmFormElements? newAlarmFormElements,
    PositiveValueValidator? offsetNumberValidator,
    bool? isValidOffsetNumber,
    bool? isValidAlarm,
    bool? hasSubmitted,
  }) {
    return SaveAlarmState(
      isSavingPersistentAlarm: isSavingPersistentAlarm ?? this.isSavingPersistentAlarm,
      scheduleId: scheduleId ?? this.scheduleId,
      initialAlarmFormElementIndex: initialAlarmFormElementIndex ?? this.initialAlarmFormElementIndex,
      newAlarmFormElements: newAlarmFormElements ?? this.newAlarmFormElements,
      offsetNumberValidator: offsetNumberValidator ?? this.offsetNumberValidator,
      isValidOffsetNumber: isValidOffsetNumber ?? this.isValidOffsetNumber,
      isValidAlarm: isValidAlarm ?? this.isValidAlarm,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }

  @override
  List<Object?> get props => [
    isSavingPersistentAlarm,
    scheduleId,
    initialAlarmFormElementIndex,
    newAlarmFormElements,
    offsetNumberValidator,
    isValidOffsetNumber,
    isValidAlarm,
    hasSubmitted,
  ];
}