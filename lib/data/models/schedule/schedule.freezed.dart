// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleEntity implements DiagnosticableTreeMixin {

/// Unique identifier for the schedule (UUID)
 String get id;/// Identifier of the parent note
 String get noteId;/// The parent note entity. Can be null if not loaded
@JsonKey(includeFromJson: false, includeToJson: false) NoteEntity? get note;/// Start date and time of the schedule
 DateTime? get startDateTime;/// Optional end date and time of the schedule
 DateTime? get endDateTime;/// Timestamp when the schedule was created
 DateTime get createdAt;/// Timestamp when the schedule was last updated
 DateTime get updatedAt;/// Type of recurrence for the schedule.
/// Is null if the schedule is a single date schedule
 RecurrenceType? get recurrenceType;/// Interval value for day-based or year-based recurrences.
/// e.g., every 2 days/years
 int? get recurrenceInterval;/// Day value for day-based weekly or monthly recurrences
///
/// e.g., for weekly: days of the week as integer (e.g., 135 for Mon, Wed, Fri)
///
/// e.g., for monthly: day of the month (e.g., 15 for the 15th of each month)
 int? get recurrenceDay;/// Optional end date for the recurrence
 DateTime? get recurrenceEndDate;/// List of reminders associated with the schedule
@JsonKey(includeFromJson: false, includeToJson: false) List<ReminderEntity>? get reminders;
/// Create a copy of ScheduleEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleEntityCopyWith<ScheduleEntity> get copyWith => _$ScheduleEntityCopyWithImpl<ScheduleEntity>(this as ScheduleEntity, _$identity);

  /// Serializes this ScheduleEntity to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ScheduleEntity'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('noteId', noteId))..add(DiagnosticsProperty('note', note))..add(DiagnosticsProperty('startDateTime', startDateTime))..add(DiagnosticsProperty('endDateTime', endDateTime))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('updatedAt', updatedAt))..add(DiagnosticsProperty('recurrenceType', recurrenceType))..add(DiagnosticsProperty('recurrenceInterval', recurrenceInterval))..add(DiagnosticsProperty('recurrenceDay', recurrenceDay))..add(DiagnosticsProperty('recurrenceEndDate', recurrenceEndDate))..add(DiagnosticsProperty('reminders', reminders));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.note, note) || other.note == note)&&(identical(other.startDateTime, startDateTime) || other.startDateTime == startDateTime)&&(identical(other.endDateTime, endDateTime) || other.endDateTime == endDateTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.recurrenceType, recurrenceType) || other.recurrenceType == recurrenceType)&&(identical(other.recurrenceInterval, recurrenceInterval) || other.recurrenceInterval == recurrenceInterval)&&(identical(other.recurrenceDay, recurrenceDay) || other.recurrenceDay == recurrenceDay)&&(identical(other.recurrenceEndDate, recurrenceEndDate) || other.recurrenceEndDate == recurrenceEndDate)&&const DeepCollectionEquality().equals(other.reminders, reminders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,noteId,note,startDateTime,endDateTime,createdAt,updatedAt,recurrenceType,recurrenceInterval,recurrenceDay,recurrenceEndDate,const DeepCollectionEquality().hash(reminders));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ScheduleEntity(id: $id, noteId: $noteId, note: $note, startDateTime: $startDateTime, endDateTime: $endDateTime, createdAt: $createdAt, updatedAt: $updatedAt, recurrenceType: $recurrenceType, recurrenceInterval: $recurrenceInterval, recurrenceDay: $recurrenceDay, recurrenceEndDate: $recurrenceEndDate, reminders: $reminders)';
}


}

/// @nodoc
abstract mixin class $ScheduleEntityCopyWith<$Res>  {
  factory $ScheduleEntityCopyWith(ScheduleEntity value, $Res Function(ScheduleEntity) _then) = _$ScheduleEntityCopyWithImpl;
@useResult
$Res call({
 String id, String noteId,@JsonKey(includeFromJson: false, includeToJson: false) NoteEntity? note, DateTime? startDateTime, DateTime? endDateTime, DateTime createdAt, DateTime updatedAt, RecurrenceType? recurrenceType, int? recurrenceInterval, int? recurrenceDay, DateTime? recurrenceEndDate,@JsonKey(includeFromJson: false, includeToJson: false) List<ReminderEntity>? reminders
});


$NoteEntityCopyWith<$Res>? get note;

}
/// @nodoc
class _$ScheduleEntityCopyWithImpl<$Res>
    implements $ScheduleEntityCopyWith<$Res> {
  _$ScheduleEntityCopyWithImpl(this._self, this._then);

  final ScheduleEntity _self;
  final $Res Function(ScheduleEntity) _then;

/// Create a copy of ScheduleEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? noteId = null,Object? note = freezed,Object? startDateTime = freezed,Object? endDateTime = freezed,Object? createdAt = null,Object? updatedAt = null,Object? recurrenceType = freezed,Object? recurrenceInterval = freezed,Object? recurrenceDay = freezed,Object? recurrenceEndDate = freezed,Object? reminders = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as NoteEntity?,startDateTime: freezed == startDateTime ? _self.startDateTime : startDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endDateTime: freezed == endDateTime ? _self.endDateTime : endDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,recurrenceType: freezed == recurrenceType ? _self.recurrenceType : recurrenceType // ignore: cast_nullable_to_non_nullable
as RecurrenceType?,recurrenceInterval: freezed == recurrenceInterval ? _self.recurrenceInterval : recurrenceInterval // ignore: cast_nullable_to_non_nullable
as int?,recurrenceDay: freezed == recurrenceDay ? _self.recurrenceDay : recurrenceDay // ignore: cast_nullable_to_non_nullable
as int?,recurrenceEndDate: freezed == recurrenceEndDate ? _self.recurrenceEndDate : recurrenceEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,reminders: freezed == reminders ? _self.reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<ReminderEntity>?,
  ));
}
/// Create a copy of ScheduleEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteEntityCopyWith<$Res>? get note {
    if (_self.note == null) {
    return null;
  }

  return $NoteEntityCopyWith<$Res>(_self.note!, (value) {
    return _then(_self.copyWith(note: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScheduleEntity].
extension ScheduleEntityPatterns on ScheduleEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleEntity value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String noteId, @JsonKey(includeFromJson: false, includeToJson: false)  NoteEntity? note,  DateTime? startDateTime,  DateTime? endDateTime,  DateTime createdAt,  DateTime updatedAt,  RecurrenceType? recurrenceType,  int? recurrenceInterval,  int? recurrenceDay,  DateTime? recurrenceEndDate, @JsonKey(includeFromJson: false, includeToJson: false)  List<ReminderEntity>? reminders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleEntity() when $default != null:
return $default(_that.id,_that.noteId,_that.note,_that.startDateTime,_that.endDateTime,_that.createdAt,_that.updatedAt,_that.recurrenceType,_that.recurrenceInterval,_that.recurrenceDay,_that.recurrenceEndDate,_that.reminders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String noteId, @JsonKey(includeFromJson: false, includeToJson: false)  NoteEntity? note,  DateTime? startDateTime,  DateTime? endDateTime,  DateTime createdAt,  DateTime updatedAt,  RecurrenceType? recurrenceType,  int? recurrenceInterval,  int? recurrenceDay,  DateTime? recurrenceEndDate, @JsonKey(includeFromJson: false, includeToJson: false)  List<ReminderEntity>? reminders)  $default,) {final _that = this;
switch (_that) {
case _ScheduleEntity():
return $default(_that.id,_that.noteId,_that.note,_that.startDateTime,_that.endDateTime,_that.createdAt,_that.updatedAt,_that.recurrenceType,_that.recurrenceInterval,_that.recurrenceDay,_that.recurrenceEndDate,_that.reminders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String noteId, @JsonKey(includeFromJson: false, includeToJson: false)  NoteEntity? note,  DateTime? startDateTime,  DateTime? endDateTime,  DateTime createdAt,  DateTime updatedAt,  RecurrenceType? recurrenceType,  int? recurrenceInterval,  int? recurrenceDay,  DateTime? recurrenceEndDate, @JsonKey(includeFromJson: false, includeToJson: false)  List<ReminderEntity>? reminders)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleEntity() when $default != null:
return $default(_that.id,_that.noteId,_that.note,_that.startDateTime,_that.endDateTime,_that.createdAt,_that.updatedAt,_that.recurrenceType,_that.recurrenceInterval,_that.recurrenceDay,_that.recurrenceEndDate,_that.reminders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleEntity extends ScheduleEntity with DiagnosticableTreeMixin {
   _ScheduleEntity({required this.id, required this.noteId, @JsonKey(includeFromJson: false, includeToJson: false) this.note, required this.startDateTime, this.endDateTime, required this.createdAt, required this.updatedAt, this.recurrenceType, this.recurrenceInterval, this.recurrenceDay, this.recurrenceEndDate, @JsonKey(includeFromJson: false, includeToJson: false) this.reminders}): assert(id.isNotEmpty, 'Schedule id cannot be empty'),assert(noteId.isNotEmpty, 'Note id cannot be empty'),super._();
  factory _ScheduleEntity.fromJson(Map<String, dynamic> json) => _$ScheduleEntityFromJson(json);

/// Unique identifier for the schedule (UUID)
@override final  String id;
/// Identifier of the parent note
@override final  String noteId;
/// The parent note entity. Can be null if not loaded
@override@JsonKey(includeFromJson: false, includeToJson: false) final  NoteEntity? note;
/// Start date and time of the schedule
@override final  DateTime? startDateTime;
/// Optional end date and time of the schedule
@override final  DateTime? endDateTime;
/// Timestamp when the schedule was created
@override final  DateTime createdAt;
/// Timestamp when the schedule was last updated
@override final  DateTime updatedAt;
/// Type of recurrence for the schedule.
/// Is null if the schedule is a single date schedule
@override final  RecurrenceType? recurrenceType;
/// Interval value for day-based or year-based recurrences.
/// e.g., every 2 days/years
@override final  int? recurrenceInterval;
/// Day value for day-based weekly or monthly recurrences
///
/// e.g., for weekly: days of the week as integer (e.g., 135 for Mon, Wed, Fri)
///
/// e.g., for monthly: day of the month (e.g., 15 for the 15th of each month)
@override final  int? recurrenceDay;
/// Optional end date for the recurrence
@override final  DateTime? recurrenceEndDate;
/// List of reminders associated with the schedule
@override@JsonKey(includeFromJson: false, includeToJson: false) final  List<ReminderEntity>? reminders;

/// Create a copy of ScheduleEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleEntityCopyWith<_ScheduleEntity> get copyWith => __$ScheduleEntityCopyWithImpl<_ScheduleEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleEntityToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ScheduleEntity'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('noteId', noteId))..add(DiagnosticsProperty('note', note))..add(DiagnosticsProperty('startDateTime', startDateTime))..add(DiagnosticsProperty('endDateTime', endDateTime))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('updatedAt', updatedAt))..add(DiagnosticsProperty('recurrenceType', recurrenceType))..add(DiagnosticsProperty('recurrenceInterval', recurrenceInterval))..add(DiagnosticsProperty('recurrenceDay', recurrenceDay))..add(DiagnosticsProperty('recurrenceEndDate', recurrenceEndDate))..add(DiagnosticsProperty('reminders', reminders));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.note, note) || other.note == note)&&(identical(other.startDateTime, startDateTime) || other.startDateTime == startDateTime)&&(identical(other.endDateTime, endDateTime) || other.endDateTime == endDateTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.recurrenceType, recurrenceType) || other.recurrenceType == recurrenceType)&&(identical(other.recurrenceInterval, recurrenceInterval) || other.recurrenceInterval == recurrenceInterval)&&(identical(other.recurrenceDay, recurrenceDay) || other.recurrenceDay == recurrenceDay)&&(identical(other.recurrenceEndDate, recurrenceEndDate) || other.recurrenceEndDate == recurrenceEndDate)&&const DeepCollectionEquality().equals(other.reminders, reminders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,noteId,note,startDateTime,endDateTime,createdAt,updatedAt,recurrenceType,recurrenceInterval,recurrenceDay,recurrenceEndDate,const DeepCollectionEquality().hash(reminders));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ScheduleEntity(id: $id, noteId: $noteId, note: $note, startDateTime: $startDateTime, endDateTime: $endDateTime, createdAt: $createdAt, updatedAt: $updatedAt, recurrenceType: $recurrenceType, recurrenceInterval: $recurrenceInterval, recurrenceDay: $recurrenceDay, recurrenceEndDate: $recurrenceEndDate, reminders: $reminders)';
}


}

/// @nodoc
abstract mixin class _$ScheduleEntityCopyWith<$Res> implements $ScheduleEntityCopyWith<$Res> {
  factory _$ScheduleEntityCopyWith(_ScheduleEntity value, $Res Function(_ScheduleEntity) _then) = __$ScheduleEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String noteId,@JsonKey(includeFromJson: false, includeToJson: false) NoteEntity? note, DateTime? startDateTime, DateTime? endDateTime, DateTime createdAt, DateTime updatedAt, RecurrenceType? recurrenceType, int? recurrenceInterval, int? recurrenceDay, DateTime? recurrenceEndDate,@JsonKey(includeFromJson: false, includeToJson: false) List<ReminderEntity>? reminders
});


@override $NoteEntityCopyWith<$Res>? get note;

}
/// @nodoc
class __$ScheduleEntityCopyWithImpl<$Res>
    implements _$ScheduleEntityCopyWith<$Res> {
  __$ScheduleEntityCopyWithImpl(this._self, this._then);

  final _ScheduleEntity _self;
  final $Res Function(_ScheduleEntity) _then;

/// Create a copy of ScheduleEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? noteId = null,Object? note = freezed,Object? startDateTime = freezed,Object? endDateTime = freezed,Object? createdAt = null,Object? updatedAt = null,Object? recurrenceType = freezed,Object? recurrenceInterval = freezed,Object? recurrenceDay = freezed,Object? recurrenceEndDate = freezed,Object? reminders = freezed,}) {
  return _then(_ScheduleEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as NoteEntity?,startDateTime: freezed == startDateTime ? _self.startDateTime : startDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endDateTime: freezed == endDateTime ? _self.endDateTime : endDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,recurrenceType: freezed == recurrenceType ? _self.recurrenceType : recurrenceType // ignore: cast_nullable_to_non_nullable
as RecurrenceType?,recurrenceInterval: freezed == recurrenceInterval ? _self.recurrenceInterval : recurrenceInterval // ignore: cast_nullable_to_non_nullable
as int?,recurrenceDay: freezed == recurrenceDay ? _self.recurrenceDay : recurrenceDay // ignore: cast_nullable_to_non_nullable
as int?,recurrenceEndDate: freezed == recurrenceEndDate ? _self.recurrenceEndDate : recurrenceEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,reminders: freezed == reminders ? _self.reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<ReminderEntity>?,
  ));
}

/// Create a copy of ScheduleEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteEntityCopyWith<$Res>? get note {
    if (_self.note == null) {
    return null;
  }

  return $NoteEntityCopyWith<$Res>(_self.note!, (value) {
    return _then(_self.copyWith(note: value));
  });
}
}

// dart format on
