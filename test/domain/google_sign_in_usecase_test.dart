import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fin_tracker/features/login/domain/remote/repositories/auth_repository.dart';
import 'package:fin_tracker/features/login/domain/usecases/auth_usecases.dart';

// Mock classes for testing
class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late GoogleSignInUseCase googleSignInUseCase;
  late MockAuthRepository mockAuthRepository;
  late MockUserCredential mockUserCredential;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUserCredential = MockUserCredential();
    googleSignInUseCase = GoogleSignInUseCase(mockAuthRepository);
  });

  group('GoogleSignInUseCase', () {
    test('should return UserCredential when sign in succeeds', () async {
      // Arrange
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenAnswer((_) async => mockUserCredential);

      // Act
      final result = await googleSignInUseCase.execute();

      // Assert
      expect(result, mockUserCredential);
      verify(() => mockAuthRepository.signInWithGoogle()).called(1);
    });

    test('should throw exception when sign in fails', () async {
      // Arrange
      final exception = Exception('Sign in failed');
      when(() => mockAuthRepository.signInWithGoogle()).thenThrow(exception);

      // Act & Assert
      expect(() => googleSignInUseCase.execute(), throwsA(isA<Exception>()));
    });
  });
}


