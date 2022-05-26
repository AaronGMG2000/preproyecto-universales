part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {}

class ChatStart extends ChatEvent {
  final Message mensaje;
  final BuildContext context;
  final User user;
  final Chanel chanel;
  ChatStart({
    required this.mensaje,
    required this.context,
    required this.user,
    required this.chanel,
  });
  @override
  List<Object> get props => [mensaje, context, user, chanel];
}

class ChatDelete extends ChatEvent {
  final Message mensaje;
  final Chanel chanel;
  final BuildContext context;
  ChatDelete({
    required this.mensaje,
    required this.chanel,
    required this.context,
  });
  @override
  List<Object> get props => [mensaje, chanel, context];
}

class ChatEdit extends ChatEvent {
  final Message mensaje;
  final Chanel chanel;
  final BuildContext context;
  ChatEdit({
    required this.mensaje,
    required this.chanel,
    required this.context,
  });
  @override
  List<Object> get props => [mensaje, chanel, context];
}
