import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/login_model.dart';
import 'package:proyecto/providers/auth_provider.dart';
import 'package:proyecto/utils/app_encrypt.dart';
import 'package:proyecto/utils/app_preferences.dart';
import 'package:proyecto/utils/app_string.dart';
import 'package:proyecto/widget/widget_alert.dart';
import 'package:local_auth_android/local_auth_android.dart';

Future<void> biometrico(context) async {
  final LocalAuthentication auth = LocalAuthentication();
  AppLocalizations localizations =
      AppLocalizations(Localizations.localeOf(context));

  bool? remember = false;
  try {
    remember = await AppPreferences.shared.getBoolPreference("rememberMe");
  } catch (e) {
    remember = false;
  }

  if (remember != null) {
    String? location =
        await AppPreferences.shared.getStringPreference('defaultLanguage');
    final locatizations = AppLocalizations(Locale(location ?? 'es', ''));
    bool authenticated = false;
    final androidString = AndroidAuthMessages(
      signInTitle: locatizations.dictionary(Strings.signInTitleString),
      cancelButton: locatizations.dictionary(Strings.cancelButtonString),
      goToSettingsButton:
          locatizations.dictionary(Strings.goToSettingsButtonString),
      biometricHint: locatizations.dictionary(Strings.biometricHintString),
      biometricNotRecognized:
          locatizations.dictionary(Strings.biometricNotRecognizedString),
      biometricSuccess:
          locatizations.dictionary(Strings.biometricSuccessString),
      goToSettingsDescription:
          locatizations.dictionary(Strings.goToSettingsDescriptionString),
    );
    try {
      authenticated = await auth.authenticate(
        localizedReason:
            locatizations.dictionary(Strings.localizedReasonString),
        authMessages: [androidString],
        options: const AuthenticationOptions(
          useErrorDialogs: false,
          stickyAuth: false,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        late String? email = "";
        email = await AppPreferences.shared.getStringPreference("email");
        late String? password = "";
        password = await AppPreferences.shared.getStringPreference("password");
        email = await deencryptText(email!);
        password = await deencryptText(password!);
        Login login = Login();
        login.email = email;
        login.password = password;

        final authService = Provider.of<AuthService>(context, listen: false);
        await authService
            .signInWithEmailAndPassword(
          login.email,
          login.password,
        )
            .catchError(
          (error) {
            alertBottom(localizations.dictionary(Strings.failError), Colors.red,
                1500, context);
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error de Autenticación")),
        );
      }
    } on PlatformException catch (e) {
      late String message = '';
      switch (e.code.toString()) {
        case 'LockedOut':
          message = localizations.dictionary(Strings.lockedOutString);
          break;
        case 'NotAvailable':
          message = localizations.dictionary(Strings.notAvailableString);
          break;
        case 'NotEnrolled':
          message = localizations.dictionary(Strings.notEnrolledString);
          break;
        case 'OtherOperatingSystem':
          message =
              localizations.dictionary(Strings.otherOperatingSystemString);
          break;
        case 'PasscodeNotSet':
          message = localizations.dictionary(Strings.passcodeNotSetString);
          break;
        case 'PermanentlyLockedOut':
          message =
              localizations.dictionary(Strings.permanentlyLockedOutString);
          break;
        default:
          message = localizations.dictionary(Strings.failError);
          break;
      }
      alertBottom(message, Colors.red, 1500, context);
    } catch (e) {
      //
    }
  } else {
    alertBottom(localizations.dictionary(Strings.noRememberMe), Colors.red,
        1500, context);
  }
}
