import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/chanel_model.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/utils/app_firebase.dart';
import 'package:proyecto/utils/app_string.dart';
import 'package:uuid/uuid.dart';
part 'chanel_event.dart';
part 'chanel_state.dart';

class ChanelBloc extends Bloc<ChanelEvent, ChanelState> {
  ChanelBloc() : super(AppStarted()) {
    on<ChanelStart>((event, emit) async {
      emit(ChanelLoading());
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      Uuid uuid = const Uuid();
      final id = uuid.v4();

      try {
        bool create = await AppDataBase.shared.newChanel(
            id, event.chanel.nombre, event.chanel.descripcion, event.user);
        if (create) {
          await AppDataBase.shared.addUserToChanel(id, id, event.user);
          for (User userData in event.selectedUsers) {
            await AppDataBase.shared.addUserToChanel(id, id, userData);
            await AppDataBase.shared.newMessage(
              id,
              "${userData.displayName} se unio al grupo",
              userData.id,
              "notification",
            );
          }
          await AppDataBase.shared.newMessage(
            id,
            "grupo creado el ${DateTime.now().toIso8601String().split("T")[0]}",
            event.user.id,
            "notification",
          );
          emit(ChanelSuccess());
        } else {
          emit(ChanelFail(error: localizations.dictionary(Strings.chanelFail)));
        }
      } catch (e) {
        emit(ChanelFail(error: localizations.dictionary(Strings.failError)));
      }
    });
  }
}
