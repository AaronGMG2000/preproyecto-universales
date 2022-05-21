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
    on<RegisterStart>((event, emit) async {
      emit(RegisterLoading());
      late AppLocalizations localizations = AppLocalizations.of(event.context);
      final authService =
          Provider.of<AuthService>(event.context, listen: false);
      await authService
          .createUserWithEmailAndPassword(
              event.user.email, event.user.password, event.user.displayName)
          .then(
        (user) {
          emit(RegisterSuccess());
        },
      ).catchError((error) {
        String message = '';
        switch (error.code) {
          case 'email-already-exists':
            message = localizations.dictionary(Strings.loginEmailFail);
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
