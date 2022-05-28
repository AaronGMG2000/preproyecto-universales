import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/chanel_model.dart';
import 'package:proyecto/model/message_model.dart';
import 'package:proyecto/model/user_model.dart';
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

    on<ChatAddAdmin>((event, emit) async {
      emit(ChatLoading());
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      try {
        for (User userData in event.selectedUsers) {
          await AppDataBase.shared
              .addAdministratorToChanel(event.chanel.id, userData.id);
          await AppDataBase.shared.newMessage(
            event.chanel.id,
            "${userData.displayName} ahora es un administrador",
            userData.id,
            "notification",
          );
        }
        emit(ChatSuccess());
      } catch (e) {
        emit(ChatFail(error: localizations.dictionary(Strings.failError)));
      }
    });

    on<ChatDeleteAdmin>((event, emit) async {
      emit(ChatLoading());
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      try {
        for (User userData in event.selectedUsers) {
          await AppDataBase.shared
              .deleteAdministratorInChanel(event.chanel.id, userData.id);
          await AppDataBase.shared.newMessage(
            event.chanel.id,
            "${userData.displayName} ya no es un administrador",
            userData.id,
            "notification",
          );
        }
        emit(ChatSuccess());
      } catch (e) {
        emit(ChatFail(error: localizations.dictionary(Strings.failError)));
      }
    });

    on<ChatDeleteUser>((event, emit) async {
      emit(ChatLoading());
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      try {
        for (User userData in event.selectedUsers) {
          await AppDataBase.shared
              .deleteUserInChanel(event.chanel.id, userData.id);
          await AppDataBase.shared.newMessage(
            event.chanel.id,
            "${event.user.displayName} elimino a ${userData.displayName} del grupo",
            userData.id,
            "notification",
          );
        }
        emit(ChatSuccess());
      } catch (e) {
        emit(ChatFail(error: localizations.dictionary(Strings.failError)));
      }
    });

    on<ChatAddUser>((event, emit) async {
      emit(ChatLoading());
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      try {
        for (User userData in event.selectedUsers) {
          await AppDataBase.shared
              .addUserToChanel(event.chanel.id, event.chanel.id, userData);
          await AppDataBase.shared.newMessage(
            event.chanel.id,
            "${event.user.displayName} agrego a ${userData.displayName} al grupo",
            userData.id,
            "notification",
          );
        }

        emit(ChatSuccess());
      } catch (e) {
        emit(ChatFail(error: localizations.dictionary(Strings.failError)));
      }
    });
  }
}
