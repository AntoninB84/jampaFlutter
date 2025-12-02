enum UIStatusEnum {
  initial,
  loading,
  success,
  failure,
}

extension UIStatusX on UIStatusEnum {
  bool get isInitial => this == .initial;
  bool get isLoading => this == .loading;
  bool get isSuccess => this == .success;
  bool get isFailure => this == .failure;
}