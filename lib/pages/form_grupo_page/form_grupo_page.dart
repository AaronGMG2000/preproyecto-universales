import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto/bloc/chanel_bloc/chanel_bloc.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/chanel_model.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/utils/app_firebase.dart';
import 'package:proyecto/utils/app_string.dart';
import 'package:proyecto/widget/widget_alert.dart';
import 'package:proyecto/widget/widget_button.dart';
import 'package:proyecto/widget/widget_input.dart';
import 'package:proyecto/widget/widget_list.dart';

class FormGrupoPage extends StatefulWidget {
  final User user;
  const FormGrupoPage({Key? key, required this.user}) : super(key: key);

  @override
  FormGrupoPageState createState() => FormGrupoPageState();
}

class FormGrupoPageState extends State<FormGrupoPage> {
  final _formKey = GlobalKey<FormState>();
  late AppLocalizations localizations = AppLocalizations.of(context);
  late Chanel canal = Chanel();
  late List<User> selectedUsers = [];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ChanelBloc(),
      child: BlocListener<ChanelBloc, ChanelState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case ChanelFail:
              Navigator.of(context).pop();
              final estado = state as ChanelFail;
              alertBottom(estado.error, Colors.orange, 1500, context);
              break;
            case ChanelLoading:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                ),
              );
              break;
            case ChanelSuccess:
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              break;
          }
        },
        child: BlocBuilder<ChanelBloc, ChanelState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _getInput(
                            localizations.dictionary(Strings.chanelName),
                            (value) {
                              canal.nombre = value;
                            },
                            (value) {
                              if (value.isEmpty) {
                                return localizations.dictionary(
                                    Strings.registerDisplayedNameError);
                              }
                              return null;
                            },
                            false,
                            () {},
                            Icons.abc,
                          ),
                          _getInput(
                            localizations.dictionary(Strings.chanelDescription),
                            (value) {
                              canal.descripcion = value;
                            },
                            (value) {
                              if (value.isEmpty) {
                                return localizations
                                    .dictionary(Strings.chanelDescriptionError);
                              }
                              return null;
                            },
                            false,
                            () {},
                            Icons.abc,
                          ),
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
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  BlocProvider.of<ChanelBloc>(context).add(
                                    ChanelStart(
                                      chanel: canal,
                                      user: widget.user,
                                      selectedUsers: selectedUsers,
                                      context: context,
                                    ),
                                  );
                                }
                              },
                              text: localizations
                                  .dictionary(Strings.chanelButtonText),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.39,
                    child: StreamBuilder(
                      stream: AppDataBase.shared.getUsers(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          DatabaseEvent data = snapshot.data as DatabaseEvent;
                          List<User> users =
                              getUsers(data.snapshot.value as Map);
                          users.removeWhere((user) {
                            return user.id == widget.user.id;
                          });
                          if (selectedUsers.isNotEmpty) {
                            users.removeWhere((user) {
                              return selectedUsers.any(
                                  (selectedUser) => selectedUser.id == user.id);
                            });
                          }
                          return UserList(
                            users: users,
                            addUser: (value) {
                              setState(() {
                                selectedUsers.add(value);
                              });
                            },
                          );
                        } else {
                          return Container();
                        }
                      }),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
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

Widget _getInput(hint, onSaved, validator, obscureText, iconAction, icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: InputIconText(
      hint: hint,
      onSaved: onSaved,
      obscureText: obscureText,
      icon: icon,
      onPressed: iconAction,
      validator: validator,
    ),
  );
}
