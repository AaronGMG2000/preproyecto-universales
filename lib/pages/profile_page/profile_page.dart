import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto/bloc/profile_bloc/profile_bloc.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/pages/profile_page/change_password_page/change_password_page.dart';
import 'package:proyecto/utils/app_string.dart';
import 'package:proyecto/widget/widget_alert.dart';
import 'package:proyecto/widget/widget_button.dart';
import 'package:proyecto/widget/widget_input.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final locatizations = AppLocalizations(Localizations.localeOf(context));
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: Text(locatizations.dictionary(Strings.profile)),
        backgroundColor:
            isDark ? const Color.fromRGBO(17, 17, 17, 1) : Colors.blue,
        elevation: 0,
      ),
      backgroundColor:
          isDark ? const Color.fromRGBO(17, 17, 17, 1) : Colors.blue,
      body: BlocProvider(
        create: (BuildContext context) => ProfileBloc(),
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            switch (state.runtimeType) {
              case ProfileLoading:
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                );
                break;
              case ProfileFailure:
                Navigator.of(context).pop();
                final estado = state as ProfileFailure;
                alertBottom(estado.error, Colors.orange, 1500, context);
                break;
              case ProfileSuccess:
                Navigator.of(context).pop();
                alertBottom(locatizations.dictionary(Strings.updateSuccess),
                    Colors.orange, 1500, context);
                break;
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        alignment: Alignment.center,
                        height: 125,
                        width: 125,
                        child: Stack(
                          children: [
                            widget.user.photoUrl.isEmpty
                                ? Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: widget.user.color,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.user.displayName.characters.first,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 64,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 65,
                                    backgroundImage: NetworkImage(
                                      widget.user.photoUrl,
                                    ),
                                  ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: !isDark
                                      ? Colors.yellowAccent
                                      : Theme.of(context).colorScheme.secondary,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        child: Text(
                          widget.user.displayName,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        alignment: Alignment.center,
                        child: Text(
                          widget.user.email,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(79, 79, 79, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 250),
                    decoration: BoxDecoration(
                      color: !isDark
                          ? Colors.white
                          : const Color.fromRGBO(29, 29, 29, 1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(top: 30),
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _getInput(
                                locatizations
                                    .dictionary(Strings.singUpNameHint),
                                (value) {
                                  widget.user.displayName = value;
                                },
                                (value) {
                                  if (value.isEmpty) {
                                    return locatizations.dictionary(
                                        Strings.registerDisplayedNameError);
                                  }
                                  return null;
                                },
                                false,
                                () {},
                                Icons.abc,
                                widget.user.displayName,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 20),
                                child: ButtonTextGradient(
                                  height: 60,
                                  size: 24,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      BlocProvider.of<ProfileBloc>(context).add(
                                        ProfileChangeUser(
                                            user: widget.user,
                                            context: context),
                                      );
                                    }
                                  },
                                  text: locatizations
                                      .dictionary(Strings.changePerfil),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 20),
                                child: ButtonTextGradient(
                                  height: 60,
                                  size: 24,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const Center(
                                            child: ChangePasswordPage()),
                                      ),
                                    );
                                  },
                                  text: locatizations
                                      .dictionary(Strings.changePassword),
                                ),
                              ),
                            ],
                          ),
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

  Widget _getInput(
      hint, onSaved, validator, obscureText, iconAction, icon, initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InputIconText(
        hint: hint,
        onSaved: onSaved,
        obscureText: obscureText,
        icon: icon,
        initialValue: initialValue,
        onPressed: iconAction,
        validator: validator,
      ),
    );
  }
}
