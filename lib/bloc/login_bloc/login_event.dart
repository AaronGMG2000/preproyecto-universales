part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {}

class LoginStart extends LoginEvent {
  final Login login;
  final bool rememberMe;
  final BuildContext context;
  LoginStart({
    required this.login,
    required this.rememberMe,
    required this.context,
  });
  @override
  List<Object> get props => [login, rememberMe, context];
}
