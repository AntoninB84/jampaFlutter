part of 'single_date_form_bloc.dart';

class SingleDateFormState extends Equatable {

  /// Indicates whether the form is in editing mode
  final bool isEditing;

  /// The form elements for the single date form
  final SingleDateFormElements newSingleDateFormElements;

  /// Indicates whether the selected dates are valid
  final bool isValidDate;

  const SingleDateFormState({
    this.isEditing = false,
    required this.newSingleDateFormElements,
    this.isValidDate = true,
  });

  @override
  List<Object?> get props => [
    isEditing,
    newSingleDateFormElements,
    isValidDate,
  ];

  SingleDateFormState copyWith({
    bool? isEditing,
    SingleDateFormElements? newSingleDateFormElements,
    bool? isValidDate,
  }) {
    return SingleDateFormState(
      isEditing: isEditing ?? this.isEditing,
      newSingleDateFormElements: newSingleDateFormElements ?? this.newSingleDateFormElements,
      isValidDate: isValidDate ?? this.isValidDate,
    );
  }
}

