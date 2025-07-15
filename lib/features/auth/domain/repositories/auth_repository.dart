import '../models/user.dart';

abstract class AuthRepository {
  Future<User> signIn(String email, String password);
  Future<User> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
    String phoneNumber,
    String address,
    DateTime dateOfBirth,
  );
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<User> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String address,
    required DateTime dateOfBirth,
  });
  Future<void> verifyEmail(String code);
  Future<void> changePassword(String currentPassword, String newPassword);
  Stream<User?> get authStateChanges;
  User? get currentUser;
}
