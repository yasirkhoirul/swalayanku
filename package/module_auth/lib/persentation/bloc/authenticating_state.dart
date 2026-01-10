part of 'authenticating_bloc.dart';

@immutable
sealed class AuthenticatingState {}

final class AuthenticatingInitial extends AuthenticatingState {}
final class AuthenticatingLoading extends AuthenticatingState {}
final class AuthenticatingSucces extends AuthenticatingState {}
final class AuthenticatingError extends AuthenticatingState {
  final String message;
  AuthenticatingError(this.message);
}
