part of 'reminder_form_bloc.dart';

class ReminderFormState extends Equatable {
  /// Indicates whether the form is editing an existing reminder or creating a new one.
  final bool isEditing;

  /// Holds the form elements for the new reminder.
  final ReminderFormElements newReminderFormElements;

  /// Validator for the offset number input field.
  final PositiveValueValidator offsetNumberValidator;

  const ReminderFormState({
    this.isEditing = false,
    required this.newReminderFormElements,
    this.offsetNumberValidator = const PositiveValueValidator.dirty(10),
  });

  @override
  List<Object?> get props => [
    isEditing,
    newReminderFormElements,
    offsetNumberValidator,
  ];

  ReminderFormState copyWith({
    bool? isEditing,
    ReminderFormElements? newReminderFormElements,
    PositiveValueValidator? offsetNumberValidator,
    bool? isValidReminder,
  }) {
    return ReminderFormState(
      isEditing: isEditing ?? this.isEditing,
      newReminderFormElements: newReminderFormElements ?? this.newReminderFormElements,
      offsetNumberValidator: offsetNumberValidator ?? this.offsetNumberValidator,
    );
  }

  bool get isValidOffsetNumber {
    return !offsetNumberValidator.isPure && offsetNumberValidator.isValid;
  }

  bool get canSubmitForm {
    return isValidOffsetNumber;
  }
}