import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../login/di/login_provider.dart';
import '../../login/domain/usecases/auth_usecases.dart';

/// Provides the sign out use case for profile functionality.
final profileSignOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(authRepository);
});
