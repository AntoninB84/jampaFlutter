part of 'save_single_date_list_bloc.dart';

class SaveSingleDateListState extends Equatable {
  const SaveSingleDateListState({
    this.singleDateListStatus = UIListStatusEnum.loading,
    this.singleDateElements = const [],
  });

  final UIListStatusEnum singleDateListStatus;
  final List<SingleDateFormElements> singleDateElements;

  SaveSingleDateListState copyWith({
    UIListStatusEnum? singleDateListStatus,
    List<SingleDateFormElements>? singleDateElements,
  }) {
    return SaveSingleDateListState(
      singleDateListStatus: singleDateListStatus ?? this.singleDateListStatus,
      singleDateElements: singleDateElements ?? this.singleDateElements,
    );
  }

  @override
  List<Object?> get props => [
    singleDateListStatus,
    singleDateElements,
  ];
}