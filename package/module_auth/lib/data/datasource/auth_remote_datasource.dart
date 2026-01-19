import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart' as logger;
import 'package:module_auth/domain/entities/user.dart' as user;
import 'package:module_core/common/customerror.dart';

abstract class AuthRemoteDatasource {
  Future<user.UserInfo> onLogin(user.User userCredential);
  Future<user.UserInfo> onSignup(user.UserSignup userSignup);
  Future<String> onLogout();
  Stream<User?> statusLogin();
  Future<user.UserInfo> getUserInfo(String idUser);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFunctions functions;

  const AuthRemoteDatasourceImpl(this.firebaseAuth, this.functions);

  @override
  Future<user.UserInfo> onLogin(user.User userCredential) async {
    try {
      final user = await firebaseAuth.signInWithEmailAndPassword(
        email: userCredential.email,
        password: userCredential.password,
      );
      if (user.user != null) {
        final userInfo = await getUserInfo(user.user!.uid);
        return userInfo;
      } else {
        throw "unknown";
      }
    } catch (e) {
      logger.Logger().e(e.toString());
      
      throw FirebaseCustomError.handleFirebaseError(e);
    }
  }

  @override
  Future<user.UserInfo> onSignup(user.UserSignup userSignup) async {
    try {
      final callable = functions.httpsCallable('apiCreateUserBasic');
      final response = await callable.call({
        'email': userSignup.email,
        'password': userSignup.password,
        'nama': userSignup.nama,
        'role': userSignup.role,
      });

      final data = response.data;
      if (data['succes'] == true) {
        final userlogin = await firebaseAuth.signInWithEmailAndPassword(
          email: userSignup.email,
          password: userSignup.password,
        );
        if (userlogin.user != null) {
          final userInfo = await getUserInfo(userlogin.user!.uid);
          return userInfo;
        } else {
          throw "unknown";
        }
        // Get user info dari Cloud Functions
      } else {

        throw Exception(data['message'] ?? 'Gagal membuat akun');
      }
    } catch (e) {
      throw FirebaseCustomError.handleFirebaseError(e);
    }
  }

  @override
  Future<user.UserInfo> getUserInfo(String idUser) async {
    try {
      // Call Cloud Function apiGetUserInfo
      final callable = functions.httpsCallable('apiGetUserInfo');
      final response = await callable.call();

      // Cloud Functions langsung return {success: true, data: {...}}
      final data = response.data;
      if (data['success'] == true) {
        return user.UserInfo.fromJson(data['data']);
      } else {
        throw Exception('Gagal mendapatkan info user');
      }
    } catch (e) {
      logger.Logger().e(e.toString());
      throw FirebaseCustomError.handleFirebaseError(e);
    }
  }

  @override
  Future<String> onLogout() async {
    try {
      await firebaseAuth.signOut();
      return "Logout Berhasil";
    } catch (e) {
      throw FirebaseCustomError.handleFirebaseError(e);
    }
  }

  @override
  Stream<User?> statusLogin() {
    try {
      return firebaseAuth.authStateChanges();
    } catch (e) {
      throw FirebaseCustomError.getErrorMessage(e.toString());
    }
  }
}
