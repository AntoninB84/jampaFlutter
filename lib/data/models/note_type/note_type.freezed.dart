// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoteTypeEntity implements DiagnosticableTreeMixin {

/// The unique identifier for the note type (UUID).
 String get id;/// The name of the note type.
 String get name;/// The timestamp when the note type was created.
 DateTime get createdAt;/// The timestamp when the note type was last updated.
 DateTime get updatedAt;
/// Create a copy of NoteTypeEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteTypeEntityCopyWith<NoteTypeEntity> get copyWith => _$NoteTypeEntityCopyWithImpl<NoteTypeEntity>(this as NoteTypeEntity, _$identity);

  /// Serializes this NoteTypeEntity to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NoteTypeEntity'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('updatedAt', updatedAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteTypeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,createdAt,updatedAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NoteTypeEntity(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $NoteTypeEntityCopyWith<$Res>  {
  factory $NoteTypeEntityCopyWith(NoteTypeEntity value, $Res Function(NoteTypeEntity) _then) = _$NoteTypeEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$NoteTypeEntityCopyWithImpl<$Res>
    implements $NoteTypeEntityCopyWith<$Res> {
  _$NoteTypeEntityCopyWithImpl(this._self, this._then);

  final NoteTypeEntity _self;
  final $Res Function(NoteTypeEntity) _then;

/// Create a copy of NoteTypeEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteTypeEntity].
extension NoteTypeEntityPatterns on NoteTypeEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteTypeEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteTypeEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteTypeEntity value)  $default,){
final _that = this;
switch (_that) {
case _NoteTypeEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteTypeEntity value)?  $default,){
final _that = this;
switch (_that) {
case _NoteTypeEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteTypeEntity() when $default != null:
return $default(_that.id,_that.name,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _NoteTypeEntity():
return $default(_that.id,_that.name,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _NoteTypeEntity() when $default != null:
return $default(_that.id,_that.name,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoteTypeEntity extends NoteTypeEntity with DiagnosticableTreeMixin {
  const _NoteTypeEntity({required this.id, required this.name, required this.createdAt, required this.updatedAt}): assert(id.isNotEmpty, 'Note type id cannot be empty'),assert(name.length >= 3, 'Note type name must be at least 3 character long'),assert(name.length <= 120, 'Note type name cannot exceed 120 characters'),super._();
  factory _NoteTypeEntity.fromJson(Map<String, dynamic> json) => _$NoteTypeEntityFromJson(json);

/// The unique identifier for the note type (UUID).
@override final  String id;
/// The name of the note type.
@override final  String name;
/// The timestamp when the note type was created.
@override final  DateTime createdAt;
/// The timestamp when the note type was last updated.
@override final  DateTime updatedAt;

/// Create a copy of NoteTypeEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteTypeEntityCopyWith<_NoteTypeEntity> get copyWith => __$NoteTypeEntityCopyWithImpl<_NoteTypeEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoteTypeEntityToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NoteTypeEntity'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('updatedAt', updatedAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteTypeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,createdAt,updatedAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NoteTypeEntity(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$NoteTypeEntityCopyWith<$Res> implements $NoteTypeEntityCopyWith<$Res> {
  factory _$NoteTypeEntityCopyWith(_NoteTypeEntity value, $Res Function(_NoteTypeEntity) _then) = __$NoteTypeEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$NoteTypeEntityCopyWithImpl<$Res>
    implements _$NoteTypeEntityCopyWith<$Res> {
  __$NoteTypeEntityCopyWithImpl(this._self, this._then);

  final _NoteTypeEntity _self;
  final $Res Function(_NoteTypeEntity) _then;

/// Create a copy of NoteTypeEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_NoteTypeEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
