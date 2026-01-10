import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:module_auth/domain/entities/user.dart';
import 'package:module_auth/domain/usecase/check_login.dart';
import 'package:module_auth/domain/usecase/get_login.dart';
import 'package:module_auth/domain/usecase/get_logout.dart';

part 'authenticating_event.dart';
part 'authenticating_state.dart';

class AuthenticatingBloc extends Bloc<AuthenticatingEvent, AuthenticatingState> {
  final GetLogin getLogin;
  final GetLogout getLogout;
  final CheckLogin checkLogin;
  late StreamSubscription _authStream;
  AuthenticatingBloc(this.getLogin, this.getLogout, this.checkLogin) : super(AuthenticatingInitial()) {
    _authStream = checkLogin.execute().listen((event) {
      if (event==null) {
        add(AuthOnLogout());
      }else{
        add(AuthOnInstantLogin());
      }
    },);
    on<AuthOnSubmit>((event, emit) async{
      emit(AuthenticatingLoading());
      try {
        await getLogin.execute(event.user);
        emit(AuthenticatingSucces());
      } catch (e) {
        emit(AuthenticatingError(e.toString()));
      }
    },);
    on<AuthOnLogout>((event, emit) async{
      emit(AuthenticatingLoading());
      try {
        await getLogout.execute();
        emit(AuthenticatingInitial());
      } catch (e) {
        emit(AuthenticatingError(e.toString()));
      }
    },);
    on<AuthOnRetry>((event, emit) {
      emit(AuthenticatingInitial());
    },);
    on<AuthOnInstantLogin>((event, emit) {
      emit(AuthenticatingSucces());
    },);
  }

  @override
  Future<void> close() {
    _authStream.cancel();
    return super.close();
  }
}
