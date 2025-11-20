import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fin_tracker/features/login/data/remote/auth_repository_impl/auth_repository_impl.dart';

// Mock classes for testing
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late AuthRepositoryImpl authRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    authRepository = AuthRepositoryImpl(mockFirebaseAuth);
  });

  setUpAll(() {
    registerFallbackValue(FakeGoogleAuthProvider());
  });

  group('AuthRepositoryImpl', () {
    group('signInWithGoogle', () {
      test('should return UserCredential when sign in succeeds', () async {
        // Arrange
        when(() => mockFirebaseAuth.signInWithProvider(any()))
            .thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await authRepository.signInWithGoogle();

        // Assert
        expect(result, mockUserCredential);
        verify(() => mockFirebaseAuth.signInWithProvider(any())).called(1);
      });

      test('should throw exception when sign in fails', () async {
        // Arrange
        final exception = Exception('Sign in failed');
        when(() => mockFirebaseAuth.signInWithProvider(any()))
            .thenThrow(exception);

        // Act & Assert
        expect(
          () => authRepository.signInWithGoogle(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('signOut', () {
      test('should complete successfully when sign out succeeds', () async {
        // Arrange
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

        // Act & Assert
        await expectLater(authRepository.signOut(), completes);
        verify(() => mockFirebaseAuth.signOut()).called(1);
      });

      test('should throw exception when sign out fails', () async {
        // Arrange
        final exception = Exception('Sign out failed');
        when(() => mockFirebaseAuth.signOut()).thenThrow(exception);

        // Act & Assert
        expect(
          () => authRepository.signOut(),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}

// Fallback value for GoogleAuthProvider
class FakeGoogleAuthProvider extends Fake implements GoogleAuthProvider {
  @override
  GoogleAuthProvider addScope(String scope) => this;

  @override
  GoogleAuthProvider setCustomParameters(Map<dynamic, dynamic> customParameters) => this;
}
