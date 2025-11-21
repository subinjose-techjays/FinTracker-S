// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_effect.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatEffect {

 String get message;
/// Create a copy of ChatEffect
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatEffectCopyWith<ChatEffect> get copyWith => _$ChatEffectCopyWithImpl<ChatEffect>(this as ChatEffect, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatEffect&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatEffect(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatEffectCopyWith<$Res>  {
  factory $ChatEffectCopyWith(ChatEffect value, $Res Function(ChatEffect) _then) = _$ChatEffectCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatEffectCopyWithImpl<$Res>
    implements $ChatEffectCopyWith<$Res> {
  _$ChatEffectCopyWithImpl(this._self, this._then);

  final ChatEffect _self;
  final $Res Function(ChatEffect) _then;

/// Create a copy of ChatEffect
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatEffect].
extension ChatEffectPatterns on ChatEffect {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ShowErrorEffect value)?  showError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ShowErrorEffect() when showError != null:
return showError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ShowErrorEffect value)  showError,}){
final _that = this;
switch (_that) {
case ShowErrorEffect():
return showError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ShowErrorEffect value)?  showError,}){
final _that = this;
switch (_that) {
case ShowErrorEffect() when showError != null:
return showError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message)?  showError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ShowErrorEffect() when showError != null:
return showError(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message)  showError,}) {final _that = this;
switch (_that) {
case ShowErrorEffect():
return showError(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message)?  showError,}) {final _that = this;
switch (_that) {
case ShowErrorEffect() when showError != null:
return showError(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ShowErrorEffect implements ChatEffect {
  const ShowErrorEffect(this.message);
  

@override final  String message;

/// Create a copy of ChatEffect
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShowErrorEffectCopyWith<ShowErrorEffect> get copyWith => _$ShowErrorEffectCopyWithImpl<ShowErrorEffect>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShowErrorEffect&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatEffect.showError(message: $message)';
}


}

/// @nodoc
abstract mixin class $ShowErrorEffectCopyWith<$Res> implements $ChatEffectCopyWith<$Res> {
  factory $ShowErrorEffectCopyWith(ShowErrorEffect value, $Res Function(ShowErrorEffect) _then) = _$ShowErrorEffectCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ShowErrorEffectCopyWithImpl<$Res>
    implements $ShowErrorEffectCopyWith<$Res> {
  _$ShowErrorEffectCopyWithImpl(this._self, this._then);

  final ShowErrorEffect _self;
  final $Res Function(ShowErrorEffect) _then;

/// Create a copy of ChatEffect
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ShowErrorEffect(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
