import 'package:module_auth/domain/entities/user.dart';
import 'package:module_auth/domain/repository/auth_repository.dart';

class GetSignup {
  final AuthRepository authRepository;
  const GetSignup(this.authRepository);

  Future<UserInfo> execute(UserSignup userSignup) async {
    return await authRepository.onSignup(userSignup);
  }
}
