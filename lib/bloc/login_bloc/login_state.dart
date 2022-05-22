part of 'login_bloc.dart';

abstract class LoginState {}

class AppStarted extends LoginState {}

class LoginFail extends LoginState {
  final String error;
  LoginFail({required this.error});
}

class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess({required this.user});
}

class LoginLoading extends LoginState {}

class ChangePassword extends LoginState {}
