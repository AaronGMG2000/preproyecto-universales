import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/providers/auth_provider.dart';
import 'package:proyecto/utils/app_encrypt.dart';
import 'package:proyecto/utils/app_firebase.dart';
import 'package:proyecto/utils/app_preferences.dart';
import 'package:proyecto/utils/app_string.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(AppStarted()) {
    on<ChangePassword>((event, emit) async {
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      final authService =
          Provider.of<AuthService>(event.context, listen: false);
      emit(ProfileLoading());
      AppPreferences.shared
          .setPreference("password", await encryptText(event.password));
      await authService.changePassword(event.password).then((value) {
        emit(ProfileSuccess());
      }).catchError((error) {
        emit(
            ProfileFailure(error: localizations.dictionary(Strings.failError)));
      });
    });

    on<ProfileChangeUser>((event, emit) async {
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      final authService =
          Provider.of<AuthService>(event.context, listen: false);
      emit(ProfileLoading());
      await authService.changeUser(event.user.displayName).then((value) async {
        await AppDataBase.shared
            .updateUserName(event.user.id, event.user.displayName);
        emit(ProfileSuccess());
      }).catchError((error) {
        emit(
            ProfileFailure(error: localizations.dictionary(Strings.failError)));
      });
    });
  }
}
