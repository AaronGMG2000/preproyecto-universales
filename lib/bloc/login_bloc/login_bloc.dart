import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/login_model.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/providers/auth_provider.dart';
import 'package:proyecto/utils/app_encrypt.dart';
import 'package:proyecto/utils/app_preferences.dart';
import 'package:proyecto/utils/app_string.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(AppStarted()) {
    on<LoginFacebookStart>((event, emit) async {
      emit(LoginLoading());
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      final authService =
          Provider.of<AuthService>(event.context, listen: false);
      await authService
          .signInWithFacebook()
          .then((user) => emit(LoginSuccess(user: user!)))
          .catchError(
        (error) {
          emit(LoginFail(
              error: localizations.dictionary(Strings.cancelOperation)));
        },
      );
    });

    on<LoginGoogleStart>((event, emit) async {
      emit(LoginLoading());
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      final authService =
          Provider.of<AuthService>(event.context, listen: false);
      await authService
          .sigInWithGoogle()
          .then((user) => emit(LoginSuccess(user: user!)))
          .catchError(
        (error) {
          emit(LoginFail(
              error: localizations.dictionary(Strings.cancelOperation)));
        },
      );
    });

    on<LoginTwitterStart>((event, emit) async {
      emit(LoginLoading());
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      final authService =
          Provider.of<AuthService>(event.context, listen: false);
      await authService
          .signInWithTwitter()
          .then((user) => emit(LoginSuccess(user: user!)))
          .catchError(
        (error) {
          emit(LoginFail(
              error: localizations.dictionary(Strings.cancelOperation)));
        },
      );
    });

    on<LoginStart>((event, emit) async {
      emit(LoginLoading());
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      final authService =
          Provider.of<AuthService>(event.context, listen: false);
      Login login = event.login;
      if (login.rememberMe) {
        AppPreferences.shared
            .setPreference("email", await encryptText(login.email));
        AppPreferences.shared
            .setPreference("password", await encryptText(login.password));
        AppPreferences.shared.setPreference("rememberMe", true);
      } else {
        AppPreferences.shared.setPreference("rememberMe", false);
      }
      await authService
          .signInWithEmailAndPassword(
            event.login.email,
            event.login.password,
          )
          .then((user) => emit(LoginSuccess(user: user!)))
          .catchError(
        (error) {
          String message = '';
          switch (error.code) {
            case 'user-not-found':
              message = localizations.dictionary(Strings.loginEmailFail);
              break;
            case 'wrong-password':
              message = localizations.dictionary(Strings.loginPasswordFail);
              break;
            default:
              message = localizations.dictionary(Strings.failError);
              break;
          }
          emit(LoginFail(error: message));
        },
      );
    });
  }
}
