// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncResponse {

/// Current server timestamp to be used as next lastSyncDate
/// If null, uses current client time
 DateTime? get lastSyncDate;/// Categories from the server (created or updated since lastSyncDate)
 List<Map<String, dynamic>> get categories;/// Note types from the server
 List<Map<String, dynamic>> get noteTypes;/// Notes from the server
 List<Map<String, dynamic>> get notes;/// Schedules from the server
 List<Map<String, dynamic>> get schedules;/// Reminders from the server
 List<Map<String, dynamic>> get reminders;/// Note-Category relationships from the server
 List<Map<String, dynamic>> get noteCategories;/// IDs of successfully processed deletions on the server
 List<String> get deletions;/// Optional message from the server
 String? get message;
/// Create a copy of SyncResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncResponseCopyWith<SyncResponse> get copyWith => _$SyncResponseCopyWithImpl<SyncResponse>(this as SyncResponse, _$identity);

  /// Serializes this SyncResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncResponse&&(identical(other.lastSyncDate, lastSyncDate) || other.lastSyncDate == lastSyncDate)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.noteTypes, noteTypes)&&const DeepCollectionEquality().equals(other.notes, notes)&&const DeepCollectionEquality().equals(other.schedules, schedules)&&const DeepCollectionEquality().equals(other.reminders, reminders)&&const DeepCollectionEquality().equals(other.noteCategories, noteCategories)&&const DeepCollectionEquality().equals(other.deletions, deletions)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lastSyncDate,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(noteTypes),const DeepCollectionEquality().hash(notes),const DeepCollectionEquality().hash(schedules),const DeepCollectionEquality().hash(reminders),const DeepCollectionEquality().hash(noteCategories),const DeepCollectionEquality().hash(deletions),message);

@override
String toString() {
  return 'SyncResponse(lastSyncDate: $lastSyncDate, categories: $categories, noteTypes: $noteTypes, notes: $notes, schedules: $schedules, reminders: $reminders, noteCategories: $noteCategories, deletions: $deletions, message: $message)';
}


}

/// @nodoc
abstract mixin class $SyncResponseCopyWith<$Res>  {
  factory $SyncResponseCopyWith(SyncResponse value, $Res Function(SyncResponse) _then) = _$SyncResponseCopyWithImpl;
@useResult
$Res call({
 DateTime? lastSyncDate, List<Map<String, dynamic>> categories, List<Map<String, dynamic>> noteTypes, List<Map<String, dynamic>> notes, List<Map<String, dynamic>> schedules, List<Map<String, dynamic>> reminders, List<Map<String, dynamic>> noteCategories, List<String> deletions, String? message
});




}
/// @nodoc
class _$SyncResponseCopyWithImpl<$Res>
    implements $SyncResponseCopyWith<$Res> {
  _$SyncResponseCopyWithImpl(this._self, this._then);

  final SyncResponse _self;
  final $Res Function(SyncResponse) _then;

/// Create a copy of SyncResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastSyncDate = freezed,Object? categories = null,Object? noteTypes = null,Object? notes = null,Object? schedules = null,Object? reminders = null,Object? noteCategories = null,Object? deletions = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
lastSyncDate: freezed == lastSyncDate ? _self.lastSyncDate : lastSyncDate // ignore: cast_nullable_to_non_nullable
as DateTime?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,noteTypes: null == noteTypes ? _self.noteTypes : noteTypes // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,schedules: null == schedules ? _self.schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,reminders: null == reminders ? _self.reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,noteCategories: null == noteCategories ? _self.noteCategories : noteCategories // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,deletions: null == deletions ? _self.deletions : deletions // ignore: cast_nullable_to_non_nullable
as List<String>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncResponse].
extension SyncResponsePatterns on SyncResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncResponse value)  $default,){
final _that = this;
switch (_that) {
case _SyncResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SyncResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? lastSyncDate,  List<Map<String, dynamic>> categories,  List<Map<String, dynamic>> noteTypes,  List<Map<String, dynamic>> notes,  List<Map<String, dynamic>> schedules,  List<Map<String, dynamic>> reminders,  List<Map<String, dynamic>> noteCategories,  List<String> deletions,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncResponse() when $default != null:
return $default(_that.lastSyncDate,_that.categories,_that.noteTypes,_that.notes,_that.schedules,_that.reminders,_that.noteCategories,_that.deletions,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? lastSyncDate,  List<Map<String, dynamic>> categories,  List<Map<String, dynamic>> noteTypes,  List<Map<String, dynamic>> notes,  List<Map<String, dynamic>> schedules,  List<Map<String, dynamic>> reminders,  List<Map<String, dynamic>> noteCategories,  List<String> deletions,  String? message)  $default,) {final _that = this;
switch (_that) {
case _SyncResponse():
return $default(_that.lastSyncDate,_that.categories,_that.noteTypes,_that.notes,_that.schedules,_that.reminders,_that.noteCategories,_that.deletions,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? lastSyncDate,  List<Map<String, dynamic>> categories,  List<Map<String, dynamic>> noteTypes,  List<Map<String, dynamic>> notes,  List<Map<String, dynamic>> schedules,  List<Map<String, dynamic>> reminders,  List<Map<String, dynamic>> noteCategories,  List<String> deletions,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _SyncResponse() when $default != null:
return $default(_that.lastSyncDate,_that.categories,_that.noteTypes,_that.notes,_that.schedules,_that.reminders,_that.noteCategories,_that.deletions,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncResponse implements SyncResponse {
  const _SyncResponse({this.lastSyncDate, final  List<Map<String, dynamic>> categories = const [], final  List<Map<String, dynamic>> noteTypes = const [], final  List<Map<String, dynamic>> notes = const [], final  List<Map<String, dynamic>> schedules = const [], final  List<Map<String, dynamic>> reminders = const [], final  List<Map<String, dynamic>> noteCategories = const [], final  List<String> deletions = const [], this.message}): _categories = categories,_noteTypes = noteTypes,_notes = notes,_schedules = schedules,_reminders = reminders,_noteCategories = noteCategories,_deletions = deletions;
  factory _SyncResponse.fromJson(Map<String, dynamic> json) => _$SyncResponseFromJson(json);

/// Current server timestamp to be used as next lastSyncDate
/// If null, uses current client time
@override final  DateTime? lastSyncDate;
/// Categories from the server (created or updated since lastSyncDate)
 final  List<Map<String, dynamic>> _categories;
/// Categories from the server (created or updated since lastSyncDate)
@override@JsonKey() List<Map<String, dynamic>> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

/// Note types from the server
 final  List<Map<String, dynamic>> _noteTypes;
/// Note types from the server
@override@JsonKey() List<Map<String, dynamic>> get noteTypes {
  if (_noteTypes is EqualUnmodifiableListView) return _noteTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_noteTypes);
}

/// Notes from the server
 final  List<Map<String, dynamic>> _notes;
/// Notes from the server
@override@JsonKey() List<Map<String, dynamic>> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}

/// Schedules from the server
 final  List<Map<String, dynamic>> _schedules;
/// Schedules from the server
@override@JsonKey() List<Map<String, dynamic>> get schedules {
  if (_schedules is EqualUnmodifiableListView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedules);
}

/// Reminders from the server
 final  List<Map<String, dynamic>> _reminders;
/// Reminders from the server
@override@JsonKey() List<Map<String, dynamic>> get reminders {
  if (_reminders is EqualUnmodifiableListView) return _reminders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminders);
}

/// Note-Category relationships from the server
 final  List<Map<String, dynamic>> _noteCategories;
/// Note-Category relationships from the server
@override@JsonKey() List<Map<String, dynamic>> get noteCategories {
  if (_noteCategories is EqualUnmodifiableListView) return _noteCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_noteCategories);
}

/// IDs of successfully processed deletions on the server
 final  List<String> _deletions;
/// IDs of successfully processed deletions on the server
@override@JsonKey() List<String> get deletions {
  if (_deletions is EqualUnmodifiableListView) return _deletions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deletions);
}

/// Optional message from the server
@override final  String? message;

/// Create a copy of SyncResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncResponseCopyWith<_SyncResponse> get copyWith => __$SyncResponseCopyWithImpl<_SyncResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncResponse&&(identical(other.lastSyncDate, lastSyncDate) || other.lastSyncDate == lastSyncDate)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._noteTypes, _noteTypes)&&const DeepCollectionEquality().equals(other._notes, _notes)&&const DeepCollectionEquality().equals(other._schedules, _schedules)&&const DeepCollectionEquality().equals(other._reminders, _reminders)&&const DeepCollectionEquality().equals(other._noteCategories, _noteCategories)&&const DeepCollectionEquality().equals(other._deletions, _deletions)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lastSyncDate,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_noteTypes),const DeepCollectionEquality().hash(_notes),const DeepCollectionEquality().hash(_schedules),const DeepCollectionEquality().hash(_reminders),const DeepCollectionEquality().hash(_noteCategories),const DeepCollectionEquality().hash(_deletions),message);

@override
String toString() {
  return 'SyncResponse(lastSyncDate: $lastSyncDate, categories: $categories, noteTypes: $noteTypes, notes: $notes, schedules: $schedules, reminders: $reminders, noteCategories: $noteCategories, deletions: $deletions, message: $message)';
}


}

/// @nodoc
abstract mixin class _$SyncResponseCopyWith<$Res> implements $SyncResponseCopyWith<$Res> {
  factory _$SyncResponseCopyWith(_SyncResponse value, $Res Function(_SyncResponse) _then) = __$SyncResponseCopyWithImpl;
@override @useResult
$Res call({
 DateTime? lastSyncDate, List<Map<String, dynamic>> categories, List<Map<String, dynamic>> noteTypes, List<Map<String, dynamic>> notes, List<Map<String, dynamic>> schedules, List<Map<String, dynamic>> reminders, List<Map<String, dynamic>> noteCategories, List<String> deletions, String? message
});




}
/// @nodoc
class __$SyncResponseCopyWithImpl<$Res>
    implements _$SyncResponseCopyWith<$Res> {
  __$SyncResponseCopyWithImpl(this._self, this._then);

  final _SyncResponse _self;
  final $Res Function(_SyncResponse) _then;

/// Create a copy of SyncResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastSyncDate = freezed,Object? categories = null,Object? noteTypes = null,Object? notes = null,Object? schedules = null,Object? reminders = null,Object? noteCategories = null,Object? deletions = null,Object? message = freezed,}) {
  return _then(_SyncResponse(
lastSyncDate: freezed == lastSyncDate ? _self.lastSyncDate : lastSyncDate // ignore: cast_nullable_to_non_nullable
as DateTime?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,noteTypes: null == noteTypes ? _self._noteTypes : noteTypes // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,schedules: null == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,reminders: null == reminders ? _self._reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,noteCategories: null == noteCategories ? _self._noteCategories : noteCategories // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,deletions: null == deletions ? _self._deletions : deletions // ignore: cast_nullable_to_non_nullable
as List<String>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
