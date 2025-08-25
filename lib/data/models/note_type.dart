
import 'package:drift/drift.dart';
import '../database.dart';

class NoteTypeWithCount {
  final NoteTypeEntity noteType;
  final int noteCount;

  NoteTypeWithCount({
    required this.noteType,
    required this.noteCount,
  });
}

@UseRowClass(NoteTypeEntity)
class NoteTypeTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class NoteTypeEntity {
  int? id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  NoteTypeEntity({
    this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  String toString() {
    return 'NoteTypeEntity{id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  NoteTypeEntity copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteTypeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteTypeEntity &&
        other.id == id &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  NoteTypeTableCompanion toCompanion() {
    return NoteTypeTableCompanion(
      id: id == null ? Value.absent() : Value(id!),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  NoteTypeEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String,
        createdAt = DateTime.parse(json['createdAt'] as String),
        updatedAt = DateTime.parse(json['updatedAt'] as String);

  static List<NoteTypeEntity> fromJsonArray(List jsonArray) {
    return jsonArray.map((json) => NoteTypeEntity.fromJson(json)).toList();
  }
}