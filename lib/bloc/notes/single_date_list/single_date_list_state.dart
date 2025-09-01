part of 'single_date_list_bloc.dart';

enum SingleDateListStatus { loading, success, error }

class SingleDateListState extends Equatable {
  const SingleDateListState({
    this.singleDateListStatus = SingleDateListStatus.loading,
    this.singleDateElements = const [],
  });

  final SingleDateListStatus singleDateListStatus;
  final List<SingleDateFormElements> singleDateElements;

  SingleDateListState copyWith({
    SingleDateListStatus? singleDateListStatus,
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