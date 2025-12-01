part of 'show_note_bloc.dart';

class ShowNoteState extends Equatable {

  /// The note being displayed.
  final NoteEntity? note;

  /// The Quill controller for rich text editing of the note content.
  final QuillController quillController;

  /// List of schedules and their next occurrences associated with the note.
  final List<ScheduleWithNextOccurrence> schedulesAndReminders;

  /// The current status of note operations.
  final UIStatusEnum status;

  /// The current status of schedules loading operations.
  final UIStatusEnum schedulesLoadingStatus;

  /// The current status of note deletion.
  final UIStatusEnum noteDeletionStatus;

  /// The current status of note status change.
  final UIStatusEnum noteStatusChangeStatus;

  const ShowNoteState({
    this.note,
    required this.quillController,
    this.schedulesAndReminders = const [],
    this.status = UIStatusEnum.initial,
    this.schedulesLoadingStatus = UIStatusEnum.initial,
    this.noteDeletionStatus = UIStatusEnum.initial,
    this.noteStatusChangeStatus = UIStatusEnum.initial,
  });

  @override
  List<Object?> get props => [
    note,
    quillController,
    schedulesAndReminders,
    status,
    schedulesLoadingStatus,
    noteDeletionStatus,
    noteStatusChangeStatus
  ];

  ShowNoteState copyWith({
    NoteEntity? note,
    QuillController? quillController,
    List<ScheduleWithNextOccurrence>? schedulesAndReminders,
    UIStatusEnum? status,
    UIStatusEnum? schedulesLoadingStatus,
    UIStatusEnum? noteDeletionStatus,
    UIStatusEnum? noteStatusChangeStatus,
  }) {
    return ShowNoteState(
      note: note ?? this.note,
      quillController: quillController ?? this.quillController,
      schedulesAndReminders: schedulesAndReminders ?? this.schedulesAndReminders,
      status: status ?? this.status,
      schedulesLoadingStatus: schedulesLoadingStatus ?? this.schedulesLoadingStatus,
      noteDeletionStatus: noteDeletionStatus ?? this.noteDeletionStatus,
      noteStatusChangeStatus: noteStatusChangeStatus ?? this.noteStatusChangeStatus,
    );
  }

}