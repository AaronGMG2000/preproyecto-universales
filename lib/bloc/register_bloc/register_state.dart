part of 'register_bloc.dart';

abstract class RegisterState {}

class AppStarted extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure({required this.error});
}

class ChangePassword extends RegisterState {}

class CreatePasswordSuccess extends RegisterState {}
