import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/pages/main_page.dart/main_page.dart';
import 'package:proyecto/pages/splash_page/splash_page.dart';
import 'package:proyecto/providers/auth_provider.dart';
import 'package:proyecto/providers/language_provider.dart';
import 'package:proyecto/providers/theme_provider.dart';
import 'package:proyecto/utils/app_preferences.dart';
import 'package:proyecto/utils/app_theme.dart';

void main() {
  runZonedGuarded(
    () => runApp(const MyApp()),
    (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final LocalAuthentication auth = LocalAuthentication();
  late Future<void> _fireBase;
  Future<void> _initializeF() async {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    await Firebase.initializeApp();
    await _initializeC();
    await getCurrentAppLanguage();
    await getCurrentAppTheme();
  }

  Future<void> _initializeC() async {
    // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    Function onOriginError = FlutterError.onError as Function;
    FlutterError.onError = (FlutterErrorDetails details) async {
      await FirebaseCrashlytics.instance.recordFlutterError(details);
      onOriginError(details);
    };
  }

  Future<void> getCurrentAppLanguage() async {
    LanguageProvider().setLanguage =
        await AppPreferences.shared.getIntPreference('defaultLanguage');
  }

  Future<void> getCurrentAppTheme() async {
    ThemeProvider().setTheme = await ThemeProvider().getDefaultLanguage();
  }

  @override
  void initState() {
    super.initState();
    _fireBase = _initializeF();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fireBase,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
              ChangeNotifierProvider(create: (_) => LanguageProvider()),
              Provider<AuthService>(create: (_) => AuthService()),
            ],
            child: Consumer3(builder: (
              context,
              ThemeProvider themeProvider,
              LanguageProvider languageProvider,
              AuthService authService,
              widget,
            ) {
              return MaterialApp(
                locale: languageProvider.getLang,
                localizationsDelegates: const [
                  AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale("es", ""),
                  Locale("en", ""),
                ],
                debugShowCheckedModeBanner: false,
                theme:
                    AppTheme.themeData(themeProvider.getTheme, false, context),
                darkTheme:
                    AppTheme.themeData(themeProvider.getTheme, true, context),
                title: '',
                home: const MainPage(),
              );
            }),
          );
        } else {
          return const SplashPage();
        }
      },
    );
  }
}
