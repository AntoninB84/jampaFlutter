
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/data/models/note_type.dart';

import '../../../data/database.dart';

NoteListViewData get fakeSkeletonNoteListViewData => NoteListViewData(
  noteId: 0,
  noteTitle: 'Loading...',
  noteTypeName: 'Loading...',
  categoriesNames: 'Loading...',
  schedulesCount: 0,
  recurringSchedulesCount: 0,
  alarmsCount: 0,
  noteCreatedAt: DateTime.now(),
);

CategoryWithCount get fakeSkeletonCategoryWithCount => CategoryWithCount(
  category: CategoryEntity(
    id: 0,
    name: 'Loading...',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  noteCount: 0,
);

NoteTypeWithCount get fakeSkeletonNoteTypeWithCount => NoteTypeWithCount(
  noteType: NoteTypeEntity(
    id: 0,
    name: 'Loading...',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  noteCount: 0,
);