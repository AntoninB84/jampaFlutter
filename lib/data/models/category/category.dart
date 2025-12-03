
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jampa_flutter/utils/constants/constants.dart';

import '../../database.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// Drift table definition for categories.
@drift.UseRowClass(CategoryEntity)
class CategoryTable extends drift.Table {
  drift.TextColumn get id => text()();
  drift.TextColumn get name => text().withLength(min: 1, max: 100)();
  drift.DateTimeColumn get createdAt => dateTime().withDefault(drift.currentDateAndTime)();
  drift.DateTimeColumn get updatedAt => dateTime().withDefault(drift.currentDateAndTime)();

  @override
  Set<drift.Column<Object>> get primaryKey => {id};
}

/// Entity class representing a category.
@freezed
abstract class CategoryEntity with _$CategoryEntity {

  const CategoryEntity._();

  @Assert('id.isNotEmpty', 'Category id cannot be empty')
  @Assert('name.length >= $kEntityNameMinLength', 'Category name must be at least $kEntityNameMinLength character long')
  @Assert('name.length <= $kEntityNameMaxLength', 'Category name cannot exceed $kEntityNameMaxLength characters')
  const factory CategoryEntity({
    /// Unique identifier for the category (UUID)
    required String id,

    /// Name of the category
    required String name,

    /// Timestamp when the category was created
    required DateTime createdAt,

    /// Timestamp when the category was last updated
    required DateTime updatedAt,
  }) = _CategoryEntity;



  /// Converts this entity to a Drift companion for database operations.
  CategoryTableCompanion toCompanion() {
    return CategoryTableCompanion(
      id: drift.Value(id),
      name: drift.Value(name),
      createdAt: drift.Value(createdAt),
      updatedAt: drift.Value(updatedAt),
    );
  }

  factory CategoryEntity.fromJson(Map<String, dynamic> json) => _$CategoryEntityFromJson(json);

  static List<CategoryEntity> fromJsonArray(List jsonArray) {
    return jsonArray.map((json) => CategoryEntity.fromJson(json)).toList();
  }
}