part of 'save_single_date_cubit.dart';

class SaveSingleDateState extends Equatable {
  const SaveSingleDateState({
    this.noteId,
    this.isSavingPersistentDate = false,
    this.initialSingleDateFormElements,
    this.initialSingleDateFormElementIndex,
    this.createdSingleDateFormElements,
    this.selectedStartDateTime,
    this.selectedEndDateTime,
    this.isValidDate = true,
    this.hasSubmitted = false,
  });

  final bool? isSavingPersistentDate;
  // If saving to a persistent note, this holds the note ID
  final int? noteId;

  // If editing an existing single date, these fields hold the initial data
  final SingleDateFormElements? initialSingleDateFormElements;
  final int? initialSingleDateFormElementIndex;

  final SingleDateFormElements? createdSingleDateFormElements;
  
  final DateTime? selectedStartDateTime;
  final DateTime? selectedEndDateTime;
  final bool isValidDate;
  final bool hasSubmitted;

  SaveSingleDateState copyWith({
    int? noteId,
    bool? isSavingPersistentDate,
    SingleDateFormElements? initialSingleDateFormElements,
    int? initialSingleDateFormElementIndex,
    SingleDateFormElements? createdSingleDateFormElements,
    DateTime? selectedStartDateTime,
    DateTime? selectedEndDateTime,
    bool? isValidDate,
    bool? hasSubmitted,
  }) {
    return SaveSingleDateState(
      noteId: noteId ?? this.noteId,
      isSavingPersistentDate: isSavingPersistentDate ?? this.isSavingPersistentDate,
      initialSingleDateFormElements: initialSingleDateFormElements ?? this.initialSingleDateFormElements,
      initialSingleDateFormElementIndex: initialSingleDateFormElementIndex ?? this.initialSingleDateFormElementIndex,
      createdSingleDateFormElements: createdSingleDateFormElements ?? this.createdSingleDateFormElements,
      selectedStartDateTime: selectedStartDateTime ?? this.selectedStartDateTime,
      selectedEndDateTime: selectedEndDateTime ?? this.selectedEndDateTime,
      isValidDate: isValidDate ?? this.isValidDate,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }

  @override
  List<Object?> get props => [
      noteId,
      isSavingPersistentDate,
      initialSingleDateFormElements,
      initialSingleDateFormElementIndex,
      createdSingleDateFormElements,
      selectedStartDateTime,
      selectedEndDateTime,
      isValidDate,
      hasSubmitted
    ];
  }