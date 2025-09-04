part of 'single_date_list_bloc.dart';

class SingleDateListState extends Equatable {
  const SingleDateListState({
    this.singleDateListStatus = UIListStatusEnum.loading,
    this.singleDateElements = const [],
  });

  final UIListStatusEnum singleDateListStatus;
  final List<SingleDateFormElements> singleDateElements;

  SingleDateListState copyWith({
    UIListStatusEnum? singleDateListStatus,
    List<SingleDateFormElements>? singleDateElements,
  }) {
    return SingleDateListState(
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