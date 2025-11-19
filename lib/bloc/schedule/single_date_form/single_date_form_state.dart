part of 'single_date_form_bloc.dart';

class SingleDateFormState extends Equatable {
  /// To determine how to handle calls to [SaveNoteBloc]
  final bool isSavingPersistentData;

  final SingleDateFormElements newSingleDateFormElements;

  final bool isValidDate;

  const SingleDateFormState({
    this.isSavingPersistentData = false,
    required this.newSingleDateFormElements,
    this.isValidDate = true,
  });

  @override
  List<Object?> get props => [
    isSavingPersistentData,
    newSingleDateFormElements,
    isValidDate,
  ];

  SingleDateFormState copyWith({
    bool? isSavingPersistentData,
    SingleDateFormElements? newSingleDateFormElements,
    bool? isValidDate,
  }) {
    return SingleDateFormState(
      isSavingPersistentData: isSavingPersistentData ?? this.isSavingPersistentData,
      newSingleDateFormElements: newSingleDateFormElements ?? this.newSingleDateFormElements,
      isValidDate: isValidDate ?? this.isValidDate,
    );
  }
}

