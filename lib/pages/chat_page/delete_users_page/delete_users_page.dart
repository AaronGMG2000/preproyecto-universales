import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto/bloc/chat_bloc/chat_bloc.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/chanel_model.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/utils/app_firebase.dart';
import 'package:proyecto/utils/app_string.dart';
import 'package:proyecto/widget/widget_alert.dart';
import 'package:proyecto/widget/widget_button.dart';
import 'package:proyecto/widget/widget_list.dart';

class DeleteUserPage extends StatefulWidget {
  final User user;
  final Chanel chanel;
  const DeleteUserPage({
    Key? key,
    required this.user,
    required this.chanel,
  }) : super(key: key);

  @override
  DeleteUserPageState createState() => DeleteUserPageState();
}

class DeleteUserPageState extends State<DeleteUserPage> {
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
          users.removeWhere((user) {
            return selectedUsers
                .any((selectedUser) => selectedUser.id == user.id);
          });
          users.removeWhere((user) {
            return user.id == chanel.creador.id;
          });
          users.removeWhere((user) {
            return user.id == widget.user.id;
          });
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
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 60,
                                  child: getSelectedUsers(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 10),
                                  child: ButtonTextGradient(
                                    height: 60,
                                    size: 24,
                                    onPressed: () {
                                      BlocProvider.of<ChatBloc>(context).add(
                                        ChatDeleteUser(
                                          chanel: chanel,
                                          user: widget.user,
                                          selectedUsers: selectedUsers,
                                          context: context,
                                        ),
                                      );
                                    },
                                    text: localizations
                                        .dictionary(Strings.deleteUsersText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.59,
                            child: UserList(
                              users: users,
                              addUser: (value) {
                                setState(() {
                                  selectedUsers.add(value);
                                });
                              },
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

  Widget getSelectedUsers() {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: selectedUsers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: SizedBox(
            width: 100,
            height: 20,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    selectedUsers[index].photoUrl.isEmpty
                        ? Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectedUsers[index].color,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              selectedUsers[index].displayName.characters.first,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    NetworkImage(selectedUsers[index].photoUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      selectedUsers[index].displayName,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 20,
                  top: 0,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedUsers.removeAt(index);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? Colors.orange : Colors.deepPurple,
                      ),
                      height: 20,
                      width: 20,
                      child: const Text(
                        "x",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

List<User> getUsers(Map data) {
  List<User> users = [];
  data.forEach((key, value) {
    User newUser = User();
    newUser.fromMap(key, value);
    users.add(newUser);
  });
  return users;
}
