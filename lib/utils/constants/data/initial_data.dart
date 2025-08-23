import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/data/models/note_type.dart';

class InitialData {
  static List<CategoryEntity> categories = [
    CategoryEntity(id: null, name: "Sport", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    CategoryEntity(id: null, name: "Musique", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    CategoryEntity(id: null, name: "Projet", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    CategoryEntity(id: null, name: "Travail", createdAt: DateTime.now(), updatedAt: DateTime.now()),
  ];

  static List<NoteTypeEntity> noteTypes = [
    NoteTypeEntity(id: null, name: "Idée", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    NoteTypeEntity(id: null, name: "Reminder", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    NoteTypeEntity(id: null, name: "Event", createdAt: DateTime.now(), updatedAt: DateTime.now()),
  ];
}