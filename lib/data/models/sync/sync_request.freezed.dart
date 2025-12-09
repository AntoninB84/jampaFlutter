// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncRequest {

/// Last sync date to get changes after this date
 DateTime? get lastSyncDate;/// Categories created or updated since last sync
 List<Map<String, dynamic>> get categories;/// Note types created or updated since last sync
 List<Map<String, dynamic>> get noteTypes;/// Notes created or updated since last sync
 List<Map<String, dynamic>> get notes;/// Schedules created or updated since last sync
 List<Map<String, dynamic>> get schedules;/// Reminders created or updated since last sync
 List<Map<String, dynamic>> get reminders;/// Note-Category relationships created or updated since last sync
 List<Map<String, dynamic>> get noteCategories;/// Pending deletions to be communicated to backend
/// Format: {"entityType": "category", "entityId": "uuid"}
 List<Map<String, dynamic>> get deletions;
/// Create a copy of SyncRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncRequestCopyWith<SyncRequest> get copyWith => _$SyncRequestCopyWithImpl<SyncRequest>(this as SyncRequest, _$identity);

  /// Serializes this SyncRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncRequest&&(identical(other.lastSyncDate, lastSyncDate) || other.lastSyncDate == lastSyncDate)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.noteTypes, noteTypes)&&const DeepCollectionEquality().equals(other.notes, notes)&&const DeepCollectionEquality().equals(other.schedules, schedules)&&const DeepCollectionEquality().equals(other.reminders, reminders)&&const DeepCollectionEquality().equals(other.noteCategories, noteCategories)&&const DeepCollectionEquality().equals(other.deletions, deletions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lastSyncDate,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(noteTypes),const DeepCollectionEquality().hash(notes),const DeepCollectionEquality().hash(schedules),const DeepCollectionEquality().hash(reminders),const DeepCollectionEquality().hash(noteCategories),const DeepCollectionEquality().hash(deletions));

@override
String toString() {
  return 'SyncRequest(lastSyncDate: $lastSyncDate, categories: $categories, noteTypes: $noteTypes, notes: $notes, schedules: $schedules, reminders: $reminders, noteCategories: $noteCategories, deletions: $deletions)';
}


}

/// @nodoc
abstract mixin class $SyncRequestCopyWith<$Res>  {
  factory $SyncRequestCopyWith(SyncRequest value, $Res Function(SyncRequest) _then) = _$SyncRequestCopyWithImpl;
@useResult
$Res call({
 DateTime? lastSyncDate, List<Map<String, dynamic>> categories, List<Map<String, dynamic>> noteTypes, List<Map<String, dynamic>> notes, List<Map<String, dynamic>> schedules, List<Map<String, dynamic>> reminders, List<Map<String, dynamic>> noteCategories, List<Map<String, dynamic>> deletions
});




}
/// @nodoc
class _$SyncRequestCopyWithImpl<$Res>
    implements $SyncRequestCopyWith<$Res> {
  _$SyncRequestCopyWithImpl(this._self, this._then);

  final SyncRequest _self;
  final $Res Function(SyncRequest) _then;

/// Create a copy of SyncRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastSyncDate = freezed,Object? categories = null,Object? noteTypes = null,Object? notes = null,Object? schedules = null,Object? reminders = null,Object? noteCategories = null,Object? deletions = null,}) {
  return _then(_self.copyWith(
lastSyncDate: freezed == lastSyncDate ? _self.lastSyncDate : lastSyncDate // ignore: cast_nullable_to_non_nullable
as DateTime?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,noteTypes: null == noteTypes ? _self.noteTypes : noteTypes // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,schedules: null == schedules ? _self.schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,reminders: null == reminders ? _self.reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,noteCategories: null == noteCategories ? _self.noteCategories : noteCategories // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,deletions: null == deletions ? _self.deletions : deletions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncRequest].
extension SyncRequestPatterns on SyncRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncRequest value)  $default,){
final _that = this;
switch (_that) {
case _SyncRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SyncRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? lastSyncDate,  List<Map<String, dynamic>> categories,  List<Map<String, dynamic>> noteTypes,  List<Map<String, dynamic>> notes,  List<Map<String, dynamic>> schedules,  List<Map<String, dynamic>> reminders,  List<Map<String, dynamic>> noteCategories,  List<Map<String, dynamic>> deletions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncRequest() when $default != null:
return $default(_that.lastSyncDate,_that.categories,_that.noteTypes,_that.notes,_that.schedules,_that.reminders,_that.noteCategories,_that.deletions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? lastSyncDate,  List<Map<String, dynamic>> categories,  List<Map<String, dynamic>> noteTypes,  List<Map<String, dynamic>> notes,  List<Map<String, dynamic>> schedules,  List<Map<String, dynamic>> reminders,  List<Map<String, dynamic>> noteCategories,  List<Map<String, dynamic>> deletions)  $default,) {final _that = this;
switch (_that) {
case _SyncRequest():
return $default(_that.lastSyncDate,_that.categories,_that.noteTypes,_that.notes,_that.schedules,_that.reminders,_that.noteCategories,_that.deletions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? lastSyncDate,  List<Map<String, dynamic>> categories,  List<Map<String, dynamic>> noteTypes,  List<Map<String, dynamic>> notes,  List<Map<String, dynamic>> schedules,  List<Map<String, dynamic>> reminders,  List<Map<String, dynamic>> noteCategories,  List<Map<String, dynamic>> deletions)?  $default,) {final _that = this;
switch (_that) {
case _SyncRequest() when $default != null:
return $default(_that.lastSyncDate,_that.categories,_that.noteTypes,_that.notes,_that.schedules,_that.reminders,_that.noteCategories,_that.deletions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncRequest implements SyncRequest {
  const _SyncRequest({this.lastSyncDate, final  List<Map<String, dynamic>> categories = const [], final  List<Map<String, dynamic>> noteTypes = const [], final  List<Map<String, dynamic>> notes = const [], final  List<Map<String, dynamic>> schedules = const [], final  List<Map<String, dynamic>> reminders = const [], final  List<Map<String, dynamic>> noteCategories = const [], final  List<Map<String, dynamic>> deletions = const []}): _categories = categories,_noteTypes = noteTypes,_notes = notes,_schedules = schedules,_reminders = reminders,_noteCategories = noteCategories,_deletions = deletions;
  factory _SyncRequest.fromJson(Map<String, dynamic> json) => _$SyncRequestFromJson(json);

/// Last sync date to get changes after this date
@override final  DateTime? lastSyncDate;
/// Categories created or updated since last sync
 final  List<Map<String, dynamic>> _categories;
/// Categories created or updated since last sync
@override@JsonKey() List<Map<String, dynamic>> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

/// Note types created or updated since last sync
 final  List<Map<String, dynamic>> _noteTypes;
/// Note types created or updated since last sync
@override@JsonKey() List<Map<String, dynamic>> get noteTypes {
  if (_noteTypes is EqualUnmodifiableListView) return _noteTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_noteTypes);
}

/// Notes created or updated since last sync
 final  List<Map<String, dynamic>> _notes;
/// Notes created or updated since last sync
@override@JsonKey() List<Map<String, dynamic>> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}

/// Schedules created or updated since last sync
 final  List<Map<String, dynamic>> _schedules;
/// Schedules created or updated since last sync
@override@JsonKey() List<Map<String, dynamic>> get schedules {
  if (_schedules is EqualUnmodifiableListView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedules);
}

/// Reminders created or updated since last sync
 final  List<Map<String, dynamic>> _reminders;
/// Reminders created or updated since last sync
@override@JsonKey() List<Map<String, dynamic>> get reminders {
  if (_reminders is EqualUnmodifiableListView) return _reminders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminders);
}

/// Note-Category relationships created or updated since last sync
 final  List<Map<String, dynamic>> _noteCategories;
/// Note-Category relationships created or updated since last sync
@override@JsonKey() List<Map<String, dynamic>> get noteCategories {
  if (_noteCategories is EqualUnmodifiableListView) return _noteCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_noteCategories);
}

/// Pending deletions to be communicated to backend
/// Format: {"entityType": "category", "entityId": "uuid"}
 final  List<Map<String, dynamic>> _deletions;
/// Pending deletions to be communicated to backend
/// Format: {"entityType": "category", "entityId": "uuid"}
@override@JsonKey() List<Map<String, dynamic>> get deletions {
  if (_deletions is EqualUnmodifiableListView) return _deletions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deletions);
}


/// Create a copy of SyncRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncRequestCopyWith<_SyncRequest> get copyWith => __$SyncRequestCopyWithImpl<_SyncRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncRequest&&(identical(other.lastSyncDate, lastSyncDate) || other.lastSyncDate == lastSyncDate)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._noteTypes, _noteTypes)&&const DeepCollectionEquality().equals(other._notes, _notes)&&const DeepCollectionEquality().equals(other._schedules, _schedules)&&const DeepCollectionEquality().equals(other._reminders, _reminders)&&const DeepCollectionEquality().equals(other._noteCategories, _noteCategories)&&const DeepCollectionEquality().equals(other._deletions, _deletions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lastSyncDate,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_noteTypes),const DeepCollectionEquality().hash(_notes),const DeepCollectionEquality().hash(_schedules),const DeepCollectionEquality().hash(_reminders),const DeepCollectionEquality().hash(_noteCategories),const DeepCollectionEquality().hash(_deletions));

@override
String toString() {
  return 'SyncRequest(lastSyncDate: $lastSyncDate, categories: $categories, noteTypes: $noteTypes, notes: $notes, schedules: $schedules, reminders: $reminders, noteCategories: $noteCategories, deletions: $deletions)';
}


}

/// @nodoc
abstract mixin class _$SyncRequestCopyWith<$Res> implements $SyncRequestCopyWith<$Res> {
  factory _$SyncRequestCopyWith(_SyncRequest value, $Res Function(_SyncRequest) _then) = __$SyncRequestCopyWithImpl;
@override @useResult
$Res call({
 DateTime? lastSyncDate, List<Map<String, dynamic>> categories, List<Map<String, dynamic>> noteTypes, List<Map<String, dynamic>> notes, List<Map<String, dynamic>> schedules, List<Map<String, dynamic>> reminders, List<Map<String, dynamic>> noteCategories, List<Map<String, dynamic>> deletions
});




}
/// @nodoc
class __$SyncRequestCopyWithImpl<$Res>
    implements _$SyncRequestCopyWith<$Res> {
  __$SyncRequestCopyWithImpl(this._self, this._then);

  final _SyncRequest _self;
  final $Res Function(_SyncRequest) _then;

/// Create a copy of SyncRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastSyncDate = freezed,Object? categories = null,Object? noteTypes = null,Object? notes = null,Object? schedules = null,Object? reminders = null,Object? noteCategories = null,Object? deletions = null,}) {
  return _then(_SyncRequest(
lastSyncDate: freezed == lastSyncDate ? _self.lastSyncDate : lastSyncDate // ignore: cast_nullable_to_non_nullable
as DateTime?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,noteTypes: null == noteTypes ? _self._noteTypes : noteTypes // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,schedules: null == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,reminders: null == reminders ? _self._reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,noteCategories: null == noteCategories ? _self._noteCategories : noteCategories // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,deletions: null == deletions ? _self._deletions : deletions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}


}

// dart format on
