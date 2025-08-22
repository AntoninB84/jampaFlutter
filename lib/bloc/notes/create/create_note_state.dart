part of 'create_note_cubit.dart';

class CreateNoteState extends Equatable {
  const CreateNoteState({
    this.note,
    this.title = const NameValidator.pure(),
    this.isValidTitle = true,
    this.content = const ContentValidator.pure(),
    this.isValidContent = true,
    this.isLoading = false,
    this.isError = false,
    this.isSuccess = false,
  });

  final NoteEntity? note;
  
  final NameValidator title;
  final bool isValidTitle;
  final ContentValidator content;
  final bool isValidContent;
  
  final bool isLoading;
  final bool isError;
  final bool isSuccess;

  @override
  List<Object?> get props => [
    note,
    title,
    isValidTitle,
    content,
    isValidContent,
    isLoading,
    isError,
    isSuccess
  ];

  CreateNoteState copyWith({
    NoteEntity? note,
    NameValidator? title,
    bool? isValidTitle,
    ContentValidator? content,
    bool? isValidContent,
    bool? isLoading,
    bool? isError,
    bool? isSuccess,
  }) {
    return CreateNoteState(
      note: note ?? this.note,
      title: title ?? this.title,
      isValidTitle: isValidTitle ?? this.isValidTitle,
      content: content ?? this.content,
      isValidContent: isValidContent ?? this.isValidContent,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}