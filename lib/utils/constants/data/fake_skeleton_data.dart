
import '../../../data/database.dart';

NoteListViewData get fakeSkeletonNoteListViewData => NoteListViewData(
  noteId: 0,
  noteTitle: 'Loading...',
  noteTypeName: 'Loading...',
  categoriesNames: 'Loading...',
  noteCreatedAt: DateTime.now(),
);