import 'package:firebase_auth/firebase_auth.dart';
import 'package:module_auth/data/datasource/auth_remote_datasource.dart';
import 'package:module_auth/domain/repository/auth_repository.dart';
import 'package:module_auth/domain/entities/user.dart' as user;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  const AuthRepositoryImpl(this.authRemoteDatasource);

  @override
  Stream<User?> checkStatusUser() {
    return authRemoteDatasource.statusLogin();
  }

  @override
  Future<user.UserInfo> onLogin(user.User userCredential) {
    return authRemoteDatasource.onLogin(userCredential);
  }

  @override
  Future<user.UserInfo> onSignup(user.UserSignup userSignup) {
    return authRemoteDatasource.onSignup(userSignup);
  }

  @override
  Future<String> onLogout() {
    return authRemoteDatasource.onLogout();
  }

  @override
  Future<user.UserInfo> getUserInfo(String userId) {
    return authRemoteDatasource.getUserInfo(userId);
  }
}