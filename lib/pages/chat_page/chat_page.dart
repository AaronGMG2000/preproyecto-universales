import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:proyecto/bloc/chat_bloc/chat_bloc.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/chanel_model.dart';
import 'package:proyecto/model/message_model.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/pages/chat_page/edit_chat_page/edit_chat_page.dart';
import 'package:proyecto/pages/chat_page/menu_item_page/menu_item.dart';
import 'package:proyecto/utils/app_color.dart';
import 'package:proyecto/utils/app_firebase.dart';
import 'package:proyecto/utils/app_string.dart';
import 'package:proyecto/widget/widget_alert.dart';
import 'package:proyecto/widget/widget_input.dart';
import 'package:proyecto/widget/widget_modal.dart';

class ChatPage extends StatefulWidget {
  final Chanel chanel;
  final User user;
  const ChatPage({Key? key, required this.chanel, required this.user})
      : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late Message message = Message();
  late AppLocalizations localizations = AppLocalizations.of(context);
  final _formKey = GlobalKey<FormState>();
  final textControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return FutureBuilder(
      future: getChanel(),
      builder: (context, snapshot) {
        late Chanel chanel = Chanel();
        late List<Message> messages = [];
        if (snapshot.hasData) {
          chanel = snapshot.data as Chanel;
          messages = chanel.mensajes;
        }
        return StreamBuilder(
          stream: AppDataBase.shared.getUserAdd(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DatabaseEvent data = snapshot.data as DatabaseEvent;
              User newUser = User();
              newUser.fromMap(data.snapshot.key!, data.snapshot.value as Map);
              if (widget.chanel.allUsers[newUser.id] == null) {
                widget.chanel.allUsers[newUser.id] = newUser;
              }
            }
            return Scaffold(
              backgroundColor: isDark
                  ? AppColor.shared.backgroundHomeDark
                  : AppColor.shared.backgroundHome,
              appBar: AppBar(
                actions: [
                  MenuButton(user: widget.user, chanel: widget.chanel),
                ],
                backgroundColor: isDark
                    ? AppColor.shared.backgroundAppBarDark
                    : AppColor.shared.backgroundAppBar,
                title: Text(widget.chanel.nombre),
              ),
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/fondo2.png'),
                    fit: BoxFit.fitWidth,
                    colorFilter: ColorFilter.mode(
                        isDark
                            ? const Color(0XFF12151e)
                            : const Color(0XFFacc689),
                        BlendMode.color),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.785,
                        child: StreamBuilder(
                          stream: AppDataBase.shared.getNewMessage(chanel.id),
                          builder: (context, snapshot) {
                            if (messages.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasData) {
                              DatabaseEvent data =
                                  snapshot.data as DatabaseEvent;
                              final message = Message.fromMap(
                                  data.snapshot.key!,
                                  data.snapshot.value as Map);
                              try {
                                messages.firstWhere(
                                    (element) => element.id == message.id);
                              } catch (e) {
                                messages.insert(0, message);
                              }
                            }
                            return StreamBuilder(
                              stream: AppDataBase.shared
                                  .getMessageDelete(chanel.id),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  try {
                                    DatabaseEvent data =
                                        snapshot.data as DatabaseEvent;
                                    messages.removeWhere((element) {
                                      return element.id == data.snapshot.key!;
                                    });
                                  } catch (e) {
                                    //
                                  }
                                }
                                return StreamBuilder(
                                  stream: AppDataBase.shared
                                      .getMessageEdit(chanel.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      DatabaseEvent data =
                                          snapshot.data as DatabaseEvent;
                                      final message = Message.fromMap(
                                          data.snapshot.key!,
                                          data.snapshot.value as Map);
                                      try {
                                        final Message editM =
                                            messages.firstWhere((element) =>
                                                element.id == message.id);
                                        editM.texto = message.texto;
                                      } catch (e) {
                                        //
                                      }
                                    }
                                    return ListView.builder(
                                      reverse: true,
                                      itemCount: messages.length,
                                      itemBuilder: (context, index) {
                                        User userMessage = getUser(
                                            chanel, messages[index].usuario);
                                        if (messages[index].type ==
                                            'notification') {
                                          return _getNotificationMessage(
                                              messages[index], userMessage);
                                        } else if (userMessage.id ==
                                            widget.user.id) {
                                          return _getSendMessage(
                                              messages[index], userMessage);
                                        } else {
                                          return _getReceivedMessage(
                                              messages[index], userMessage);
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5),
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: BlocProvider(
                          create: (BuildContext context) => ChatBloc(),
                          child: BlocListener<ChatBloc, ChatState>(
                            listener: (context, state) {
                              switch (state.runtimeType) {
                                case ChatSuccess:
                                  Navigator.of(context).pop();
                                  break;
                                case ChatFail:
                                  Navigator.of(context).pop();
                                  final estado = state as ChatFail;
                                  alertBottom(estado.error, Colors.orange, 1500,
                                      context);
                                  break;
                                case ChatLoading:
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                  );
                                  break;
                              }
                            },
                            child: BlocBuilder<ChatBloc, ChatState>(
                              builder: (context, state) {
                                return Form(
                                  key: _formKey,
                                  child: InputText(
                                    hint: "Message",
                                    control: textControl,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "";
                                      }
                                      return null;
                                    },
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        FocusScope.of(context).unfocus();
                                        textControl.clear();
                                        BlocProvider.of<ChatBloc>(context).add(
                                          ChatStart(
                                            user: widget.user,
                                            chanel: widget.chanel,
                                            mensaje: message,
                                            context: context,
                                          ),
                                        );
                                      }
                                    },
                                    onSaved: (value) {
                                      message.texto = value!;
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showModal(BuildContext context, String title, Widget content) =>
      showModalBottomSheet(
        context: context,
        enableDrag: false,
        builder: (ctx) => ModalEditBottom(title: title, content: content),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
  User getUser(Chanel chanel, String id) {
    return chanel.allUsers[id]!;
  }

  Widget _getReceivedMessage(Message message, User user) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return _getMessageStyle(
      MainAxisAlignment.start,
      message,
      true,
      false,
      isDark ? const Color(0xFF202123) : Colors.white,
      FontWeight.normal,
      isDark ? Colors.white : Colors.black,
      user,
    );
  }

  Widget _getSendMessage(Message message, User user) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return InkWell(
      onLongPress: () {
        showModal(
          context,
          localizations.dictionary(Strings.editMessage),
          EditChatPage(
            message: message,
            chanel: widget.chanel,
          ),
        );
      },
      child: _getMessageStyle(
        MainAxisAlignment.end,
        message,
        false,
        false,
        isDark ? const Color(0xFF3a7db4) : const Color(0xFFeffedd),
        FontWeight.normal,
        isDark ? Colors.white : Colors.black,
        user,
      ),
    );
  }

  Widget _getNotificationMessage(Message message, User user) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return _getMessageStyle(
      MainAxisAlignment.center,
      message,
      false,
      true,
      isDark ? Colors.black26 : Colors.black12,
      FontWeight.bold,
      Colors.white,
      user,
    );
  }

  Widget _getMessageStyle(
    MainAxisAlignment alignment,
    Message message,
    bool left,
    bool center,
    Color color,
    FontWeight fontWeight,
    Color textColor,
    User user,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: alignment,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          left
              ? user.photoUrl.isEmpty
                  ? Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: user.color,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        user.displayName.characters.first,
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
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(user.photoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
              : Container(),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: center
                  ? MediaQuery.of(context).size.width * 0.9
                  : MediaQuery.of(context).size.width * 0.7,
              minWidth: MediaQuery.of(context).size.width * 0.3,
              minHeight: 30,
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: center
                    ? const BorderRadius.all(Radius.circular(100))
                    : BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: Radius.circular(left ? 0 : 10),
                        bottomRight: Radius.circular(left ? 10 : 0),
                      ),
              ),
              child: left
                  ? columnMessage(user, message.texto, message.fechaEnvio,
                      textColor, fontWeight)
                  : center
                      ? textMessage(user, message.texto, textColor, fontWeight)
                      : columnMessageRight(user, message.texto,
                          message.fechaEnvio, textColor, fontWeight),
            ),
          ),
        ],
      ),
    );
  }

  Widget columnMessageRight(
    User user,
    String message,
    DateTime date,
    Color textColor,
    FontWeight fontWeight,
  ) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: fontWeight,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          DateFormat('dd/MM/yyyy hh:mm a').format(date),
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget columnMessage(
    User user,
    String message,
    DateTime date,
    Color textColor,
    FontWeight fontWeight,
  ) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          user.displayName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textColor,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          message,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: fontWeight,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          DateFormat('dd/MM/yyyy hh:mm a').format(date),
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget textMessage(
      User user, String message, Color textColor, FontWeight fontWeight) {
    return Text(
      message,
      style: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: fontWeight,
      ),
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
