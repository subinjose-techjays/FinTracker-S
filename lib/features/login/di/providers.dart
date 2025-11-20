import 'package:riverpod/riverpod.dart';
import '../data/remote/login_repository_impl/login_repository_impl.dart';
import '../domain/remote/repositories/login_repository.dart';
import '../domain/usecases/login_data_usecase.dart';
import '../presentation/state/login_state/login_effect.dart';
import '../presentation/state/login_state/login_state.dart';
import '../presentation/viewmodel/login_view_model.dart';


/// Provides the concrete implementation of [LoginRepository].
///
/// This provider is responsible for creating an instance of [LoginRepositoryImpl],
/// which handles the actual data fetching logic for login-related operations.
/// Other parts of the application can use this provider to access the
/// login repository.
final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepositoryImpl();
});


/// Provides the [LoginDataUseCase].
///
/// This provider creates an instance of [LoginDataUseCase], which encapsulates
/// the business logic for fetching login-related data. It depends on the
/// [loginRepositoryProvider] to get an instance of [LoginRepository].
final loginDataUseCaseProvider = Provider<LoginDataUseCase>((ref) {
  final repo = ref.watch(loginRepositoryProvider);
  return LoginDataUseCase(repo);
});


/// Provides the [LoginViewModel].
///
/// This provider creates an instance of [LoginViewModel], which is responsible
/// for managing the state of the login screen and handling user interactions.
/// It depends on the [loginDataUseCaseProvider] to get an instance of
/// [LoginDataUseCase] for fetching data.
final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
      final useCase = ref.watch(loginDataUseCaseProvider);
      return LoginViewModel(useCase);
    });


final loginEffectProvider = StreamProvider<LoginEffect?>((ref) {
  return ref.watch(loginViewModelProvider.notifier).effectStream;
});
