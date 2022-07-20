import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/qr/QrScannerScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/auth/component/LoginComponent.dart';
import 'package:qr_menu_laravel_flutter/screens/auth/component/RegisterComponent.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

class SignInScreen extends StatefulWidget {
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  bool isLogin = true;

  @override
  void initState() {
    afterBuildCreated(() {
      appStore.setLoading(false);
    });
    super.initState();
    setStatusBarColor(Colors.transparent);
  }

  Widget getFragment() {
    if (isLogin) {
      return LoginComponent(
        callback: () {
          isLogin = false;
          setState(() {});
        },
      );
    } else {
      return RegisterComponent(
        callback: () {
          isLogin = true;
          setState(() {});
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          !isWeb
              ? Tooltip(
                  message: language.lblScanQRCode,
                  child: IconButton(
                    icon: Icon(Icons.qr_code_scanner, color: context.iconColor),
                    onPressed: () {
                      QRScanner().launch(context, pageRouteAnimation: PageRouteAnimation.Scale, duration: 450.milliseconds);
                    },
                  ).paddingRight(16),
                )
              : Offstage()
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Text('${language.lblHelloUserWelcomeToQR}', style: primaryTextStyle(size: 22)),
                16.height,
                Text('${language.lblWelcomeBackText}', style: secondaryTextStyle(color: bodyColor), textAlign: TextAlign.center),
                16.height,
                Container(
                  constraints: BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    borderRadius: radius(),
                    color: context.cardColor,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Text(
                              '${language.lblLogin.toUpperCase()}',
                              style: primaryTextStyle(color: isLogin ? primaryColor : bodyColor),
                              textAlign: TextAlign.center,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: isLogin ? primaryColor : context.dividerColor, width: isLogin ? 2.5 : 2),
                              ),
                            ),
                          ).onTap(() {
                            isLogin = true;
                            setState(() {});
                          }).expand(),
                          Container(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Text(
                              '${language.lblRegister.toUpperCase()}',
                              style: primaryTextStyle(color: !isLogin ? primaryColor : bodyColor),
                              textAlign: TextAlign.center,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: !isLogin ? primaryColor : context.dividerColor, width: !isLogin ? 2.5 : 2),
                              ),
                            ),
                          ).onTap(() {
                            isLogin = false;
                            setState(() {});
                          }).expand(),
                        ],
                      ),
                      16.height,
                      getFragment(),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 16, vertical: 8),
                30.height,
              ],
            ).paddingTop(20),
          ).center(),
          Observer(
            builder: (_) => Loader().visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }
}
