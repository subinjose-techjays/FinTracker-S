import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repository/chat_repository_impl.dart';
import '../domain/repository/chat_repository.dart';
import '../domain/usecase/chat_usecase.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ChatRepositoryImpl(dio: dio);
});

final chatUseCaseProvider = Provider<ChatUseCase>((ref) {
  return ChatUseCase(ref.watch(chatRepositoryProvider));
});
