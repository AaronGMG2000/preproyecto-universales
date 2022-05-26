part of 'chat_bloc.dart';

abstract class ChatState {}

class AppStarted extends ChatState {}

class ChatFail extends ChatState {
  final String error;
  ChatFail({required this.error});
}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {}

class ChatDeleteSuccess extends ChatState {}
