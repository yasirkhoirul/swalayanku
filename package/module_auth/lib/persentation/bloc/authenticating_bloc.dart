import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:module_auth/domain/entities/user.dart';
import 'package:module_auth/domain/usecase/check_login.dart';
import 'package:module_auth/domain/usecase/get_login.dart';
import 'package:module_auth/domain/usecase/get_logout.dart';
import 'package:module_auth/domain/usecase/get_signup.dart';

part 'authenticating_event.dart';
part 'authenticating_state.dart';

class AuthenticatingBloc extends Bloc<AuthenticatingEvent, AuthenticatingState> {
  final GetLogin getLogin;
  final GetSignup getSignup;
  final GetLogout getLogout;
  final CheckLogin checkLogin;
  late StreamSubscription _authStream;
  UserInfo? _cachedUserInfo;

  AuthenticatingBloc(
    this.getLogin,
    this.getSignup,
    this.getLogout,
    this.checkLogin,
  ) : super(AuthenticatingInitial()) {
    _authStream = checkLogin.execute().listen(
      (event) {
        if (event == null) {
          add(AuthOnLogout());
        } else {
          add(AuthOnInstantLogin(event!.uid));
        }
      },
    );
    on<AuthOnSubmit>(
      (event, emit) async {
        emit(AuthenticatingLoading());
        try {
          // Login returns UserInfo from Cloud Functions
          final userInfo = await getLogin.execute(event.user);
          _cachedUserInfo = userInfo;
          emit(AuthenticatingSucces(userInfo));
        } catch (e) {
          emit(AuthenticatingError(e.toString()));
        }
      },
    );
    on<AuthOnSignup>(
      (event, emit) async {
        emit(AuthenticatingLoading());
        try {
          // Signup returns UserInfo from Cloud Functions
          final userInfo = await getSignup.execute(event.userSignup);
          _cachedUserInfo = userInfo;
          emit(AuthenticatingSucces(userInfo));
        } catch (e) {
          emit(AuthenticatingError(e.toString()));
        }
      },
    );
    on<AuthOnLogout>(
      (event, emit) async {
        emit(AuthenticatingLoading());
        try {
          await getLogout.execute();
          _cachedUserInfo = null;
          emit(AuthenticatingInitial());
        } catch (e) {
          emit(AuthenticatingError(e.toString()));
        }
      },
    );
    on<AuthOnRetry>(
      (event, emit) {
        emit(AuthenticatingInitial());
      },
    );
    on<AuthOnInstantLogin>(
      (event, emit) async {
        // Coba ambil user info jika belum ada cache
        if (_cachedUserInfo == null) {
          try {
            _cachedUserInfo = await getLogin.getUserInfo(event.idUser);
          } catch (e) {
            // Jika gagal, user harus login ulang
            emit(AuthenticatingInitial());
            return;
          }
        }
        emit(AuthenticatingSucces(_cachedUserInfo!));
      },
    );
  }

  @override
  Future<void> close() {
    _authStream.cancel();
    return super.close();
  }
}
