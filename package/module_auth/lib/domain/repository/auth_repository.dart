import 'package:firebase_auth/firebase_auth.dart';
import 'package:module_auth/domain/entities/user.dart' as user;

abstract class AuthRepository {
  Future<user.UserInfo> onLogin(user.User userCredential);
  Future<user.UserInfo> onSignup(user.UserSignup userSignup);
  Future<String> onLogout();
  Stream<User?> checkStatusUser();
  Future<user.UserInfo> getUserInfo(String userId);
}