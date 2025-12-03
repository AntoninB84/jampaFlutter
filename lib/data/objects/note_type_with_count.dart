import '../models/note_type/note_type.dart';

/// A class that combines NoteTypeEntity with the count of notes associated with it.
class NoteTypeWithCount {
  /// The note type entity.
  final NoteTypeEntity noteType;
  /// The count of notes associated with this note type.
  final int noteCount;

  NoteTypeWithCount({
    required this.noteType,
    required this.noteCount,
  });
}