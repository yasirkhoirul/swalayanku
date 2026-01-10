import 'package:module_auth/domain/repository/auth_repository.dart';

class GetLogout {
  final AuthRepository authRepository;
  const GetLogout(this.authRepository);

  Future<String> execute()async{
    return authRepository.onLogout();
  }
}