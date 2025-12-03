// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoteCategoryEntity implements DiagnosticableTreeMixin {

/// The ID of the note
 String get noteId;/// The ID of the category
 String get categoryId;
/// Create a copy of NoteCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteCategoryEntityCopyWith<NoteCategoryEntity> get copyWith => _$NoteCategoryEntityCopyWithImpl<NoteCategoryEntity>(this as NoteCategoryEntity, _$identity);

  /// Serializes this NoteCategoryEntity to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NoteCategoryEntity'))
    ..add(DiagnosticsProperty('noteId', noteId))..add(DiagnosticsProperty('categoryId', categoryId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteCategoryEntity&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,noteId,categoryId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NoteCategoryEntity(noteId: $noteId, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class $NoteCategoryEntityCopyWith<$Res>  {
  factory $NoteCategoryEntityCopyWith(NoteCategoryEntity value, $Res Function(NoteCategoryEntity) _then) = _$NoteCategoryEntityCopyWithImpl;
@useResult
$Res call({
 String noteId, String categoryId
});




}
/// @nodoc
class _$NoteCategoryEntityCopyWithImpl<$Res>
    implements $NoteCategoryEntityCopyWith<$Res> {
  _$NoteCategoryEntityCopyWithImpl(this._self, this._then);

  final NoteCategoryEntity _self;
  final $Res Function(NoteCategoryEntity) _then;

/// Create a copy of NoteCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noteId = null,Object? categoryId = null,}) {
  return _then(_self.copyWith(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteCategoryEntity].
extension NoteCategoryEntityPatterns on NoteCategoryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteCategoryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteCategoryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteCategoryEntity value)  $default,){
final _that = this;
switch (_that) {
case _NoteCategoryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteCategoryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _NoteCategoryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String noteId,  String categoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteCategoryEntity() when $default != null:
return $default(_that.noteId,_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String noteId,  String categoryId)  $default,) {final _that = this;
switch (_that) {
case _NoteCategoryEntity():
return $default(_that.noteId,_that.categoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String noteId,  String categoryId)?  $default,) {final _that = this;
switch (_that) {
case _NoteCategoryEntity() when $default != null:
return $default(_that.noteId,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoteCategoryEntity extends NoteCategoryEntity with DiagnosticableTreeMixin {
  const _NoteCategoryEntity({required this.noteId, required this.categoryId}): assert(noteId.isNotEmpty, 'Note ID cannot be empty'),assert(categoryId.isNotEmpty, 'Category ID cannot be empty'),super._();
  factory _NoteCategoryEntity.fromJson(Map<String, dynamic> json) => _$NoteCategoryEntityFromJson(json);

/// The ID of the note
@override final  String noteId;
/// The ID of the category
@override final  String categoryId;

/// Create a copy of NoteCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteCategoryEntityCopyWith<_NoteCategoryEntity> get copyWith => __$NoteCategoryEntityCopyWithImpl<_NoteCategoryEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoteCategoryEntityToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NoteCategoryEntity'))
    ..add(DiagnosticsProperty('noteId', noteId))..add(DiagnosticsProperty('categoryId', categoryId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteCategoryEntity&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,noteId,categoryId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NoteCategoryEntity(noteId: $noteId, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$NoteCategoryEntityCopyWith<$Res> implements $NoteCategoryEntityCopyWith<$Res> {
  factory _$NoteCategoryEntityCopyWith(_NoteCategoryEntity value, $Res Function(_NoteCategoryEntity) _then) = __$NoteCategoryEntityCopyWithImpl;
@override @useResult
$Res call({
 String noteId, String categoryId
});




}
/// @nodoc
class __$NoteCategoryEntityCopyWithImpl<$Res>
    implements _$NoteCategoryEntityCopyWith<$Res> {
  __$NoteCategoryEntityCopyWithImpl(this._self, this._then);

  final _NoteCategoryEntity _self;
  final $Res Function(_NoteCategoryEntity) _then;

/// Create a copy of NoteCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noteId = null,Object? categoryId = null,}) {
  return _then(_NoteCategoryEntity(
noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
