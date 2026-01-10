
import 'package:module_auth/domain/entities/user.dart';
import 'package:module_auth/domain/repository/auth_repository.dart';

class GetLogin {
  final AuthRepository authRepository;
  const GetLogin(this.authRepository);

  Future<void> execute(User user)async{
    await authRepository.onLogin(user);
  }
}