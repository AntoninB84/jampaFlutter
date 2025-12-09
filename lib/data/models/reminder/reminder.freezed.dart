// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReminderEntity implements DiagnosticableTreeMixin {

/// Unique identifier for the reminder (UUID)
 String get id;/// Identifier for the parent schedule
 String get scheduleId;/// Identifier for the parent note
 String get noteId;/// Offset value for the reminder
 int get offsetValue;/// Type of offset (e.g., minutes, hours, days)
 ReminderOffsetType get offsetType;/// Indicates if the reminder is a notification or alarm
 bool get isNotification;/// Timestamp when the reminder was created
 DateTime get createdAt;/// Timestamp when the reminder was last updated
 DateTime get updatedAt;
/// Create a copy of ReminderEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderEntityCopyWith<ReminderEntity> get copyWith => _$ReminderEntityCopyWithImpl<ReminderEntity>(this as ReminderEntity, _$identity);

  /// Serializes this ReminderEntity to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReminderEntity'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('scheduleId', scheduleId))..add(DiagnosticsProperty('noteId', noteId))..add(DiagnosticsProperty('offsetValue', offsetValue))..add(DiagnosticsProperty('offsetType', offsetType))..add(DiagnosticsProperty('isNotification', isNotification))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('updatedAt', updatedAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.offsetValue, offsetValue) || other.offsetValue == offsetValue)&&(identical(other.offsetType, offsetType) || other.offsetType == offsetType)&&(identical(other.isNotification, isNotification) || other.isNotification == isNotification)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scheduleId,noteId,offsetValue,offsetType,isNotification,createdAt,updatedAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReminderEntity(id: $id, scheduleId: $scheduleId, noteId: $noteId, offsetValue: $offsetValue, offsetType: $offsetType, isNotification: $isNotification, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReminderEntityCopyWith<$Res>  {
  factory $ReminderEntityCopyWith(ReminderEntity value, $Res Function(ReminderEntity) _then) = _$ReminderEntityCopyWithImpl;
@useResult
$Res call({
 String id, String scheduleId, String noteId, int offsetValue, ReminderOffsetType offsetType, bool isNotification, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ReminderEntityCopyWithImpl<$Res>
    implements $ReminderEntityCopyWith<$Res> {
  _$ReminderEntityCopyWithImpl(this._self, this._then);

  final ReminderEntity _self;
  final $Res Function(ReminderEntity) _then;

/// Create a copy of ReminderEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scheduleId = null,Object? noteId = null,Object? offsetValue = null,Object? offsetType = null,Object? isNotification = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,offsetValue: null == offsetValue ? _self.offsetValue : offsetValue // ignore: cast_nullable_to_non_nullable
as int,offsetType: null == offsetType ? _self.offsetType : offsetType // ignore: cast_nullable_to_non_nullable
as ReminderOffsetType,isNotification: null == isNotification ? _self.isNotification : isNotification // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderEntity].
extension ReminderEntityPatterns on ReminderEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderEntity value)  $default,){
final _that = this;
switch (_that) {
case _ReminderEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String scheduleId,  String noteId,  int offsetValue,  ReminderOffsetType offsetType,  bool isNotification,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderEntity() when $default != null:
return $default(_that.id,_that.scheduleId,_that.noteId,_that.offsetValue,_that.offsetType,_that.isNotification,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String scheduleId,  String noteId,  int offsetValue,  ReminderOffsetType offsetType,  bool isNotification,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReminderEntity():
return $default(_that.id,_that.scheduleId,_that.noteId,_that.offsetValue,_that.offsetType,_that.isNotification,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String scheduleId,  String noteId,  int offsetValue,  ReminderOffsetType offsetType,  bool isNotification,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReminderEntity() when $default != null:
return $default(_that.id,_that.scheduleId,_that.noteId,_that.offsetValue,_that.offsetType,_that.isNotification,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReminderEntity extends ReminderEntity with DiagnosticableTreeMixin {
   _ReminderEntity({required this.id, required this.scheduleId, required this.noteId, required this.offsetValue, required this.offsetType, this.isNotification = true, required this.createdAt, required this.updatedAt}): assert(id.isNotEmpty, 'Reminder id cannot be empty'),assert(scheduleId.isNotEmpty, 'Schedule id cannot be empty'),assert(scheduleId != null, 'Schedule id must not be null'),assert(noteId.isNotEmpty, 'Note id cannot be empty'),assert(noteId != null, 'Note id must not be null'),super._();
  factory _ReminderEntity.fromJson(Map<String, dynamic> json) => _$ReminderEntityFromJson(json);

/// Unique identifier for the reminder (UUID)
@override final  String id;
/// Identifier for the parent schedule
@override final  String scheduleId;
/// Identifier for the parent note
@override final  String noteId;
/// Offset value for the reminder
@override final  int offsetValue;
/// Type of offset (e.g., minutes, hours, days)
@override final  ReminderOffsetType offsetType;
/// Indicates if the reminder is a notification or alarm
@override@JsonKey() final  bool isNotification;
/// Timestamp when the reminder was created
@override final  DateTime createdAt;
/// Timestamp when the reminder was last updated
@override final  DateTime updatedAt;

/// Create a copy of ReminderEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderEntityCopyWith<_ReminderEntity> get copyWith => __$ReminderEntityCopyWithImpl<_ReminderEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderEntityToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReminderEntity'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('scheduleId', scheduleId))..add(DiagnosticsProperty('noteId', noteId))..add(DiagnosticsProperty('offsetValue', offsetValue))..add(DiagnosticsProperty('offsetType', offsetType))..add(DiagnosticsProperty('isNotification', isNotification))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('updatedAt', updatedAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.offsetValue, offsetValue) || other.offsetValue == offsetValue)&&(identical(other.offsetType, offsetType) || other.offsetType == offsetType)&&(identical(other.isNotification, isNotification) || other.isNotification == isNotification)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scheduleId,noteId,offsetValue,offsetType,isNotification,createdAt,updatedAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReminderEntity(id: $id, scheduleId: $scheduleId, noteId: $noteId, offsetValue: $offsetValue, offsetType: $offsetType, isNotification: $isNotification, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReminderEntityCopyWith<$Res> implements $ReminderEntityCopyWith<$Res> {
  factory _$ReminderEntityCopyWith(_ReminderEntity value, $Res Function(_ReminderEntity) _then) = __$ReminderEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String scheduleId, String noteId, int offsetValue, ReminderOffsetType offsetType, bool isNotification, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ReminderEntityCopyWithImpl<$Res>
    implements _$ReminderEntityCopyWith<$Res> {
  __$ReminderEntityCopyWithImpl(this._self, this._then);

  final _ReminderEntity _self;
  final $Res Function(_ReminderEntity) _then;

/// Create a copy of ReminderEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scheduleId = null,Object? noteId = null,Object? offsetValue = null,Object? offsetType = null,Object? isNotification = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ReminderEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,offsetValue: null == offsetValue ? _self.offsetValue : offsetValue // ignore: cast_nullable_to_non_nullable
as int,offsetType: null == offsetType ? _self.offsetType : offsetType // ignore: cast_nullable_to_non_nullable
as ReminderOffsetType,isNotification: null == isNotification ? _self.isNotification : isNotification // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
