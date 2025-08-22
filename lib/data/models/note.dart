import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/data/models/note_type.dart';
import 'package:jampa_flutter/data/models/user.dart';

@UseRowClass(NoteEntity)
class NoteTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get content => text().withLength(min: 1)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get noteTypeId => integer().references(NoteTypeTable, #id).nullable()();
  IntColumn get userId => integer().references(UserTable, #id).nullable()();
}

class NoteEntity {
  int? id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  int? noteTypeId;
  NoteTypeEntity? noteType;
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
    this.noteType,
    this.categories
  });

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

  @override
  String toString() {
    return 'NoteEntity{id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, noteTypeId: $noteTypeId, userId: $userId, categories: $categories}';
  }

  NoteEntity copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? noteTypeId,
    NoteTypeEntity? noteType,
    int? userId,
    List<CategoryEntity>? categories
  }) {
    return NoteEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      noteTypeId: noteTypeId ?? this.noteTypeId,
      noteType: noteType ?? this.noteType,
      userId: userId ?? this.userId,
      categories: categories ?? this.categories
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