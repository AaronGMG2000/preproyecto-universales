import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/chanel_model.dart';
import 'package:proyecto/model/message_model.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/pages/chat_page/chat_page.dart';
import 'package:proyecto/utils/app_firebase.dart';
import 'package:proyecto/utils/app_string.dart';

part 'chat_state.dart';
part 'chat_event.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(AppStarted()) {
    on<ChatStart>((event, emit) async {
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      emit(ChatLoading());
      try {
        await AppDataBase.shared.newMessage(
            event.chanel.id, event.mensaje.texto, event.user.id, "texto");
        emit(ChatSuccess());
      } catch (e) {
        emit(ChatFail(error: localizations.dictionary(Strings.failError)));
      }
    });

    on<ChatDelete>((event, emit) async {
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      emit(ChatLoading());
      try {
        await AppDataBase.shared
            .deleteMessage(event.chanel.id, event.mensaje.id);
        emit(ChatDeleteSuccess());
      } catch (e) {
        emit(ChatFail(error: localizations.dictionary(Strings.failError)));
      }
    });

    on<ChatEdit>((event, emit) async {
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      emit(ChatLoading());
      try {
        await AppDataBase.shared.updateMessage(
            event.chanel.id, event.mensaje.id, event.mensaje.texto);
        emit(ChatSuccess());
      } catch (e) {
        emit(ChatFail(error: localizations.dictionary(Strings.failError)));
      }
    });
  }
}
