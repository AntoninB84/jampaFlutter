import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/data/models/note_type.dart';
import 'package:jampa_flutter/data/models/user.dart';
import 'package:jampa_flutter/utils/enums/note_status_enum.dart';

@UseRowClass(NoteEntity)
class NoteTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get content => text().nullable()();
  BoolColumn get isImportant => boolean().withDefault(const Constant(false))();
  TextColumn get status => textEnum<NoteStatusEnum>().withDefault(Constant(NoteStatusEnum.todo.name))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get noteTypeId => integer().references(NoteTypeTable, #id).nullable()();
  IntColumn get userId => integer().references(UserTable, #id).nullable()();
}

class NoteEntity {
  String id;
  String title;
  String? content;
  bool isImportant;
  NoteStatusEnum status;
  DateTime createdAt;
  DateTime updatedAt;
  int? noteTypeId;
  NoteTypeEntity? noteType;
  int? userId;
  List<CategoryEntity>? categories;

  NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    this.isImportant = false,
    this.status = NoteStatusEnum.todo,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.noteTypeId,
    this.noteType,
    this.categories
  });

  NoteTableCompanion toCompanion() {
    return NoteTableCompanion(
      id: Value(id),
      title: Value(title),
      content: content == null ? Value.absent() : Value(content!),
      isImportant: Value(isImportant),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      noteTypeId: noteTypeId == null ? Value.absent() : Value(noteTypeId!),
      userId: Value(userId),
    );
  }

  @override
  String toString() {
    return 'NoteEntity{'
        'id: $id, '
        'title: $title, '
        'content: $content, '
        'isImportant: $isImportant, '
        'state: $status, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'noteTypeId: $noteTypeId, '
        'userId: $userId, '
        'categories: $categories'
      '}';
  }

  NoteEntity copyWith({
    String? id,
    String? title,
    String? content,
    bool? isImportant,
    NoteStatusEnum? status,
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
      isImportant: isImportant ?? this.isImportant,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      noteTypeId: noteTypeId ?? this.noteTypeId,
      noteType: noteType ?? this.noteType,
      userId: userId ?? this.userId,
      categories: categories ?? this.categories
    );
  }

  NoteEntity.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      title = json['title'] as String,
      content = json['content'] as String?,
      isImportant = json['isImportant'] as bool? ?? false,
      status = NoteStatusEnum.values.firstWhere(
              (e) => e.name == (json['status'] as String?),
          orElse: () => NoteStatusEnum.todo),
      createdAt = DateTime.parse(json['createdAt'] as String),
      updatedAt = DateTime.parse(json['updatedAt'] as String),
      noteTypeId = json['noteTypeId'] as int?,
      userId = json['userId'] as int,
      categories = CategoryEntity.fromJsonArray(json['categories']);

  static Future<List<NoteEntity>> fromJsonArray(List jsonArray) async {
    return jsonArray.map((json) => NoteEntity.fromJson(json)).toList();
  }
}