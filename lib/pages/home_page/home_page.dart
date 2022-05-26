import 'package:flutter/material.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/chanel_model.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/pages/chat_page/chat_page.dart';
import 'package:proyecto/pages/form_grupo_page/form_grupo_page.dart';
import 'package:proyecto/pages/navigation_drawer_page/navigation_drawer_page.dart';
import 'package:proyecto/pages/splash_page/splash_page.dart';
import 'package:proyecto/utils/app_chanel_stream.dart';
import 'package:proyecto/utils/app_color.dart';
import 'package:proyecto/utils/app_string.dart';
import 'package:proyecto/widget/widget_modal.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        AppLocalizations(Localizations.localeOf(context));
    AppChanelStream chanelStream = AppChanelStream(widget.user.id);
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return StreamBuilder(
      stream: chanelStream.getChanels,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Chanel> chanels = snapshot.data as List<Chanel>;
          return Scaffold(
            drawer: NavigationDrawerPage(
              user: widget.user,
            ),
            backgroundColor: isDark
                ? AppColor.shared.backgroundHomeDark
                : AppColor.shared.backgroundHome,
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showModal(
                        context,
                        localizations.dictionary(Strings.chanelTitle),
                        FormGrupoPage(
                          user: widget.user,
                        ));
                  },
                ),
              ],
              backgroundColor: isDark
                  ? AppColor.shared.backgroundAppBarDark
                  : AppColor.shared.backgroundAppBar,
              title: const Text('UniChat'),
            ),
            body: ListView.builder(
              itemCount: chanels.length,
              itemBuilder: (context, index) {
                User userMessage =
                    getUser(chanels[index], chanels[index].mensajes[0].usuario);
                return ListTile(
                  title: Text(
                    chanels[index].nombre,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    chanels[index].mensajes.isEmpty
                        ? ''
                        : '${userMessage.displayName}: ${chanels[index].mensajes[0].texto}',
                    maxLines: 1,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: chanels[index].color,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      chanels[index].nombre.characters.first,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                                chanel: chanels[index],
                                user: widget.user,
                              )),
                    );
                  },
                );
              },
            ),
          );
        } else {
          return const SplashPage();
        }
      },
    );
  }

  User getUser(Chanel chanel, String id) {
    return chanel.usuarios[id]!;
  }

  void showModal(BuildContext context, String title, Widget content) =>
      showModalBottomSheet(
        context: context,
        enableDrag: false,
        builder: (ctx) => ModalBottom(title: title, content: content),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
}
