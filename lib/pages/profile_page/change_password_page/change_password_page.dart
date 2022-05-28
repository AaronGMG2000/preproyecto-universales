import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto/bloc/profile_bloc/profile_bloc.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/login_model.dart';
import 'package:proyecto/utils/app_color.dart';
import 'package:proyecto/utils/app_string.dart';
import 'package:proyecto/utils/app_validation.dart';
import 'package:proyecto/widget/widget_alert.dart';
import 'package:proyecto/widget/widget_button.dart';
import 'package:proyecto/widget/widget_input.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({
    Key? key,
  }) : super(key: key);

  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  void initState() {
    super.initState();
  }

  late AppLocalizations localizations = AppLocalizations.of(context);
  final Login register = Login();
  final _formKey = GlobalKey<FormState>();
  late bool obscureTextP = true;
  late bool obscureTextP2 = true;
  @override
  Widget build(BuildContext context) {
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
      body: BlocProvider(
        create: (BuildContext context) => ProfileBloc(),
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            switch (state.runtimeType) {
              case ProfileSuccess:
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                alertBottom(
                    localizations.dictionary(Strings.updatePasswordSuccess),
                    Colors.orange,
                    1500,
                    context);
                break;
              case ProfileFailure:
                Navigator.of(context).pop();
                final estado = state as ProfileFailure;
                alertBottom(estado.error, Colors.orange, 1500, context);
                break;
              case ProfileLoading:
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                );
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
                        margin: const EdgeInsets.only(top: 40, left: 50),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          localizations
                              .dictionary(Strings.singUpNewPasswordTitle),
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontFamily: "SegoeUI",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 50),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          localizations
                              .dictionary(Strings.singUpNewPasswordSubtitle),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: "SegoeUI",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 175),
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
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 100),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  _getInput(
                                    localizations
                                        .dictionary(Strings.singUpPasswordHint),
                                    (value) {
                                      register.password = value;
                                    },
                                    (value) {
                                      if (!Validator(value).isValidPassword) {
                                        return localizations.dictionary(
                                            Strings.loginErrorPassword);
                                      }
                                      return null;
                                    },
                                    obscureTextP,
                                    () {
                                      setState(() {
                                        obscureTextP = !obscureTextP;
                                      });
                                    },
                                    Icons.remove_red_eye,
                                  ),
                                  _getInput(
                                    localizations.dictionary(
                                        Strings.singUpRepeatPasswordHint),
                                    (value) {
                                      register.repeatPassword = value;
                                    },
                                    (value) {
                                      if (!Validator(value).isValidPassword) {
                                        return localizations.dictionary(
                                            Strings.loginErrorPassword);
                                      }
                                      return null;
                                    },
                                    obscureTextP2,
                                    () {
                                      setState(() {
                                        obscureTextP2 = !obscureTextP2;
                                      });
                                    },
                                    Icons.remove_red_eye,
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
                                          if (register.password ==
                                              register.repeatPassword) {
                                            BlocProvider.of<ProfileBloc>(
                                                    context)
                                                .add(ChangePassword(
                                              password: register.password,
                                              context: context,
                                            ));
                                          } else {
                                            alertBottom(
                                              localizations.dictionary(Strings
                                                  .singUpPasswordNotCoincidence),
                                              Colors.orange,
                                              1500,
                                              context,
                                            );
                                          }
                                        }
                                      },
                                      text: localizations.dictionary(
                                          Strings.updatePasswordButton),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
}
