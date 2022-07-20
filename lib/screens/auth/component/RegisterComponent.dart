import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/network/RestApis.dart';
import 'package:qr_menu_laravel_flutter/screens/restaurant/DashboardScreen.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:qr_menu_laravel_flutter/utils/modelKeys.dart';

class RegisterComponent extends StatefulWidget {
  final VoidCallback? callback;

  RegisterComponent({this.callback});

  @override
  _RegisterComponentState createState() => _RegisterComponentState();
}

class _RegisterComponentState extends State<RegisterComponent> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController numCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController createdAtCont = TextEditingController();
  TextEditingController updatedAtCont = TextEditingController();

  FocusNode contactFocus = FocusNode();

  Future<void> register() async {
    Map request = {
      Users.name: nameCont.text.validate(),
      Users.userName: emailCont.text.validate().splitBefore('@'),
      Users.email: emailCont.text.validate(),
      Users.password: passCont.text.validate(),
      Users.userType: LoginTypes.restaurantManager,
      Users.contactNumber: numCont.text.validate()
    };
    appStore.setLoading(true);

    await createUser(request).then((value) async {
      toast(value.message.validate());
      appStore.setLoading(true);

      Map request = {
        Users.email: value.data!.email.validate(),
        Users.password: passCont.text.validate(),
      };

      await loginUser(request).then((value) {
        toast(language.lblLoginSuccessFully);
        appStore.setPassword(passCont.text.validate());

        push(DashboardScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
      }).catchError((e) {
        toast(e.toString());
      }).whenComplete(() => appStore.setLoading(false));
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        16.height,
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                autoFocus: false,
                textInputAction: TextInputAction.next,
                textStyle: primaryTextStyle(),
                controller: nameCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(
                  context,
                  label: '${language.lblYour} ${language.lblName}',
                  textStyle: secondaryTextStyle(color: bodyColor),
                ).copyWith(
                  prefixIcon: Image.asset('images/icons/ic_User.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                ),
              ),
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
                  prefixIcon: Image.asset('images/icons/ic_Message.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                ),
              ),
              16.height,
              AppTextField(
                textStyle: primaryTextStyle(),
                textInputAction: TextInputAction.next,
                controller: passCont,
                textFieldType: TextFieldType.PASSWORD,
                nextFocus: contactFocus,
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
              ),
              16.height,
              AppTextField(
                focus: contactFocus,
                textInputAction: TextInputAction.done,
                textStyle: primaryTextStyle(),
                isValidationRequired: false,
                controller: numCont,
                maxLength: 12,
                textFieldType: TextFieldType.PHONE,
                decoration: inputDecoration(
                  context,
                  label: '${language.lblContact}',
                  textStyle: secondaryTextStyle(color: bodyColor),
                ).copyWith(
                  prefixIcon: Image.asset('images/icons/ic_Phone.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                ),
              ),
            ],
          ),
        ),
        24.height,
        AppButton(
          text: '${language.lblRegister.toUpperCase()}',
          textStyle: boldTextStyle(color: Colors.white, size: 18),
          color: primaryColor,
          elevation: 0,
          width: context.width(),
          shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultAppButtonRadius)),
          onTap: () {
            if (_formKey.currentState!.validate()) {
              hideKeyboard(context);
              register();
            }
          },
        ),
        100.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${language.lblAlreadyHaveAccount}?", style: secondaryTextStyle(color: bodyColor)),
            2.width,
            Text('${language.lblLogin.toUpperCase()}', style: boldTextStyle(size: 14, color: primaryColor)).onTap(() {
              widget.callback?.call();
            }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
          ],
        ),
      ],
    );
  }
}
