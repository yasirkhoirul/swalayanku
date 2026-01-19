part of 'authenticating_bloc.dart';

@immutable
sealed class AuthenticatingEvent {}


class AuthOnSubmit extends AuthenticatingEvent{
  final User user;
  AuthOnSubmit(this.user);
}

class AuthOnSignup extends AuthenticatingEvent{
  final UserSignup userSignup;
  AuthOnSignup(this.userSignup);
}

class AuthOnLogout extends AuthenticatingEvent{}
class AuthOnInstantLogin extends AuthenticatingEvent{
  final String idUser;
  AuthOnInstantLogin(this.idUser);
}
class AuthOnRetry extends AuthenticatingEvent{}