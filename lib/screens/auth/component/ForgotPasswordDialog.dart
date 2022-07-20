import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/network/RestApis.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:qr_menu_laravel_flutter/utils/modelKeys.dart';

class ForgotPasswordDialog extends StatefulWidget {
  static String tag = '/ForgotPasswordScreen';

  @override
  ForgotPasswordDialogState createState() => ForgotPasswordDialogState();
}

class ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  TextEditingController forgotEmailController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${language.lblForgetPassword}", style: boldTextStyle(size: 20)),
          Text(language.lblEnterYouEmail, style: secondaryTextStyle()),
          16.height,
          Observer(
            builder: (_) => AppTextField(
              controller: forgotEmailController,
              textFieldType: TextFieldType.EMAIL,
              keyboardType: TextInputType.emailAddress,
              decoration: inputDecoration(
                context,
                label: language.lblEmail,
                textStyle: secondaryTextStyle(color: bodyColor),
              ).copyWith(
                  prefixIcon: Image.asset(
                'images/icons/ic_Message.png',
                height: 16,
                width: 16,
                fit: BoxFit.cover,
                color: bodyColor,
              ).paddingAll(12)),
              errorInvalidEmail: language.lblEnterValidEmail,
              errorThisFieldRequired: errorThisFieldRequired,
            ).visible(!appStore.isLoading, defaultWidget: Loader()),
          ),
          16.height,
          AppButton(
            child: Text(language.lblResetPassword, style: boldTextStyle(color: Colors.white)),
            width: context.width(),
            color: primaryColor,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                hideKeyboard(context);
                appStore.setLoading(true);

                Map request = {
                  Users.email: forgotEmailController.text.validate(),
                };

                if (!getBoolAsync(SharePreferencesKey.IS_DEMO_ADMIN)) {
                  forgotPassword(request).then((value) {
                    appStore.setLoading(false);

                    toast(language.lblResetPasswordLinkHasSentYourMail);
                    finish(context);
                  }).catchError((error) {
                    appStore.setLoading(false);
                    toast(error.toString());
                  });
                }
                else {
                  appStore.setLoading(false);
                  toast(language.lblDemoUserText);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
