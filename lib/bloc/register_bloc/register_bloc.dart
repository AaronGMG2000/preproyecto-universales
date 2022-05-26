import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/login_model.dart';
import 'package:proyecto/providers/auth_provider.dart';
import 'package:proyecto/utils/app_string.dart';
part 'register_state.dart';
part 'register_event.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(AppStarted()) {
    on<RegisterFacebookStart>((event, emit) async {
      emit(RegisterLoading());
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      final authService =
          Provider.of<AuthService>(event.context, listen: false);
      await authService
          .signInWithFacebook()
          .then((user) => emit(RegisterSuccess()))
          .catchError(
        (error) {
          emit(RegisterFailure(
              error: localizations.dictionary(Strings.cancelOperation)));
        },
      );
    });

    on<RegisterGoogleStart>((event, emit) async {
      emit(RegisterLoading());
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      final authService =
          Provider.of<AuthService>(event.context, listen: false);
      await authService
          .sigInWithGoogle()
          .then((user) => emit(RegisterSuccess()))
          .catchError(
        (error) {
          emit(RegisterFailure(
              error: localizations.dictionary(Strings.cancelOperation)));
        },
      );
    });

    on<RegisterTwitterStart>((event, emit) async {
      emit(RegisterLoading());
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      final authService =
          Provider.of<AuthService>(event.context, listen: false);
      await authService
          .signInWithTwitter()
          .then((user) => emit(RegisterSuccess()))
          .catchError(
        (error) {
          emit(RegisterFailure(
              error: localizations.dictionary(Strings.cancelOperation)));
        },
      );
    });

    on<CreatePassword>((event, emit) async {
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      final authService =
          Provider.of<AuthService>(event.context, listen: false);
      emit(RegisterLoading());
      await authService.changePassword(event.user.password).then((value) {
        emit(CreatePasswordSuccess());
      }).catchError((error) {
        emit(RegisterFailure(
            error: localizations.dictionary(Strings.failError)));
      });
    });
    on<RegisterStart>((event, emit) async {
      emit(RegisterLoading());
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      final authService =
          Provider.of<AuthService>(event.context, listen: false);
      await authService
          .createUserWithEmailAndPassword(
              event.user.email, event.user.password, event.user.displayName, "")
          .then(
        (user) {
          emit(RegisterSuccess());
        },
      ).catchError((error) {
        String message = '';
        switch (error.code) {
          case 'email-already-exists':
            message = localizations.dictionary(Strings.singUpEmailRepeatFail);
            break;
          default:
            message = localizations.dictionary(Strings.failError);
            break;
        }
        emit(RegisterFailure(error: message));
      });
    });
  }
}
