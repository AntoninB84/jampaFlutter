part of 'save_single_date_bloc.dart';

class SaveSingleDateState extends Equatable {
  const SaveSingleDateState({
    this.alreadyInitialized = false,
    this.noteId,
    this.isSavingPersistentDate = false,
    this.scheduleId,
    this.initialSingleDateFormElementIndex,
    required this.newSingleDateFormElements,
    this.isValidDate = true,
    this.hasSubmitted = false,
  });

  final bool alreadyInitialized;

  // Whether saving to a persistent note or just in-memory
  final bool? isSavingPersistentDate;
  final int? scheduleId;
  // If saving to a persistent note, this holds the note ID
  final int? noteId;
  // If editing an existing single date (persistent or in-memory)
  // this holds the initial data index
  final int? initialSingleDateFormElementIndex;

  final SingleDateFormElements newSingleDateFormElements;
  
  final bool isValidDate;
  final bool hasSubmitted;

  SaveSingleDateState copyWith({
    bool? alreadyInitialized,
    int? noteId,
    bool? isSavingPersistentDate,
    int? scheduleId,
    int? initialSingleDateFormElementIndex,
    SingleDateFormElements? newSingleDateFormElements,
    bool? isValidDate,
    bool? hasSubmitted,
  }) {
    return SaveSingleDateState(
      alreadyInitialized: alreadyInitialized ?? this.alreadyInitialized,
      noteId: noteId ?? this.noteId,
      isSavingPersistentDate: isSavingPersistentDate ?? this.isSavingPersistentDate,
      scheduleId: scheduleId ?? this.scheduleId,
      initialSingleDateFormElementIndex: initialSingleDateFormElementIndex ?? this.initialSingleDateFormElementIndex,
      newSingleDateFormElements: newSingleDateFormElements ?? this.newSingleDateFormElements,
      isValidDate: isValidDate ?? this.isValidDate,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }

  @override
  List<Object?> get props => [
      alreadyInitialized,
      noteId,
      isSavingPersistentDate,
      scheduleId,
      initialSingleDateFormElementIndex,
      newSingleDateFormElements,
      isValidDate,
      hasSubmitted
    ];
  }