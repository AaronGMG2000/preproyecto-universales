part of 'chanel_bloc.dart';

abstract class ChanelEvent extends Equatable {}

class ChanelStart extends ChanelEvent {
  final Chanel chanel;
  final User user;
  final List<User> selectedUsers;
  final BuildContext context;
  ChanelStart({
    required this.chanel,
    required this.user,
    required this.selectedUsers,
    required this.context,
  });
  @override
  List<Object> get props => [chanel, user, selectedUsers, context];
}
