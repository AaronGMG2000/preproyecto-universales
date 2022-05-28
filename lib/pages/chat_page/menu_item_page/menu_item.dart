import 'package:flutter/material.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/chanel_model.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/pages/chat_page/add_administrator_page/add_administrator_page.dart';
import 'package:proyecto/pages/chat_page/add_users_page/add_user_page.dart';
import 'package:proyecto/pages/chat_page/delete_administrator_page/delete_administrator_page.dart';
import 'package:proyecto/pages/chat_page/delete_users_page/delete_users_page.dart';
import 'package:proyecto/pages/chat_page/view_administrators_page/view_administrators_page.dart';
import 'package:proyecto/pages/chat_page/view_users_page/view_users_page.dart';
import 'package:proyecto/utils/app_string.dart';
import 'package:proyecto/widget/widget_modal.dart';

class MenuButton extends StatelessWidget {
  final Chanel chanel;
  final User user;
  const MenuButton({
    Key? key,
    required this.chanel,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    final localizations = AppLocalizations(Localizations.localeOf(context));

    List<MenuItem> items = [
      MenuItem(localizations.dictionary(Strings.addAdministrators),
          Icons.add_moderator_sharp, () {
        showModal(context, localizations.dictionary(Strings.addAdministrators),
            AddAdministratorPage(chanel: chanel, user: user));
      }),
      MenuItem(localizations.dictionary(Strings.addUsers), Icons.add, () {
        showModal(context, localizations.dictionary(Strings.addUsers),
            AddUserPage(chanel: chanel, user: user));
      }),
      MenuItem(localizations.dictionary(Strings.users), Icons.people, () {
        showModal(context, localizations.dictionary(Strings.users),
            ViewUserPage(chanel: chanel, user: user));
      }),
      MenuItem(localizations.dictionary(Strings.administrators), Icons.security,
          () {
        showModal(context, localizations.dictionary(Strings.administrators),
            ViewAdministratorPage(chanel: chanel, user: user));
      }),
      MenuItem(localizations.dictionary(Strings.deleteUsers), Icons.delete, () {
        showModal(context, localizations.dictionary(Strings.deleteUsers),
            DeleteUserPage(chanel: chanel, user: user));
      }),
      MenuItem(localizations.dictionary(Strings.deleteAdministrators),
          Icons.remove_moderator, () {
        showModal(
            context,
            localizations.dictionary(Strings.deleteAdministrators),
            DeleteAdministratorPage(chanel: chanel, user: user));
      }),
    ];

    List<MenuItem> items2 = [
      MenuItem(localizations.dictionary(Strings.users), Icons.people, () {
        showModal(context, localizations.dictionary(Strings.users),
            ViewUserPage(chanel: chanel, user: user));
      }),
      MenuItem(localizations.dictionary(Strings.administrators), Icons.security,
          () {
        showModal(context, localizations.dictionary(Strings.administrators),
            ViewAdministratorPage(chanel: chanel, user: user));
      }),
    ];
    List<MenuItem> itemData =
        chanel.id == 'General' || chanel.administradores[user.id] == null
            ? items2
            : items;
    return PopupMenuButton<MenuItem>(
      color: isDark ? const Color(0xFF282828) : Colors.white,
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        ...itemData.map((item) => PopupMenuItem(
              value: item,
              child: TextButton(
                onPressed: item.onTap,
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.text,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  MenuItem(
    this.text,
    this.icon,
    this.onTap,
  );
}

void showModal(BuildContext context, String title, Widget content) =>
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (ctx) => ModalBottom(title: title, content: content),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
User getUser(Chanel chanel, String id) {
  return chanel.usuarios[id]!;
}
