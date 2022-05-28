import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto/bloc/chat_bloc/chat_bloc.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/chanel_model.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/utils/app_firebase.dart';
import 'package:proyecto/widget/widget_alert.dart';
import 'package:proyecto/widget/widget_list.dart';

class ViewUserPage extends StatefulWidget {
  final User user;
  final Chanel chanel;
  const ViewUserPage({
    Key? key,
    required this.user,
    required this.chanel,
  }) : super(key: key);

  @override
  ViewUserPageState createState() => ViewUserPageState();
}

class ViewUserPageState extends State<ViewUserPage> {
  late AppLocalizations localizations = AppLocalizations.of(context);
  late List<User> selectedUsers = [];
  late List<User> users = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getChanel(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Chanel chanel = snapshot.data as Chanel;
          users = chanel.usuarios.values.toList();
          return Padding(
            padding: const EdgeInsets.only(top: 15),
            child: BlocProvider(
              create: (BuildContext context) => ChatBloc(),
              child: BlocListener<ChatBloc, ChatState>(
                listener: (context, state) {
                  switch (state.runtimeType) {
                    case ChatFail:
                      Navigator.of(context).pop();
                      final estado = state as ChatFail;
                      alertBottom(estado.error, Colors.orange, 1500, context);
                      break;
                    case ChatLoading:
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      );
                      break;
                    case ChatSuccess:
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      break;
                  }
                },
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: UserListOnly(
                              users: users,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<Chanel> getChanel() async {
    DatabaseEvent data = await AppDataBase.shared.getChanel(widget.chanel.id);
    Map map = data.snapshot.value as Map;
    String key = data.snapshot.key!;
    Chanel chanel = await Chanel.fromMap(key, map);
    widget.chanel.administradores = chanel.administradores;
    widget.chanel.usuarios = chanel.usuarios;
    return chanel;
  }
}
