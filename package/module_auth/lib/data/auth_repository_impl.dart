import 'package:firebase_auth/firebase_auth.dart';
import 'package:module_auth/data/datasource/auth_remote_datasource.dart';
import 'package:module_auth/domain/repository/auth_repository.dart';
import 'package:module_auth/domain/entities/user.dart' as user;

class AuthRepositoryImpl implements AuthRepository{
  final AuthRemoteDatasource authRemoteDatasource;
  const AuthRepositoryImpl(this.authRemoteDatasource);
  @override
  Stream<User?> checkStatusUser() {
    return authRemoteDatasource.statusLogin();
  }

  @override
  Future<void> onLogin(user.User user) {
    return authRemoteDatasource.onLogin(user);
  }

  @override
  Future<String> onLogout() {
    return authRemoteDatasource.onLogout();
  }

}