part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {}

class RegisterStart extends RegisterEvent {
  final Login user;
  final BuildContext context;
  RegisterStart({required this.user, required this.context});
  @override
  List<Object?> get props => [user, context];
}
