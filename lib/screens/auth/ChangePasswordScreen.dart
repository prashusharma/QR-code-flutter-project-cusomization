import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/network/RestApis.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:qr_menu_laravel_flutter/utils/modelKeys.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController oldPassCont = TextEditingController();
  TextEditingController newPassCont = TextEditingController();
  TextEditingController confNewPassCont = TextEditingController();

  FocusNode newPassFocus = FocusNode();
  FocusNode confPassFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    afterBuildCreated(() {
      setStatusBarColor(context.scaffoldBackgroundColor);
    });
  }

  Future<void> submit() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);
      setState(() {});

      Map request = {
        Users.oldPassword: oldPassCont.text.validate(),
        Users.newPassword: newPassCont.text.validate(),
      };

      await changePassword(request).then((value) {
        toast(value.message.validate());
        appStore.setPassword(newPassCont.text.validate());

        finish(context);
      }).catchError((e) {
        toast(e.toString());
      }).whenComplete(() => appStore.setLoading(false));
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.lblChangePassword,
        elevation: 0,
        color: context.scaffoldBackgroundColor,
        backWidget: IconButton(
          onPressed: () {
            finish(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: context.iconColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(thickness: 1, color: context.dividerColor, indent: 16, endIndent: 16),
            Container(
              constraints: BoxConstraints(maxWidth: 500),
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
              child: Observer(
                builder: (_) => Stack(
                  children: [
                    Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${language.lblResetYourPassword}', style: boldTextStyle()),
                          8.height,
                          Text('${language.lblResetPasswordText}', style: secondaryTextStyle(color: bodyColor)),
                          16.height,
                          AppTextField(
                            controller: oldPassCont,
                            textFieldType: TextFieldType.PASSWORD,
                            suffixIconColor: bodyColor,
                            nextFocus: newPassFocus,
                            textStyle: primaryTextStyle(),
                            autoFillHints: [AutofillHints.password],
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
                              label: "${language.lblOldPassword}",
                              textStyle: secondaryTextStyle(color: bodyColor),
                            ).copyWith(
                              prefixIcon: Image.asset('images/icons/ic_Lock.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                            ),
                            validator: (String? s) {
                              if (s!.isEmpty) return errorThisFieldRequired;
                              if (s != getStringAsync(SharePreferencesKey.PASSWORD)) return '${language.lblOldPasswordIsNotCorrect}';
                              return null;
                            },
                          ),
                          16.height,
                          AppTextField(
                            controller: newPassCont,
                            textFieldType: TextFieldType.PASSWORD,
                            focus: newPassFocus,
                            nextFocus: confPassFocus,
                            textStyle: primaryTextStyle(),
                            autoFillHints: [AutofillHints.newPassword],
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
                              label: '${language.lblNewPassword}',
                              textStyle: secondaryTextStyle(color: bodyColor),
                            ).copyWith(
                              prefixIcon: Image.asset('images/icons/ic_Lock.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                            ),
                          ),
                          16.height,
                          AppTextField(
                            controller: confNewPassCont,
                            textFieldType: TextFieldType.PASSWORD,
                            suffixIconColor: bodyColor,
                            textInputAction: TextInputAction.done,
                            focus: confPassFocus,
                            textStyle: primaryTextStyle(),
                            autoFillHints: [AutofillHints.newPassword],
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
                              label: '${language.lblConfirmPassword}',
                              textStyle: secondaryTextStyle(color: bodyColor),
                            ).copyWith(
                              prefixIcon: Image.asset('images/icons/ic_Lock.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                            ),
                            validator: (String? value) {
                              if (value!.isEmpty) return errorThisFieldRequired;
                              if (value.length < passwordLengthGlobal) return '${language.lblPasswordLengthShouldBeMoreThanSix}';
                              if (value.trim() != newPassCont.text.trim()) return '${language.lblBothPasswordShouldBeMatched}';
                              if (value.trim() == oldPassCont.text.trim()) return '${language.lblOldPasswordShouldNotBeSameAsNewPassword}';

                              return null;
                            },
                            onFieldSubmitted: (s) {
                              submit();
                            },
                          ),
                          30.height,
                          AppButton(
                            text: language.lblSave.toUpperCase(),
                            width: context.width(),
                            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultAppButtonRadius)),
                            enabled: appStore.isLoading ? false : true,
                            color: primaryColor,
                            elevation: 0,
                            textStyle: boldTextStyle(color: Colors.white, size: 18),
                            onTap: () {
                              if (!getBoolAsync(SharePreferencesKey.IS_DEMO_ADMIN)) {
                                submit();
                              }else {
                                toast(language.lblDemoUserText);
                              }
                            },
                          ),
                        ],
                      ),
                    ).visible(!appStore.isLoading),
                    Loader().visible(appStore.isLoading)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
