part of 'save_recurrent_date_bloc.dart';

class SaveRecurrentDateState extends Equatable {
  const SaveRecurrentDateState({
    this.alreadyInitialized = false,
    this.noteId,
    this.isSavingPersistentDate = false,
    this.initialRecurrentDateFormElementIndex,
    required this.newRecurrentDateFormElements,
    this.intervalDaysValidator = const PositiveValueValidator.pure(),
    this.intervalYearsValidator = const PositiveValueValidator.pure(),
    this.monthDateValidator = const PositiveValueValidator.pure(),
    this.isValidStartDate = true,
    this.isValidEndDate = true,
    this.isValidEndRecurrenceDate = true,
    this.hasSubmitted = false,
  });

  final bool alreadyInitialized;

  // Whether saving to a persistent note or just in-memory
  final bool? isSavingPersistentDate;
  // If saving to a persistent note, this holds the note ID
  final int? noteId;
  // If editing an existing single date (persistent or in-memory)
  // this holds the initial data index
  final int? initialRecurrentDateFormElementIndex;

  final RecurrenceFormElements newRecurrentDateFormElements;

  final PositiveValueValidator intervalDaysValidator;
  final PositiveValueValidator intervalYearsValidator;
  final PositiveValueValidator monthDateValidator;

  final bool isValidStartDate;
  final bool isValidEndDate;
  final bool isValidEndRecurrenceDate;
  final bool hasSubmitted;

  SaveRecurrentDateState copyWith({
    bool? alreadyInitialized,
    int? noteId,
    bool? isSavingPersistentDate,
    int? initialRecurrentDateFormElementIndex,
    RecurrenceFormElements? newRecurrentDateFormElements,
    PositiveValueValidator? intervalDaysValidator,
    PositiveValueValidator? intervalYearsValidator,
    PositiveValueValidator? monthDateValidator,
    bool? isValidStartDate,
    bool? isValidEndDate,
    bool? isValidEndRecurrenceDate,
    bool? hasSubmitted,
  }) {
    return SaveRecurrentDateState(
      alreadyInitialized: alreadyInitialized ?? this.alreadyInitialized,
      noteId: noteId ?? this.noteId,
      isSavingPersistentDate: isSavingPersistentDate ?? this.isSavingPersistentDate,
      initialRecurrentDateFormElementIndex: initialRecurrentDateFormElementIndex ?? this.initialRecurrentDateFormElementIndex,
      newRecurrentDateFormElements: newRecurrentDateFormElements ?? this.newRecurrentDateFormElements,
      intervalDaysValidator: intervalDaysValidator ?? this.intervalDaysValidator,
      intervalYearsValidator: intervalYearsValidator ?? this.intervalYearsValidator,
      monthDateValidator: monthDateValidator ?? this.monthDateValidator,
      isValidStartDate: isValidStartDate ?? this.isValidStartDate,
      isValidEndDate: isValidEndDate ?? this.isValidEndDate,
      isValidEndRecurrenceDate: isValidEndRecurrenceDate ?? this.isValidEndRecurrenceDate,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }

  @override
  List<Object?> get props => [
      alreadyInitialized,
      noteId,
      isSavingPersistentDate,
      initialRecurrentDateFormElementIndex,
      newRecurrentDateFormElements,
      intervalDaysValidator,
      intervalYearsValidator,
      monthDateValidator,
      isValidStartDate,
      isValidEndDate,
      isValidEndRecurrenceDate,
      hasSubmitted
    ];

    bool get checkRecurrenceEndDate {
      if(newRecurrentDateFormElements.selectedRecurrenceEndDate == null) {
        return true;
      }
      if(newRecurrentDateFormElements.selectedRecurrenceEndDate != null) {
        DateTime? start = newRecurrentDateFormElements.selectedStartDateTime;
        DateTime? end = newRecurrentDateFormElements.selectedEndDateTime;
        DateTime recurrenceEnd = newRecurrentDateFormElements.selectedRecurrenceEndDate!;
        if(start != null){
          if(start.isAfter(recurrenceEnd)) {
            return false;
          }
        }
        if(end != null){
          if(end.isAfter(recurrenceEnd)) {
            return false;
          }
        }
      }
      return true;
    }

    bool get checkValidEndDate {
      DateTime? start = newRecurrentDateFormElements.selectedStartDateTime;
      DateTime? end = newRecurrentDateFormElements.selectedEndDateTime;
      if(start != null && end != null) {
        return !end.isBefore(start);
      }
      return true;
    }

    bool get isValidDates {
      return isValidStartDate && isValidEndDate && isValidEndRecurrenceDate;
    }
  }