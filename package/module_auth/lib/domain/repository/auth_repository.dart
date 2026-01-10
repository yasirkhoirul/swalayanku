import 'package:firebase_auth/firebase_auth.dart';
import 'package:module_auth/domain/entities/user.dart' as user;

abstract class AuthRepository {
  Future<void> onLogin(user.User user);
  Future<String> onLogout();
  Stream<User?> checkStatusUser();
}