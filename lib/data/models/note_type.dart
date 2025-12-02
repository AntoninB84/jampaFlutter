
import 'package:drift/drift.dart';

import '../database.dart';

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

/// The Drift table definition for note types.
@UseRowClass(NoteTypeEntity)
class NoteTypeTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// The entity class representing a note type.
class NoteTypeEntity {

  /// The unique identifier for the note type (UUID).
  String id;

  /// The name of the note type.
  String name;

  /// The timestamp when the note type was created.
  DateTime createdAt;

  /// The timestamp when the note type was last updated.
  DateTime updatedAt;

  NoteTypeEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  String toString() {
    return 'NoteTypeEntity{id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  NoteTypeEntity copyWith({
    String? id,
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

  /// Converts this entity to a NoteTypeTableCompanion for database operations.
  NoteTypeTableCompanion toCompanion() {
    return NoteTypeTableCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  NoteTypeEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        createdAt = .parse(json['createdAt'] as String),
        updatedAt = .parse(json['updatedAt'] as String);

  static List<NoteTypeEntity> fromJsonArray(List jsonArray) {
    return jsonArray.map((json) => NoteTypeEntity.fromJson(json)).toList();
  }
}