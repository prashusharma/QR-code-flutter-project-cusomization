import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/network/RestApis.dart';
import 'package:qr_menu_laravel_flutter/screens/auth/component/ForgotPasswordDialog.dart';
import 'package:qr_menu_laravel_flutter/screens/restaurant/DashboardScreen.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:qr_menu_laravel_flutter/utils/modelKeys.dart';

class LoginComponent extends StatefulWidget {
  final VoidCallback? callback;

  LoginComponent({this.callback});

  @override
  _LoginComponentState createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailCont = TextEditingController(text: DemoDetail.demo_email);
  TextEditingController passCont = TextEditingController(text: DemoDetail.demo_pass);

  @override
  void initState() {
    super.initState();

    if(appStore.doRemember){
      emailCont.text = appStore.userEmail;
      passCont.text = appStore.password;
      setState(() {});
    }
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      hideKeyboard(context);
      appStore.setLoading(true);

      Map request = {
        Users.email: emailCont.text.validate(),
        Users.password: passCont.text.validate(),
      };

      await loginUser(request).then((value) {
        toast(language.lblLoginSuccessFully);

        appStore.setPassword(passCont.text.validate());

        push(DashboardScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
      }).catchError((e) {
        toast(e.toString());
      }).whenComplete(() => appStore.setLoading(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        16.height,
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.height,
              AppTextField(
                textInputAction: TextInputAction.next,
                textStyle: primaryTextStyle(),
                controller: emailCont,
                textFieldType: TextFieldType.EMAIL,
                decoration: inputDecoration(
                  context,
                  label: '${language.lblEmailAddress}',
                  textStyle: secondaryTextStyle(color: bodyColor),
                ).copyWith(
                  prefixIcon: Image.asset(
                    'images/icons/ic_Message.png',
                    height: 16,
                    width: 16,
                    fit: BoxFit.cover,
                    color: bodyColor,
                  ).paddingAll(12),
                ),
              ),
              16.height,
              AppTextField(
                textStyle: primaryTextStyle(),
                controller: passCont,
                textFieldType: TextFieldType.PASSWORD,
                suffixIconColor: bodyColor,
                suffixPasswordInvisibleWidget: Image.asset(
                  'images/icons/ic_Hide.png',
                  height: 16,
                  width: 16,
                  fit: BoxFit.cover,
                  color: bodyColor,
                ).paddingAll(12),
                suffixPasswordVisibleWidget: Image.asset(
                  'images/icons/ic_Show.png',
                  height: 16,
                  width: 16,
                  fit: BoxFit.cover,
                  color: bodyColor,
                ).paddingAll(12),
                decoration: inputDecoration(
                  context,
                  label: language.lblPassword,
                  textStyle: secondaryTextStyle(color: bodyColor),
                ).copyWith(
                  prefixIcon: Image.asset('images/icons/ic_Lock.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (s) {
                  login();
                },
              ),
              8.height,
            ],
          ),
        ),
        Observer(
          builder:(_) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(color: primaryColor.withAlpha(30), borderRadius: radius(4)),
                    child: appStore.doRemember ? Icon(Icons.check, color: primaryColor, size: 14) : Offstage(),
                  ),
                  8.width,
                  Text('${language.lblRememberMe}', style: secondaryTextStyle(color: bodyColor)),
                ],
              ).onTap(() {
                appStore.setRemember(!appStore.doRemember);
                setState(() {});
              }),
              TextButton(
                onPressed: () {
                  showInDialog(context, dialogAnimation: DialogAnimation.SLIDE_TOP_BOTTOM, builder: (_) => ForgotPasswordDialog());
                },
                child: Text(
                  '${language.lblForgotPassword}?',
                  style: primaryTextStyle(size: 12, color: primaryColor, fontStyle: FontStyle.italic, weight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        24.height,
        AppButton(
          text: '${language.lblLogin.toUpperCase()}',
          elevation: 0,
          width: context.width(),
          color: primaryColor,
          shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultAppButtonRadius)),
          textStyle: boldTextStyle(color: Colors.white, size: 18),
          onTap: () {
            login();
          },
        ),
        100.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${language.lblDontHaveAnAccount}?", style: secondaryTextStyle(color: bodyColor)),
            2.width,
            Text(
              '${language.lblRegister.toUpperCase()}',
              style: boldTextStyle(size: 14, color: primaryColor),
            ).onTap(() {
              widget.callback?.call();
            }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
          ],
        ),
      ],
    );
  }
}
