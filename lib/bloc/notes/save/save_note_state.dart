part of 'save_note_bloc.dart';

class SaveNoteState extends Equatable {
  const SaveNoteState(
  {
    this.hasFetchedData = false,
    this.note,
    this.noteSavingStatus = .initial,
    this.singleDateSchedules = const [],
    this.singleDateSavingStatus = .initial,
    this.recurrentSchedules = const [],
    this.recurrentSavingStatus = .initial,
    this.reminders = const [],
    this.remindersSavingStatus = .initial,
  });

  /// Prevent calls to fetch data multiple times
  final bool hasFetchedData;

  /// The note being created or edited, if any
  final NoteEntity? note;
  /// The status of the saving operation for the note entity only
  final UIStatusEnum noteSavingStatus;

  /// Single date schedules associated with the note
  final List<ScheduleEntity> singleDateSchedules;
  /// The status of the saving operation for single date schedules
  final UIStatusEnum singleDateSavingStatus;

  /// Recurrent schedules associated with the note
  final List<ScheduleEntity> recurrentSchedules;
  /// The status of the saving operation for recurrent schedules
  final UIStatusEnum recurrentSavingStatus;

  /// Reminders associated with the note
  final List<ReminderEntity> reminders;
  /// The status of the saving operation for reminders
  final UIStatusEnum remindersSavingStatus;

  @override
  List<Object?> get props => [
    hasFetchedData,
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
    bool? hasFetchedData,
    NoteEntity? note,
    UIStatusEnum? noteSavingStatus,
    List<ScheduleEntity>? singleDateSchedules,
    UIStatusEnum? singleDateSavingStatus,
    List<ScheduleEntity>? recurrentSchedules,
    UIStatusEnum? recurrentSavingStatus,
    List<ReminderEntity>? reminders,
    UIStatusEnum? remindersSavingStatus,
  }) {
    return SaveNoteState(
      hasFetchedData: hasFetchedData ?? this.hasFetchedData,
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

  bool get isSavingInProgress {
    return noteSavingStatus.isLoading ||
        singleDateSavingStatus.isLoading ||
        recurrentSavingStatus.isLoading ||
        remindersSavingStatus.isLoading;
  }
}
