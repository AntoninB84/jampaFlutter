
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

import '../database.dart';

/// A data class that combines a [CategoryEntity]
/// with the count of notes associated with it.
class CategoryWithCount {
  final CategoryEntity category;
  final int noteCount;

  CategoryWithCount({
    required this.category,
    required this.noteCount,
  });

  @override
  String toString() {
    return 'CategoryWithCount{category: $category, noteCount: $noteCount}';
  }
}

/// Drift table definition for categories.
@UseRowClass(CategoryEntity)
class CategoryTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Entity class representing a category.
class CategoryEntity extends Equatable {

  /// Unique identifier for the category (UUID)
  String id;

  /// Name of the category
  String name;

  /// Timestamp when the category was created
  DateTime createdAt;

  /// Timestamp when the category was last updated
  DateTime updatedAt;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, createdAt, updatedAt];

  @override
  String toString() {
    return 'CategoryEntity{id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  CategoryEntity copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converts this entity to a Drift companion for database operations.
  CategoryTableCompanion toCompanion() {
    return CategoryTableCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  CategoryEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        createdAt = .parse(json['createdAt'] as String),
        updatedAt = .parse(json['updatedAt'] as String);

  static List<CategoryEntity> fromJsonArray(List jsonArray) {
    return jsonArray.map((json) => CategoryEntity.fromJson(json)).toList();
  }
}