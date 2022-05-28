import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/pages/profile_page/profile_page.dart';
import 'package:proyecto/pages/settings_page/settings_page.dart';
import 'package:proyecto/providers/auth_provider.dart';
import 'package:proyecto/utils/app_color.dart';
import 'package:proyecto/utils/app_firebase.dart';
import 'package:proyecto/utils/app_string.dart';

class NavigationDrawerPage extends StatelessWidget {
  final User user;
  const NavigationDrawerPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations(Localizations.localeOf(context));
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return Drawer(
      child: Container(
        color: isDark ? AppColor.shared.backgroundHomeDark : Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(
                context,
                urlImage: user.photoUrl,
                name: user.displayName,
                email: user.email,
                color: user.color,
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    children: [
                      const SizedBox(height: 48),
                      buildMenuItem(
                        context,
                        text: localizations.dictionary(Strings.profileText),
                        icon: Icons.person,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(user: user),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      buildMenuItem(
                        context,
                        text: localizations.dictionary(Strings.settingsText),
                        icon: Icons.settings,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  )),
              const Divider(
                color: Colors.white70,
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    children: [
                      buildMenuItem(
                        context,
                        text: localizations.dictionary(Strings.signOutText),
                        icon: Icons.logout,
                        onTap: () async {
                          final authService =
                              Provider.of<AuthService>(context, listen: false);
                          await AppDataBase.shared.setOnline(user, false);
                          authService.signOut();
                        },
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildHeader(
  context, {
  required String urlImage,
  required String name,
  required String email,
  required Color color,
}) {
  final isDark = Theme.of(context).primaryColor == Colors.white;
  return Material(
    elevation: 2,
    child: Container(
      color: isDark
          ? AppColor.shared.backgroundAppBarDark
          : AppColor.shared.backgroundAppBar,
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 10),
      child: Row(
        children: [
          urlImage.isEmpty
              ? Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    name.characters.first,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(urlImage),
                ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 175,
                child: AutoSizeText(
                  name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 3,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 175,
                child: AutoSizeText(
                  email,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildMenuItem(
  context, {
  required String text,
  required IconData icon,
  required Function()? onTap,
}) {
  final isDark = Theme.of(context).primaryColor == Colors.white;
  final color = isDark ? Colors.white : Colors.black;
  final colorIcon = isDark ? Colors.white54 : Colors.black54;
  const hoverColor = Colors.white70;
  return Padding(
    padding: const EdgeInsets.only(left: 20),
    child: ListTile(
      leading: Icon(
        icon,
        color: colorIcon,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
      hoverColor: hoverColor,
      onTap: onTap,
    ),
  );
}
