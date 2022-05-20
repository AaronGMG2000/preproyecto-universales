import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:proyecto/localization/locations.dart';
import 'package:proyecto/utils/app_color.dart';
import 'package:proyecto/utils/app_string.dart';
import 'package:proyecto/utils/app_style.dart';
import 'package:proyecto/widget/widget_button.dart';
import 'package:proyecto/widget/widget_input.dart';

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
  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  children: [
                    _getInput(localizations.dictionary(Strings.loginEmailHint)),
                    _getInput(
                        localizations.dictionary(Strings.loginPasswordHint)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ButtonTextGradient(
                        height: 60,
                        size: 24,
                        onPressed: () {},
                        text: localizations.dictionary(Strings.loginButtonText),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localizations.dictionary(Strings.loginCreateAccount),
                          style: AppStyle.shared.fonts.newAccountText2(context),
                        ),
                        const SizedBox(width: 2),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            localizations.dictionary(Strings.loginSingUpText),
                            style:
                                AppStyle.shared.fonts.newAccountText(context),
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
  }

  Widget _getInput(hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InputIconText(
        hint: hint,
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
                        getButtonIcon(
                            "assets/icons/google.png", () {}, context),
                        const SizedBox(width: 20),
                        getButtonIcon(
                            "assets/icons/facebook.png", () {}, context),
                        const SizedBox(width: 20),
                        getButtonIcon(
                            "assets/icons/twitter.png", () {}, context),
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
