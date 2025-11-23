part of 'save_note_bloc.dart';

enum SavingStatus { initial, saving, added, saved, failure }

extension SavingStatusX on SavingStatus {
  bool get isInitial => this == SavingStatus.initial;
  bool get isSaving => this == SavingStatus.saving;
  bool get isAdded => this == SavingStatus.added;
  bool get isSaved => this == SavingStatus.saved;
  bool get isSuccessful => this == SavingStatus.added || this == SavingStatus.saved;
  bool get isFailure => this == SavingStatus.failure;
}

class SaveNoteState extends Equatable {
  const SaveNoteState(
  {
    this.note,
    this.noteSavingStatus = SavingStatus.initial,
    this.singleDateSchedules = const [],
    this.singleDateSavingStatus = SavingStatus.initial,
    this.recurrentSchedules = const [],
    this.recurrentSavingStatus = SavingStatus.initial,
    this.reminders = const [],
    this.remindersSavingStatus = SavingStatus.initial,
  });

  /// The note being created or edited, if any
  final NoteEntity? note;
  /// The status of the saving operation for the note entity only
  final SavingStatus noteSavingStatus;

  /// Single date schedules associated with the note
  final List<ScheduleEntity> singleDateSchedules;
  /// The status of the saving operation for single date schedules
  final SavingStatus singleDateSavingStatus;

  /// Recurrent schedules associated with the note
  final List<ScheduleEntity> recurrentSchedules;
  /// The status of the saving operation for recurrent schedules
  final SavingStatus recurrentSavingStatus;

  /// Reminders associated with the note
  final List<ReminderEntity> reminders;
  /// The status of the saving operation for reminders
  final SavingStatus remindersSavingStatus;

  @override
  List<Object?> get props => [
    note,
    noteSavingStatus,
    singleDateSchedules,
    singleDateSavingStatus,
    recurrentSchedules,
    recurrentSavingStatus,
    reminders,
    remindersSavingStatus,
  ];

  SaveNoteState copyWith({
    NoteEntity? note,
    SavingStatus? noteSavingStatus,
    List<ScheduleEntity>? singleDateSchedules,
    SavingStatus? singleDateSavingStatus,
    List<ScheduleEntity>? recurrentSchedules,
    SavingStatus? recurrentSavingStatus,
    List<ReminderEntity>? reminders,
    SavingStatus? remindersSavingStatus,
  }) {
    return SaveNoteState(
      note: note ?? this.note,
      noteSavingStatus: noteSavingStatus ?? this.noteSavingStatus,
      singleDateSchedules: singleDateSchedules ?? this.singleDateSchedules,
      singleDateSavingStatus: singleDateSavingStatus ?? this.singleDateSavingStatus,
      recurrentSchedules: recurrentSchedules ?? this.recurrentSchedules,
      recurrentSavingStatus: recurrentSavingStatus ?? this.recurrentSavingStatus,
      reminders: reminders ?? this.reminders,
      remindersSavingStatus: remindersSavingStatus ?? this.remindersSavingStatus,
    );
  }
}
