
import 'package:module_auth/domain/entities/user.dart';
import 'package:module_auth/domain/repository/auth_repository.dart';

class GetLogin {
  final AuthRepository authRepository;
  const GetLogin(this.authRepository);

  Future<UserInfo> execute(User user) async {
    return await authRepository.onLogin(user);
  }

  Future<UserInfo> getUserInfo(String userId) async {
    return await authRepository.getUserInfo(userId);
  }
}