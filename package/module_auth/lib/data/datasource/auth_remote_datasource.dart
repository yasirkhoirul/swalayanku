import 'package:firebase_auth/firebase_auth.dart';
import 'package:module_auth/domain/entities/user.dart' as user;
import 'package:module_core/common/customerror.dart';

abstract class AuthRemoteDatasource {
  Future<void> onLogin(user.User user);
  Future<String> onLogout();
  Stream<User?> statusLogin();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource{
  final FirebaseAuth firebaseAuth;
  const AuthRemoteDatasourceImpl(this.firebaseAuth);
  @override
  Future<void> onLogin(user.User user) async{
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: user.email, password: user.password);
    } catch (e) {
      throw FirebaseCustomError.handleFirebaseError(e);
    }
  }

  @override
  Future<String> onLogout() async{
    try {
      await firebaseAuth.signOut();
      return "Logout Berhasil";
    } catch (e) {
      throw FirebaseCustomError.handleFirebaseError(e);
    }
  }
  
  @override
  Stream<User?> statusLogin(){
    try {
      return firebaseAuth.authStateChanges();
    } catch (e) {
      throw FirebaseCustomError.getErrorMessage(e.toString());
    }
  }

}