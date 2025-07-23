import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/data/models/category.dart';

@UseRowClass(NoteEntity)
class NoteTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get content => text().withLength(min: 1)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get noteTypeId => integer().nullable()();
  IntColumn get userId => integer().nullable()();
}

class NoteEntity {
  int? id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  int? noteTypeId;
  int? userId;
  List<CategoryEntity>? categories;

  NoteEntity({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.noteTypeId,
    this.categories
  });

  @override
  String toString() {
    return 'NoteEntity{id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, noteTypeId: $noteTypeId, userId: $userId, categories: $categories}';
  }

  NoteTableCompanion toCompanion() {
    return NoteTableCompanion(
      id: id == null ? Value.absent() : Value(id!),
      title: Value(title),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      noteTypeId: noteTypeId == null ? Value.absent() : Value(noteTypeId!),
      userId: Value(userId),
    );
  }

  NoteEntity.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      title = json['title'] as String,
      content = json['content'] as String,
      createdAt = DateTime.parse(json['createdAt'] as String),
      updatedAt = DateTime.parse(json['updatedAt'] as String),
      noteTypeId = json['noteTypeId'] as int?,
      userId = json['userId'] as int,
      categories = CategoryEntity.fromJsonArray(json['categories']);

  static Future<List<NoteEntity>> fromJsonArray(List jsonArray) async {
    return jsonArray.map((json) => NoteEntity.fromJson(json)).toList();
  }
}