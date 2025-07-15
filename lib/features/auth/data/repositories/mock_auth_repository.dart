import '../../domain/repositories/auth_repository.dart';
import '../../domain/models/user.dart';

class MockAuthRepository implements AuthRepository {
  User? _currentUser;

  @override
  Stream<User?> get authStateChanges => Stream.value(_currentUser);

  @override
  User? get currentUser => _currentUser;

  @override
  Future<User> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = User(
      id: '1',
      email: email,
      firstName: 'John',
      lastName: 'Doe',
      isEmailVerified: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<User> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
    String phoneNumber,
    String address,
    DateTime dateOfBirth,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = User(
      id: '1',
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      address: address,
      dateOfBirth: dateOfBirth,
      isEmailVerified: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  @override
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<User> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String address,
    required DateTime dateOfBirth,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = User(
      id: _currentUser?.id ?? '1',
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      address: address,
      dateOfBirth: dateOfBirth,
      isEmailVerified: _currentUser?.isEmailVerified ?? false,
      createdAt: _currentUser?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<void> verifyEmail(String code) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(isEmailVerified: true);
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
