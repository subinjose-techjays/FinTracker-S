// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatState()';
}


}

/// @nodoc
class $ChatStateCopyWith<$Res>  {
$ChatStateCopyWith(ChatState _, $Res Function(ChatState) __);
}


/// Adds pattern-matching-related methods to [ChatState].
extension ChatStatePatterns on ChatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChatStateInitial value)?  initial,TResult Function( ChatStateLoading value)?  loading,TResult Function( ChatStateDownloading value)?  downloading,TResult Function( ChatStateReady value)?  ready,TResult Function( ChatStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChatStateInitial() when initial != null:
return initial(_that);case ChatStateLoading() when loading != null:
return loading(_that);case ChatStateDownloading() when downloading != null:
return downloading(_that);case ChatStateReady() when ready != null:
return ready(_that);case ChatStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChatStateInitial value)  initial,required TResult Function( ChatStateLoading value)  loading,required TResult Function( ChatStateDownloading value)  downloading,required TResult Function( ChatStateReady value)  ready,required TResult Function( ChatStateError value)  error,}){
final _that = this;
switch (_that) {
case ChatStateInitial():
return initial(_that);case ChatStateLoading():
return loading(_that);case ChatStateDownloading():
return downloading(_that);case ChatStateReady():
return ready(_that);case ChatStateError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChatStateInitial value)?  initial,TResult? Function( ChatStateLoading value)?  loading,TResult? Function( ChatStateDownloading value)?  downloading,TResult? Function( ChatStateReady value)?  ready,TResult? Function( ChatStateError value)?  error,}){
final _that = this;
switch (_that) {
case ChatStateInitial() when initial != null:
return initial(_that);case ChatStateLoading() when loading != null:
return loading(_that);case ChatStateDownloading() when downloading != null:
return downloading(_that);case ChatStateReady() when ready != null:
return ready(_that);case ChatStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( double progress)?  downloading,TResult Function( List<ChatMessage> messages)?  ready,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChatStateInitial() when initial != null:
return initial();case ChatStateLoading() when loading != null:
return loading();case ChatStateDownloading() when downloading != null:
return downloading(_that.progress);case ChatStateReady() when ready != null:
return ready(_that.messages);case ChatStateError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( double progress)  downloading,required TResult Function( List<ChatMessage> messages)  ready,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ChatStateInitial():
return initial();case ChatStateLoading():
return loading();case ChatStateDownloading():
return downloading(_that.progress);case ChatStateReady():
return ready(_that.messages);case ChatStateError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( double progress)?  downloading,TResult? Function( List<ChatMessage> messages)?  ready,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ChatStateInitial() when initial != null:
return initial();case ChatStateLoading() when loading != null:
return loading();case ChatStateDownloading() when downloading != null:
return downloading(_that.progress);case ChatStateReady() when ready != null:
return ready(_that.messages);case ChatStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ChatStateInitial implements ChatState {
  const ChatStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatState.initial()';
}


}




/// @nodoc


class ChatStateLoading implements ChatState {
  const ChatStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatState.loading()';
}


}




/// @nodoc


class ChatStateDownloading implements ChatState {
  const ChatStateDownloading(this.progress);
  

 final  double progress;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStateDownloadingCopyWith<ChatStateDownloading> get copyWith => _$ChatStateDownloadingCopyWithImpl<ChatStateDownloading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStateDownloading&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,progress);

@override
String toString() {
  return 'ChatState.downloading(progress: $progress)';
}


}

/// @nodoc
abstract mixin class $ChatStateDownloadingCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory $ChatStateDownloadingCopyWith(ChatStateDownloading value, $Res Function(ChatStateDownloading) _then) = _$ChatStateDownloadingCopyWithImpl;
@useResult
$Res call({
 double progress
});




}
/// @nodoc
class _$ChatStateDownloadingCopyWithImpl<$Res>
    implements $ChatStateDownloadingCopyWith<$Res> {
  _$ChatStateDownloadingCopyWithImpl(this._self, this._then);

  final ChatStateDownloading _self;
  final $Res Function(ChatStateDownloading) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? progress = null,}) {
  return _then(ChatStateDownloading(
null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class ChatStateReady implements ChatState {
  const ChatStateReady(final  List<ChatMessage> messages): _messages = messages;
  

 final  List<ChatMessage> _messages;
 List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStateReadyCopyWith<ChatStateReady> get copyWith => _$ChatStateReadyCopyWithImpl<ChatStateReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStateReady&&const DeepCollectionEquality().equals(other._messages, _messages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages));

@override
String toString() {
  return 'ChatState.ready(messages: $messages)';
}


}

/// @nodoc
abstract mixin class $ChatStateReadyCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory $ChatStateReadyCopyWith(ChatStateReady value, $Res Function(ChatStateReady) _then) = _$ChatStateReadyCopyWithImpl;
@useResult
$Res call({
 List<ChatMessage> messages
});




}
/// @nodoc
class _$ChatStateReadyCopyWithImpl<$Res>
    implements $ChatStateReadyCopyWith<$Res> {
  _$ChatStateReadyCopyWithImpl(this._self, this._then);

  final ChatStateReady _self;
  final $Res Function(ChatStateReady) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messages = null,}) {
  return _then(ChatStateReady(
null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,
  ));
}


}

/// @nodoc


class ChatStateError implements ChatState {
  const ChatStateError(this.message);
  

 final  String message;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStateErrorCopyWith<ChatStateError> get copyWith => _$ChatStateErrorCopyWithImpl<ChatStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatStateErrorCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory $ChatStateErrorCopyWith(ChatStateError value, $Res Function(ChatStateError) _then) = _$ChatStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatStateErrorCopyWithImpl<$Res>
    implements $ChatStateErrorCopyWith<$Res> {
  _$ChatStateErrorCopyWithImpl(this._self, this._then);

  final ChatStateError _self;
  final $Res Function(ChatStateError) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ChatStateError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
