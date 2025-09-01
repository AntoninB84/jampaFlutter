part of 'create_single_date_cubit.dart';

class CreateSingleDateState extends Equatable {
  const CreateSingleDateState({
    this.initialSingleDateFormElements,
    this.initialSingleDateFormElementIndex,
    this.createdSingleDateFormElements,
    this.selectedStartDateTime,
    this.selectedEndDateTime,
    this.isValidDate = true,
    this.hasSubmitted = false,
  });

  final SingleDateFormElements? initialSingleDateFormElements;
  final int? initialSingleDateFormElementIndex;
  final SingleDateFormElements? createdSingleDateFormElements;
  
  final DateTime? selectedStartDateTime;
  final DateTime? selectedEndDateTime;
  final bool isValidDate;
  final bool hasSubmitted;

  CreateSingleDateState copyWith({
    SingleDateFormElements? initialSingleDateFormElements,
    int? initialSingleDateFormElementIndex,
    SingleDateFormElements? createdSingleDateFormElements,
    DateTime? selectedStartDateTime,
    DateTime? selectedEndDateTime,
    bool? isValidDate,
    bool? hasSubmitted,
  }) {
    return CreateSingleDateState(
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
      initialSingleDateFormElements,
      initialSingleDateFormElementIndex,
      createdSingleDateFormElements,
      selectedStartDateTime,
      selectedEndDateTime,
      isValidDate,
      hasSubmitted
    ];
  }