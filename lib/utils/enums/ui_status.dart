enum UIStatusEnum {
  initial,
  loading,
  success,
  failure,
}

extension UIStatusX on UIStatusEnum {
  bool get isInitial => this == UIStatusEnum.initial;
  bool get isLoading => this == UIStatusEnum.loading;
  bool get isSuccess => this == UIStatusEnum.success;
  bool get isFailure => this == UIStatusEnum.failure;
}