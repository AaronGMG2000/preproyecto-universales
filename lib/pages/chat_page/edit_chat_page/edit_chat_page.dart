import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto/bloc/chat_bloc/chat_bloc.dart';
import 'package:proyecto/model/chanel_model.dart';
import 'package:proyecto/model/message_model.dart';
import 'package:proyecto/widget/widget_alert.dart';
import 'package:proyecto/widget/widget_input.dart';

class EditChatPage extends StatelessWidget {
  final Message message;
  final Chanel chanel;
  const EditChatPage({
    Key? key,
    required this.message,
    required this.chanel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final textControl = TextEditingController(text: message.texto);

    final isDark = Theme.of(context).primaryColor == Colors.white;
    return BlocProvider(
      create: (BuildContext context) => ChatBloc(),
      child: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case ChatFail:
              Navigator.of(context).pop();
              final estado = state as ChatFail;
              alertBottom(estado.error, Colors.orange, 1500, context);
              break;
            case ChatSuccess:
              Navigator.of(context).pop();
              break;
            case ChatDeleteSuccess:
              Navigator.of(context).pop();
              break;
          }
        },
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return Form(
              key: formKey,
              child: InputText(
                prefixIcon: TextButton(
                  onPressed: () => BlocProvider.of<ChatBloc>(context).add(
                    ChatDelete(
                      mensaje: message,
                      context: context,
                      chanel: chanel,
                    ),
                  ),
                  child: Icon(Icons.delete,
                      color: isDark ? Colors.white : Colors.black),
                ),
                hint: "Message",
                control: textControl,
                validator: (value) {
                  if (value.isEmpty) {
                    return "";
                  }
                  return null;
                },
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    FocusScope.of(context).unfocus();
                    textControl.clear();
                    BlocProvider.of<ChatBloc>(context).add(
                      ChatEdit(
                        mensaje: message,
                        context: context,
                        chanel: chanel,
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
    );
  }
}
