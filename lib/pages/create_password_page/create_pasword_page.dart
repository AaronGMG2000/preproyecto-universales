import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/providers/language_provider.dart';
import 'package:proyecto/providers/theme_provider.dart';
import 'package:proyecto/utils/app_color.dart';
import 'package:proyecto/utils/app_preferences.dart';
import 'package:proyecto/utils/app_string.dart';
import 'package:proyecto/widget/widget_alert.dart';
import 'package:proyecto/widget/widget_dropdown.dart';

import '../../bloc/register_bloc/register_bloc.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({
    Key? key,
  }) : super(key: key);

  @override
  CreatePasswordPageState createState() => CreatePasswordPageState();
}

class CreatePasswordPageState extends State<CreatePasswordPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locatizations = AppLocalizations(Localizations.localeOf(context));
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark
            ? AppColor.shared.backgroundHeaderSettingsDark
            : AppColor.shared.backgroundHeaderSettings,
      ),
      backgroundColor: isDark
          ? AppColor.shared.backgroundHeaderSettingsDark
          : AppColor.shared.backgroundHeaderSettings,
      body: BlocProvider(
        create: (BuildContext context) => RegisterBloc(),
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            switch (state.runtimeType) {
              case CreatePasswordSuccess:
                Navigator.of(context).pop();
                break;
              case RegisterFailure:
                Navigator.of(context).pop();
                final estado = state as RegisterFailure;
                alertBottom(estado.error, Colors.orange, 1500, context);
                break;
              case RegisterLoading:
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                );
                break;
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 40, left: 50),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          locatizations
                              .dictionary(Strings.singUpNewPasswordTitle),
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontFamily: "SegoeUI",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 50),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          locatizations
                              .dictionary(Strings.singUpNewPasswordSubtitle),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: "SegoeUI",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 200),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColor.shared.backgroundSettinsDark
                          : AppColor.shared.backgroundSettins,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                top: 50,
                                left: 30,
                              ),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Lenguaje",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "SegoeUI",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Dropdownbutton1(
                                initialValue: locatizations
                                    .dictionary(Strings.settingsSystem),
                                getValue: () async {
                                  int? number = await AppPreferences.shared
                                      .getIntPreference("defaultLanguage");
                                  switch (number) {
                                    case 2:
                                      return "es";
                                    case 1:
                                      return "en";
                                    default:
                                      return "Sistema";
                                  }
                                },
                                items: const ["Sistema", "es", "en"],
                                onChanged: (value) async {
                                  LanguageProvider languageProvider =
                                      Provider.of<LanguageProvider>(context,
                                          listen: false);
                                  switch (value) {
                                    case "es":
                                      languageProvider.setLanguage = 2;
                                      break;
                                    case "en":
                                      languageProvider.setLanguage = 1;
                                      break;
                                    default:
                                      languageProvider.setLanguage = 0;
                                      break;
                                  }
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 50,
                                left: 30,
                              ),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Tema",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "SegoeUI",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Dropdownbutton1(
                                initialValue: locatizations
                                    .dictionary(Strings.settingsSystem),
                                getValue: () async {
                                  int? value = await AppPreferences.shared
                                      .getIntPreference("defaultTheme");
                                  switch (value) {
                                    case 2:
                                      return "Dark";
                                    case 1:
                                      return "Light";
                                    default:
                                      return "Sistema";
                                  }
                                },
                                items: const ["Sistema", "Dark", "Light"],
                                onChanged: (value) async {
                                  ThemeProvider themeProvider =
                                      Provider.of<ThemeProvider>(context,
                                          listen: false);
                                  switch (value) {
                                    case "Dark":
                                      themeProvider.setTheme = 2;
                                      break;
                                    case "Light":
                                      themeProvider.setTheme = 1;
                                      break;
                                    default:
                                      themeProvider.setTheme = 0;
                                      break;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
