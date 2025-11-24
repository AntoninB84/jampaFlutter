
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/data/models/note_type.dart';

import '../../../data/database.dart';

/// Fake skeleton data used as placeholders while real data is loading for note list view.
NoteListViewData get fakeSkeletonNoteListViewData => NoteListViewData(
  noteId: "0",
  noteTitle: 'Loading...',
  noteTypeName: 'Loading...',
  categoriesNames: 'Loading...',
  schedulesCount: 0,
  recurringSchedulesCount: 0,
  remindersCount: 0,
  noteCreatedAt: DateTime.now(),
  noteUpdatedAt: DateTime.now(),
);

/// Fake skeleton data used as placeholders while real data is loading for category with count.
CategoryWithCount get fakeSkeletonCategoryWithCount => CategoryWithCount(
  category: CategoryEntity(
    id: "0",
    name: 'Loading...',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  noteCount: 0,
);

/// Fake skeleton data used as placeholders while real data is loading for note type with count.
NoteTypeWithCount get fakeSkeletonNoteTypeWithCount => NoteTypeWithCount(
  noteType: NoteTypeEntity(
    id: "0",
    name: 'Loading...',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  noteCount: 0,
);