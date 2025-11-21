// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatEvent()';
}


}

/// @nodoc
class $ChatEventCopyWith<$Res>  {
$ChatEventCopyWith(ChatEvent _, $Res Function(ChatEvent) __);
}


/// Adds pattern-matching-related methods to [ChatEvent].
extension ChatEventPatterns on ChatEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DownloadModelEvent value)?  downloadModel,TResult Function( SendMessageEvent value)?  sendMessage,TResult Function( CheckModelStatusEvent value)?  checkModelStatus,TResult Function( PickModelFileEvent value)?  pickModelFile,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DownloadModelEvent() when downloadModel != null:
return downloadModel(_that);case SendMessageEvent() when sendMessage != null:
return sendMessage(_that);case CheckModelStatusEvent() when checkModelStatus != null:
return checkModelStatus(_that);case PickModelFileEvent() when pickModelFile != null:
return pickModelFile(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DownloadModelEvent value)  downloadModel,required TResult Function( SendMessageEvent value)  sendMessage,required TResult Function( CheckModelStatusEvent value)  checkModelStatus,required TResult Function( PickModelFileEvent value)  pickModelFile,}){
final _that = this;
switch (_that) {
case DownloadModelEvent():
return downloadModel(_that);case SendMessageEvent():
return sendMessage(_that);case CheckModelStatusEvent():
return checkModelStatus(_that);case PickModelFileEvent():
return pickModelFile(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DownloadModelEvent value)?  downloadModel,TResult? Function( SendMessageEvent value)?  sendMessage,TResult? Function( CheckModelStatusEvent value)?  checkModelStatus,TResult? Function( PickModelFileEvent value)?  pickModelFile,}){
final _that = this;
switch (_that) {
case DownloadModelEvent() when downloadModel != null:
return downloadModel(_that);case SendMessageEvent() when sendMessage != null:
return sendMessage(_that);case CheckModelStatusEvent() when checkModelStatus != null:
return checkModelStatus(_that);case PickModelFileEvent() when pickModelFile != null:
return pickModelFile(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  downloadModel,TResult Function( String message)?  sendMessage,TResult Function()?  checkModelStatus,TResult Function()?  pickModelFile,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DownloadModelEvent() when downloadModel != null:
return downloadModel();case SendMessageEvent() when sendMessage != null:
return sendMessage(_that.message);case CheckModelStatusEvent() when checkModelStatus != null:
return checkModelStatus();case PickModelFileEvent() when pickModelFile != null:
return pickModelFile();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  downloadModel,required TResult Function( String message)  sendMessage,required TResult Function()  checkModelStatus,required TResult Function()  pickModelFile,}) {final _that = this;
switch (_that) {
case DownloadModelEvent():
return downloadModel();case SendMessageEvent():
return sendMessage(_that.message);case CheckModelStatusEvent():
return checkModelStatus();case PickModelFileEvent():
return pickModelFile();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  downloadModel,TResult? Function( String message)?  sendMessage,TResult? Function()?  checkModelStatus,TResult? Function()?  pickModelFile,}) {final _that = this;
switch (_that) {
case DownloadModelEvent() when downloadModel != null:
return downloadModel();case SendMessageEvent() when sendMessage != null:
return sendMessage(_that.message);case CheckModelStatusEvent() when checkModelStatus != null:
return checkModelStatus();case PickModelFileEvent() when pickModelFile != null:
return pickModelFile();case _:
  return null;

}
}

}

/// @nodoc


class DownloadModelEvent implements ChatEvent {
  const DownloadModelEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadModelEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatEvent.downloadModel()';
}


}




/// @nodoc


class SendMessageEvent implements ChatEvent {
  const SendMessageEvent(this.message);
  

 final  String message;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendMessageEventCopyWith<SendMessageEvent> get copyWith => _$SendMessageEventCopyWithImpl<SendMessageEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendMessageEvent&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatEvent.sendMessage(message: $message)';
}


}

/// @nodoc
abstract mixin class $SendMessageEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $SendMessageEventCopyWith(SendMessageEvent value, $Res Function(SendMessageEvent) _then) = _$SendMessageEventCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SendMessageEventCopyWithImpl<$Res>
    implements $SendMessageEventCopyWith<$Res> {
  _$SendMessageEventCopyWithImpl(this._self, this._then);

  final SendMessageEvent _self;
  final $Res Function(SendMessageEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SendMessageEvent(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CheckModelStatusEvent implements ChatEvent {
  const CheckModelStatusEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckModelStatusEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatEvent.checkModelStatus()';
}


}




/// @nodoc


class PickModelFileEvent implements ChatEvent {
  const PickModelFileEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickModelFileEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatEvent.pickModelFile()';
}


}




// dart format on
