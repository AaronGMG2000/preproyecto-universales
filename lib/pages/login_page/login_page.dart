import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/model/login_model.dart';
import 'package:proyecto/pages/sing_up_page/sing_up_page.dart';
import 'package:proyecto/utils/app_color.dart';
import 'package:proyecto/utils/app_string.dart';
import 'package:proyecto/utils/app_style.dart';
import 'package:proyecto/utils/app_validation.dart';
import 'package:proyecto/widget/widget_alert.dart';
import 'package:proyecto/widget/widget_button.dart';
import 'package:proyecto/widget/widget_check.dart';
import 'package:proyecto/widget/widget_input.dart';

import '../../bloc/login_bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AppLocalizations localizations = AppLocalizations.of(context);
  final double expandedHeight = 250;
  final double collapsedHeight = 65;
  final scrollController = ScrollController();
  final Login login = Login();
  late bool obscureTextP = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case LoginFail:
              Navigator.of(context).pop();
              final estado = state as LoginFail;
              alertBottom(estado.error, Colors.orange, 1500, context);
              break;
            case LoginLoading:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                ),
              );
              break;
            case LoginSuccess:
              Navigator.of(context).pop();
              break;
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: expandedHeight,
                  collapsedHeight: collapsedHeight,
                  elevation: 0,
                  floating: true,
                  snap: true,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: RoundedAppBar(
                    expandedHeight + 20,
                    content: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: _getHeader(scrollController),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _getInput(
                              localizations.dictionary(Strings.loginEmailHint),
                              (value) {
                                login.email = value;
                              },
                              (value) {
                                if (!Validator(value).isValidEmail) {
                                  return localizations
                                      .dictionary(Strings.loginErrorEmail);
                                }
                                return null;
                              },
                              false,
                              () {},
                              Icons.email,
                            ),
                            _getInput(
                              localizations
                                  .dictionary(Strings.loginPasswordHint),
                              (value) {
                                login.password = value;
                              },
                              (value) {
                                if (!Validator(value).isValidPassword) {
                                  return localizations
                                      .dictionary(Strings.loginErrorPassword);
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: CheckboxText(
                                onChanged: (value) {},
                                text: localizations
                                    .dictionary(Strings.loginRememberMe),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: IconButtonImage(
                                height: 60,
                                icon: "assets/icons/finger.png",
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: ButtonTextGradient(
                                height: 60,
                                size: 24,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    BlocProvider.of<LoginBloc>(context).add(
                                        LoginStart(
                                            login: login,
                                            rememberMe: false,
                                            context: context));
                                  }
                                },
                                text: localizations
                                    .dictionary(Strings.loginButtonText),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  localizations
                                      .dictionary(Strings.loginCreateAccount),
                                  style: AppStyle.shared.fonts
                                      .newAccountText2(context),
                                ),
                                const SizedBox(width: 2),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SingUpPage()),
                                    ).then((value) {
                                      if (value != null) {}
                                    });
                                  },
                                  child: Text(
                                    localizations
                                        .dictionary(Strings.loginSingUpText),
                                    style: AppStyle.shared.fonts
                                        .newAccountText(context),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          },
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
        validator: validator,
        icon: icon,
        onPressed: iconAction,
        obscureText: obscureText,
      ),
    );
  }

  Widget _getHeader(ScrollController controller) {
    double titlePaddingTop = 40;

    return LayoutBuilder(
      builder: (context, constraints) {
        final scrollPosition = controller.positions.first;
        final diferenceHeight = constraints.maxHeight - collapsedHeight;
        if (scrollPosition.userScrollDirection == ScrollDirection.forward &&
            diferenceHeight > 25) {
          titlePaddingTop = titlePaddingTop + 2.5;
          if (titlePaddingTop >= 40) titlePaddingTop = 40;
        } else if (scrollPosition.userScrollDirection ==
            ScrollDirection.reverse) {
          titlePaddingTop = titlePaddingTop - 5;
          if (titlePaddingTop <= 5) titlePaddingTop = 5;
        } else {
          titlePaddingTop = titlePaddingTop - 20;
          if (titlePaddingTop <= 5) titlePaddingTop = 5;
        }
        if (diferenceHeight <= 100) {
          titlePaddingTop = 5;
        }
        if (diferenceHeight >= 140) {
          titlePaddingTop = 40;
        }
        return Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(20, titlePaddingTop, 10, 20),
                  child: Text(localizations.dictionary(Strings.loginTitle),
                      style: AppStyle.shared.fonts.titleText(context)),
                ),
              ],
            ),
            diferenceHeight >= 100
                ? Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Text(
                        localizations.dictionary(Strings.loginOthersOptions),
                        style: AppStyle.shared.fonts
                            .moreOptionsSigInText(context)),
                  )
                : Container(),
            diferenceHeight >= 100
                ? Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getButtonIcon("assets/icons/google.png", () {
                          BlocProvider.of<LoginBloc>(context)
                              .add(LoginGoogleStart(context: context));
                        }, context),
                        const SizedBox(width: 20),
                        getButtonIcon("assets/icons/facebook.png", () {
                          BlocProvider.of<LoginBloc>(context)
                              .add(LoginFacebookStart(context: context));
                        }, context),
                        const SizedBox(width: 20),
                        getButtonIcon("assets/icons/twitter.png", () {
                          BlocProvider.of<LoginBloc>(context)
                              .add(LoginTwitterStart(context: context));
                        }, context),
                      ],
                    ),
                  )
                : Container()
          ],
        );
      },
    );
  }
}

Widget getButtonIcon(url, action, context) {
  return ButtonIcon(
    urlImage: url,
    onPressed: action,
    width: MediaQuery.of(context).size.width * 0.225,
  );
}

class RoundedAppBar extends StatelessWidget {
  final double expandedHeight;
  final Widget content;

  const RoundedAppBar(this.expandedHeight, {required this.content, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDark = Theme.of(context).primaryColor == Colors.white;
        return ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: 100, maxHeight: expandedHeight),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColor.shared.custoAppBarColorDark
                  : AppColor.shared.custoAppBarColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: content,
          ),
        );
      },
    );
  }
}
