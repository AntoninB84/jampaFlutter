import 'package:formz/formz.dart';

enum ContentValidationError {
  empty,
  invalidLength
}

extension ContentValidationErrorX on ContentValidationError {
  bool get isEmpty => this == ContentValidationError.empty;
}

class ContentValidator extends FormzInput<String, ContentValidationError> {
  const ContentValidator.pure() : super.pure('');
  const ContentValidator.dirty([String value = '']) : super.dirty(value);

  @override
  ContentValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return ContentValidationError.empty;
    }
    return null;
  }
}