import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/providers/language_provider.dart';
import 'package:proyecto/providers/theme_provider.dart';
import 'package:proyecto/utils/app_color.dart';
import 'package:proyecto/utils/app_preferences.dart';
import 'package:proyecto/utils/app_string.dart';
import 'package:proyecto/widget/widget_dropdown.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
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
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40, left: 50),
                alignment: Alignment.centerLeft,
                child: Text(
                  locatizations.dictionary(Strings.settingsText),
                  style: const TextStyle(
                    fontSize: 26,
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
                      child: Text(
                        locatizations.dictionary(Strings.settingsLanguaje),
                        style: const TextStyle(
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
                        initialValue:
                            locatizations.dictionary(Strings.settingsSystem),
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
                      child: Text(
                        locatizations.dictionary(Strings.settingsTheme),
                        style: const TextStyle(
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
                        initialValue:
                            locatizations.dictionary(Strings.settingsSystem),
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
      ),
    );
  }
}
