part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {}

class ProfileChangeUser extends ProfileEvent {
  final User user;
  final BuildContext context;
  ProfileChangeUser({required this.user, required this.context});
  @override
  List<Object> get props => [user, context];
}

class ChangePassword extends ProfileEvent {
  final String password;
  final BuildContext context;
  ChangePassword({
    required this.context,
    required this.password,
  });
  @override
  List<Object> get props => [context, password];
}
