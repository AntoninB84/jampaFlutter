part of 'save_recurrent_date_list_bloc.dart';

class SaveRecurrentDateListState extends Equatable {
  const SaveRecurrentDateListState({
    this.recurrentDateListStatus = UIListStatusEnum.loading,
    this.recurrentDateElements = const [],
  });

  final UIListStatusEnum recurrentDateListStatus;
  final List<RecurrenceFormElements> recurrentDateElements;

  SaveRecurrentDateListState copyWith({
    UIListStatusEnum? recurrentDateListStatus,
    List<RecurrenceFormElements>? recurrentDateElements,
  }) {
    return SaveRecurrentDateListState(
      recurrentDateListStatus: recurrentDateListStatus ?? this.recurrentDateListStatus,
      recurrentDateElements: recurrentDateElements ?? this.recurrentDateElements,
    );
  }

  @override
  List<Object?> get props => [
    recurrentDateListStatus,
    recurrentDateElements,
  ];
}