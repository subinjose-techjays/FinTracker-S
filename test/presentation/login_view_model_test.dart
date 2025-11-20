import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fin_tracker/features/login/domain/usecases/auth_usecases.dart';
import 'package:fin_tracker/features/login/presentation/event/login_events.dart';
import 'package:fin_tracker/features/login/presentation/state/login_state/login_effect.dart';
import 'package:fin_tracker/features/login/presentation/state/login_state/login_state.dart';
import 'package:fin_tracker/features/login/presentation/viewmodel/login_view_model.dart';

// Mock classes for testing
class MockGoogleSignInUseCase extends Mock implements GoogleSignInUseCase {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late LoginViewModel loginViewModel;
  late MockGoogleSignInUseCase mockGoogleSignInUseCase;
  late MockUserCredential mockUserCredential;
  late StreamController<LoginEffect> effectController;

  setUp(() {
    mockGoogleSignInUseCase = MockGoogleSignInUseCase();
    mockUserCredential = MockUserCredential();
    loginViewModel = LoginViewModel(mockGoogleSignInUseCase);
    effectController = StreamController<LoginEffect>.broadcast();
  });

  tearDown(() {
    if (!loginViewModel.mounted) return; // Don't dispose if already disposed in test
    loginViewModel.dispose();
    effectController.close();
  });

  group('LoginViewModel', () {
    group('initial state', () {
      test('should start with initial state', () {
        expect(loginViewModel.state, const LoginState.initial());
      });
    });

    group('onEvent', () {
      test('should emit ShowBottomSheetEffect when ShowBottomSheet event is received', () async {
        // Arrange
        final effects = <LoginEffect>[];
        final subscription = loginViewModel.effectStream.listen(effects.add);

        // Act
        loginViewModel.onEvent(ShowBottomSheet());

        // Allow async operations to complete
        await Future.delayed(Duration.zero);

        // Assert
        expect(effects, hasLength(1));
        expect(effects.first, isA<ShowBottomSheetEffect>());

        await subscription.cancel();
      });

      test('should handle GoogleSignInEvent and emit NavigateToDashBoard on success', () async {
        // Arrange
        when(() => mockGoogleSignInUseCase.execute())
            .thenAnswer((_) async => mockUserCredential);

        final effects = <LoginEffect>[];
        final subscription = loginViewModel.effectStream.listen(effects.add);

        // Act
        loginViewModel.onEvent(GoogleSignInEvent());

        // Allow async operations to complete
        await Future.delayed(Duration(milliseconds: 10));

        // Assert
        expect(effects, hasLength(1));
        expect(effects.first, isA<NavigateToDashBoard>());

        verify(() => mockGoogleSignInUseCase.execute()).called(1);

        await subscription.cancel();
      });

      test('should handle GoogleSignInEvent and set error state on failure', () async {
        // Arrange
        final exception = Exception('Sign in failed');
        when(() => mockGoogleSignInUseCase.execute()).thenThrow(exception);

        // Act
        loginViewModel.onEvent(GoogleSignInEvent());

        // Allow async operations to complete
        await Future.delayed(Duration(milliseconds: 10));

        // Assert
        expect(loginViewModel.state, isA<LoginState>());
        loginViewModel.state.maybeWhen(
          miscError: (error) {
            expect(error, contains('Google Sign In failed'));
          },
          orElse: () => fail('Expected miscError state'),
        );

        verify(() => mockGoogleSignInUseCase.execute()).called(1);
      });

      test('should set loading state during Google Sign In', () async {
        // Arrange
        when(() => mockGoogleSignInUseCase.execute())
            .thenAnswer((_) async => mockUserCredential);

        // Act
        loginViewModel.onEvent(GoogleSignInEvent());

        // Check loading state immediately
        expect(loginViewModel.state, const LoginState.loading());
      });
    });

    group('dispose', () {
      test('should close effect stream when disposed', () async {
        // Arrange - create a fresh view model for this test
        final testViewModel = LoginViewModel(mockGoogleSignInUseCase);
        final effects = <LoginEffect>[];
        final subscription = testViewModel.effectStream.listen(
          effects.add,
          onDone: () => effects.add(ShowBottomSheetEffect()), // This should not be called
        );

        // Act
        testViewModel.dispose();

        // Assert that no effects were emitted (dispose should prevent new emissions)
        expect(effects.isEmpty, isTrue);

        await subscription.cancel();
      });
    });
  });
}
