part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {}

class RegisterStart extends RegisterEvent {
  final Login user;
  final BuildContext context;
  RegisterStart({required this.user, required this.context});
  @override
  List<Object?> get props => [user, context];
}

class CreatePassword extends RegisterEvent {
  final Login user;
  final BuildContext context;
  CreatePassword({required this.user, required this.context});
  @override
  List<Object?> get props => [user, context];
}

class RegisterFacebookStart extends RegisterEvent {
  final BuildContext context;
  RegisterFacebookStart({
    required this.context,
  });
  @override
  List<Object> get props => [context];
}

class RegisterGoogleStart extends RegisterEvent {
  final BuildContext context;
  RegisterGoogleStart({
    required this.context,
  });
  @override
  List<Object> get props => [context];
}

class RegisterTwitterStart extends RegisterEvent {
  final BuildContext context;
  RegisterTwitterStart({
    required this.context,
  });
  @override
  List<Object> get props => [context];
}
