part of 'save_single_date_cubit.dart';

class SaveSingleDateState extends Equatable {
  const SaveSingleDateState({
    this.noteId,
    this.isSavingPersistentDate = false,
    this.initialSingleDateFormElementIndex,
    required this.newSingleDateFormElements,
    this.isValidDate = true,
    this.hasSubmitted = false,
  });

  // Whether saving to a persistent note or just in-memory
  final bool? isSavingPersistentDate;
  // If saving to a persistent note, this holds the note ID
  final int? noteId;
  // If editing an existing single date (persistent or in-memory)
  // this holds the initial data index
  final int? initialSingleDateFormElementIndex;

  final SingleDateFormElements newSingleDateFormElements;
  
  final bool isValidDate;
  final bool hasSubmitted;

  SaveSingleDateState copyWith({
    int? noteId,
    bool? isSavingPersistentDate,
    int? initialSingleDateFormElementIndex,
    SingleDateFormElements? newSingleDateFormElements,
    bool? isValidDate,
    bool? hasSubmitted,
  }) {
    return SaveSingleDateState(
      noteId: noteId ?? this.noteId,
      isSavingPersistentDate: isSavingPersistentDate ?? this.isSavingPersistentDate,
      initialSingleDateFormElementIndex: initialSingleDateFormElementIndex ?? this.initialSingleDateFormElementIndex,
      newSingleDateFormElements: newSingleDateFormElements ?? this.newSingleDateFormElements,
      isValidDate: isValidDate ?? this.isValidDate,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }

  @override
  List<Object?> get props => [
      noteId,
      isSavingPersistentDate,
      initialSingleDateFormElementIndex,
      newSingleDateFormElements,
      isValidDate,
      hasSubmitted
    ];
  }