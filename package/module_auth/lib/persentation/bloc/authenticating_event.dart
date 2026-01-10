part of 'authenticating_bloc.dart';

@immutable
sealed class AuthenticatingEvent {}


class AuthOnSubmit extends AuthenticatingEvent{
  final User user;
  AuthOnSubmit(this.user);
}

class AuthOnLogout extends AuthenticatingEvent{}
class AuthOnInstantLogin extends AuthenticatingEvent{}
class AuthOnRetry extends AuthenticatingEvent{}