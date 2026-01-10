import 'package:firebase_auth/firebase_auth.dart';
import 'package:module_auth/domain/repository/auth_repository.dart';

class CheckLogin {
  final AuthRepository authRepository;
  const CheckLogin(this.authRepository);

  Stream<User?> execute(){
    return authRepository.checkStatusUser();
  }
}