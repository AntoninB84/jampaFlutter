part of 'reminder_form_bloc.dart';

class ReminderFormState extends Equatable {

  // Whether saving to a persistent schedule or just in-memory
  final bool isSavingPersistentData;

  final ReminderFormElements newReminderFormElements;

  final PositiveValueValidator offsetNumberValidator;
  final bool isValidOffsetNumber;

  final bool isValidReminder;

  const ReminderFormState({
    this.isSavingPersistentData = false,
    required this.newReminderFormElements,
    this.offsetNumberValidator = const PositiveValueValidator.dirty(10),
    this.isValidOffsetNumber = true,
    this.isValidReminder = true,
  });

  @override
  List<Object?> get props => [
    isSavingPersistentData,
    newReminderFormElements,
    offsetNumberValidator,
    isValidOffsetNumber,
    isValidReminder,
  ];

  ReminderFormState copyWith({
    bool? isSavingPersistentData,
    ReminderFormElements? newReminderFormElements,
    PositiveValueValidator? offsetNumberValidator,
    bool? isValidOffsetNumber,
    bool? isValidReminder,
  }) {
    return ReminderFormState(
      isSavingPersistentData: isSavingPersistentData ?? this.isSavingPersistentData,
      newReminderFormElements: newReminderFormElements ?? this.newReminderFormElements,
      offsetNumberValidator: offsetNumberValidator ?? this.offsetNumberValidator,
      isValidOffsetNumber: isValidOffsetNumber ?? this.isValidOffsetNumber,
      isValidReminder: isValidReminder ?? this.isValidReminder,
    );
  }
}