
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

import '../database.dart';

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

@UseRowClass(CategoryEntity)
class CategoryTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CategoryEntity extends Equatable {
  String id;
  String name;
  DateTime createdAt;
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
        createdAt = DateTime.parse(json['createdAt'] as String),
        updatedAt = DateTime.parse(json['updatedAt'] as String);

  static List<CategoryEntity> fromJsonArray(List jsonArray) {
    return jsonArray.map((json) => CategoryEntity.fromJson(json)).toList();
  }
}