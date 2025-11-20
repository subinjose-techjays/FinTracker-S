import 'package:fin_tracker/features/login/di/providers.dart';
import 'package:fin_tracker/features/login/domain/remote/repositories/login_repository.dart';
import 'package:fin_tracker/features/login/presentation/event/login_events.dart';
import 'package:fin_tracker/features/login/presentation/state/log_in_validation.dart';
import 'package:fin_tracker/features/login/presentation/state/login_state/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Fake Repository
class FakeMyFeatureRepository implements LoginRepository {
  @override
  LoginPair<EmailValidation, PasswordValidation> validateEmailPassword(
    String email,
    String password,
  ) {
    throw UnimplementedError();
  }
}

void main() {
  test(
    'Should emit loading and then success when LoadData is triggered',
    () async {
      final container = ProviderContainer(
        overrides: [
          loginRepositoryProvider.overrideWithValue(FakeMyFeatureRepository()),
        ],
      );

      final viewModel = container.read(loginViewModelProvider.notifier);
      final states = <LoginState>[];

      // Listen and collect emitted states
      final sub = container.listen<LoginState>(loginViewModelProvider, (
        previous,
        next,
      ) {
        states.add(next);
      }, fireImmediately: true);

      // Act
      viewModel.onEvent(ShowBottomSheet());

      // Give it time to emit
      await Future.delayed(Duration(milliseconds: 100));

      // Check if states include loading and success using `.when`
      bool hasLoading = false;
      bool hasSuccess = false;
      String? successData;

      /*   for (final state in states) {
        state.maybeWhen(
          initial: () {},
          loading: () => hasLoading = true,
          error: (_) {},
          else:()=>{}
        );
      }*/

      expect(hasLoading, isTrue);
      expect(hasSuccess, isTrue);
      expect(successData, equals('Test data'));

      sub.close();
    },
  );
}
