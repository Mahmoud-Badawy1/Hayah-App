import '../../domain/repositories/auth_repository.dart';
import '../../domain/models/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  User? _currentUser;

  @override
  Stream<User?> get authStateChanges => Stream.value(_currentUser);

  @override
  User? get currentUser => _currentUser;

  @override
  Future<User> signIn(String email, String password) async {
    // TODO: Implement actual authentication logic
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simulating network delay

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
    // TODO: Implement actual sign up logic
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simulating network delay

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
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Simulating network delay
    _currentUser = null;
  }

  @override
  Future<void> resetPassword(String email) async {
    // TODO: Implement actual reset password logic
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<User> updateProfile({
    required String address,
    required DateTime dateOfBirth,
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    // TODO: Implement actual profile update logic
    await Future.delayed(const Duration(seconds: 1));
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        address: address,
        dateOfBirth: dateOfBirth,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        updatedAt: DateTime.now(),
      );
    }
    return _currentUser!;
  }

  @override
  Future<void> verifyEmail(String code) async {
    // TODO: Implement actual email verification logic
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
    // TODO: Implement actual password change logic
    await Future.delayed(const Duration(seconds: 1));
  }
}
