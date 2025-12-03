// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoteEntity implements DiagnosticableTreeMixin {

/// Unique identifier for the note (UUID)
 String get id;/// Title of the note
 String get title;/// Content of the note (optional).
/// JSON content currently used with Quill editor
 String? get content;/// Flag indicating if the note is marked as important (not in use atm)
 bool get isImportant;/// Status of the note (e.g., to do, done)
 NoteStatusEnum get status;/// Timestamp when the note was created
 DateTime get createdAt;/// Timestamp when the note was last updated
 DateTime get updatedAt;/// Identifier for the type of the note (optional UUID)
 String? get noteTypeId;/// The type of the note (optional)
 NoteTypeEntity? get noteType;/// Identifier for the user who owns the note (UUID). Not yet in use
 String? get userId;/// List of categories associated with the note (optional)
 List<CategoryEntity>? get categories;
/// Create a copy of NoteEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteEntityCopyWith<NoteEntity> get copyWith => _$NoteEntityCopyWithImpl<NoteEntity>(this as NoteEntity, _$identity);

  /// Serializes this NoteEntity to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NoteEntity'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('content', content))..add(DiagnosticsProperty('isImportant', isImportant))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('updatedAt', updatedAt))..add(DiagnosticsProperty('noteTypeId', noteTypeId))..add(DiagnosticsProperty('noteType', noteType))..add(DiagnosticsProperty('userId', userId))..add(DiagnosticsProperty('categories', categories));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.isImportant, isImportant) || other.isImportant == isImportant)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.noteTypeId, noteTypeId) || other.noteTypeId == noteTypeId)&&(identical(other.noteType, noteType) || other.noteType == noteType)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,isImportant,status,createdAt,updatedAt,noteTypeId,noteType,userId,const DeepCollectionEquality().hash(categories));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NoteEntity(id: $id, title: $title, content: $content, isImportant: $isImportant, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, noteTypeId: $noteTypeId, noteType: $noteType, userId: $userId, categories: $categories)';
}


}

/// @nodoc
abstract mixin class $NoteEntityCopyWith<$Res>  {
  factory $NoteEntityCopyWith(NoteEntity value, $Res Function(NoteEntity) _then) = _$NoteEntityCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? content, bool isImportant, NoteStatusEnum status, DateTime createdAt, DateTime updatedAt, String? noteTypeId, NoteTypeEntity? noteType, String? userId, List<CategoryEntity>? categories
});


$NoteTypeEntityCopyWith<$Res>? get noteType;

}
/// @nodoc
class _$NoteEntityCopyWithImpl<$Res>
    implements $NoteEntityCopyWith<$Res> {
  _$NoteEntityCopyWithImpl(this._self, this._then);

  final NoteEntity _self;
  final $Res Function(NoteEntity) _then;

/// Create a copy of NoteEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = freezed,Object? isImportant = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? noteTypeId = freezed,Object? noteType = freezed,Object? userId = freezed,Object? categories = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,isImportant: null == isImportant ? _self.isImportant : isImportant // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NoteStatusEnum,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,noteTypeId: freezed == noteTypeId ? _self.noteTypeId : noteTypeId // ignore: cast_nullable_to_non_nullable
as String?,noteType: freezed == noteType ? _self.noteType : noteType // ignore: cast_nullable_to_non_nullable
as NoteTypeEntity?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,categories: freezed == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryEntity>?,
  ));
}
/// Create a copy of NoteEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteTypeEntityCopyWith<$Res>? get noteType {
    if (_self.noteType == null) {
    return null;
  }

  return $NoteTypeEntityCopyWith<$Res>(_self.noteType!, (value) {
    return _then(_self.copyWith(noteType: value));
  });
}
}


/// Adds pattern-matching-related methods to [NoteEntity].
extension NoteEntityPatterns on NoteEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteEntity value)  $default,){
final _that = this;
switch (_that) {
case _NoteEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteEntity value)?  $default,){
final _that = this;
switch (_that) {
case _NoteEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? content,  bool isImportant,  NoteStatusEnum status,  DateTime createdAt,  DateTime updatedAt,  String? noteTypeId,  NoteTypeEntity? noteType,  String? userId,  List<CategoryEntity>? categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteEntity() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.isImportant,_that.status,_that.createdAt,_that.updatedAt,_that.noteTypeId,_that.noteType,_that.userId,_that.categories);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? content,  bool isImportant,  NoteStatusEnum status,  DateTime createdAt,  DateTime updatedAt,  String? noteTypeId,  NoteTypeEntity? noteType,  String? userId,  List<CategoryEntity>? categories)  $default,) {final _that = this;
switch (_that) {
case _NoteEntity():
return $default(_that.id,_that.title,_that.content,_that.isImportant,_that.status,_that.createdAt,_that.updatedAt,_that.noteTypeId,_that.noteType,_that.userId,_that.categories);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? content,  bool isImportant,  NoteStatusEnum status,  DateTime createdAt,  DateTime updatedAt,  String? noteTypeId,  NoteTypeEntity? noteType,  String? userId,  List<CategoryEntity>? categories)?  $default,) {final _that = this;
switch (_that) {
case _NoteEntity() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.isImportant,_that.status,_that.createdAt,_that.updatedAt,_that.noteTypeId,_that.noteType,_that.userId,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoteEntity extends NoteEntity with DiagnosticableTreeMixin {
  const _NoteEntity({required this.id, required this.title, this.content, this.isImportant = false, this.status = NoteStatusEnum.todo, required this.createdAt, required this.updatedAt, this.noteTypeId, this.noteType, this.userId, this.categories}): assert(id.isNotEmpty, 'Note id cannot be empty'),assert(title.length >= 3, 'Note title must be at least 3 character long'),assert(title.length <= 120, 'Note title cannot exceed 120 characters'),super._();
  factory _NoteEntity.fromJson(Map<String, dynamic> json) => _$NoteEntityFromJson(json);

/// Unique identifier for the note (UUID)
@override final  String id;
/// Title of the note
@override final  String title;
/// Content of the note (optional).
/// JSON content currently used with Quill editor
@override final  String? content;
/// Flag indicating if the note is marked as important (not in use atm)
@override@JsonKey() final  bool isImportant;
/// Status of the note (e.g., to do, done)
@override@JsonKey() final  NoteStatusEnum status;
/// Timestamp when the note was created
@override final  DateTime createdAt;
/// Timestamp when the note was last updated
@override final  DateTime updatedAt;
/// Identifier for the type of the note (optional UUID)
@override final  String? noteTypeId;
/// The type of the note (optional)
@override final  NoteTypeEntity? noteType;
/// Identifier for the user who owns the note (UUID). Not yet in use
@override final  String? userId;
/// List of categories associated with the note (optional)
@override final  List<CategoryEntity>? categories;

/// Create a copy of NoteEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteEntityCopyWith<_NoteEntity> get copyWith => __$NoteEntityCopyWithImpl<_NoteEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoteEntityToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NoteEntity'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('content', content))..add(DiagnosticsProperty('isImportant', isImportant))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('updatedAt', updatedAt))..add(DiagnosticsProperty('noteTypeId', noteTypeId))..add(DiagnosticsProperty('noteType', noteType))..add(DiagnosticsProperty('userId', userId))..add(DiagnosticsProperty('categories', categories));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.isImportant, isImportant) || other.isImportant == isImportant)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.noteTypeId, noteTypeId) || other.noteTypeId == noteTypeId)&&(identical(other.noteType, noteType) || other.noteType == noteType)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,isImportant,status,createdAt,updatedAt,noteTypeId,noteType,userId,const DeepCollectionEquality().hash(categories));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NoteEntity(id: $id, title: $title, content: $content, isImportant: $isImportant, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, noteTypeId: $noteTypeId, noteType: $noteType, userId: $userId, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$NoteEntityCopyWith<$Res> implements $NoteEntityCopyWith<$Res> {
  factory _$NoteEntityCopyWith(_NoteEntity value, $Res Function(_NoteEntity) _then) = __$NoteEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? content, bool isImportant, NoteStatusEnum status, DateTime createdAt, DateTime updatedAt, String? noteTypeId, NoteTypeEntity? noteType, String? userId, List<CategoryEntity>? categories
});


@override $NoteTypeEntityCopyWith<$Res>? get noteType;

}
/// @nodoc
class __$NoteEntityCopyWithImpl<$Res>
    implements _$NoteEntityCopyWith<$Res> {
  __$NoteEntityCopyWithImpl(this._self, this._then);

  final _NoteEntity _self;
  final $Res Function(_NoteEntity) _then;

/// Create a copy of NoteEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = freezed,Object? isImportant = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? noteTypeId = freezed,Object? noteType = freezed,Object? userId = freezed,Object? categories = freezed,}) {
  return _then(_NoteEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,isImportant: null == isImportant ? _self.isImportant : isImportant // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NoteStatusEnum,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,noteTypeId: freezed == noteTypeId ? _self.noteTypeId : noteTypeId // ignore: cast_nullable_to_non_nullable
as String?,noteType: freezed == noteType ? _self.noteType : noteType // ignore: cast_nullable_to_non_nullable
as NoteTypeEntity?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,categories: freezed == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryEntity>?,
  ));
}

/// Create a copy of NoteEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteTypeEntityCopyWith<$Res>? get noteType {
    if (_self.noteType == null) {
    return null;
  }

  return $NoteTypeEntityCopyWith<$Res>(_self.noteType!, (value) {
    return _then(_self.copyWith(noteType: value));
  });
}
}

// dart format on
