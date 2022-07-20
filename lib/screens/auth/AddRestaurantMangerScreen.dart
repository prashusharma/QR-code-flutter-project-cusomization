import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/network/RestApis.dart';
import 'package:qr_menu_laravel_flutter/screens/restaurant/DashboardScreen.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:qr_menu_laravel_flutter/utils/modelKeys.dart';

class AddRestaurantMangerScreen extends StatefulWidget {
  final bool? isFromLogin;

  AddRestaurantMangerScreen({this.isFromLogin = true});

  @override
  AddRestaurantMangerScreenState createState() => AddRestaurantMangerScreenState();
}

class AddRestaurantMangerScreenState extends State<AddRestaurantMangerScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController numCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController createdAtCont = TextEditingController();
  TextEditingController updatedAtCont = TextEditingController();

  FocusNode contactFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }


  Future<void> addRestaurantManager() async {
    Map request = {
      Users.name: nameCont.text.validate(),
      Users.userName: emailCont.text.validate().splitBefore('@'),
      Users.email: emailCont.text.validate(),
      Users.password: passCont.text.validate(),
      Users.userType: LoginTypes.restaurantManager
    };
    appStore.setLoading(true);

    await createUser(request).then((value) async {
      toast(value.message.validate());
      appStore.setLoading(false);

      push(DashboardScreen(), pageRouteAnimation: PageRouteAnimation.Slide, isNewTask: true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        '${language.lblAddRestaurantManager}',
        color: context.scaffoldBackgroundColor,
        elevation: 0,
        backWidget: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Observer(
        builder: (_) => Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Divider(thickness: 1, color: context.dividerColor, indent: 16, endIndent: 16),
                  Container(
                    decoration: BoxDecoration(borderRadius: radius(defaultRadius), color: context.cardColor),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    margin: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${language.lblAddManager}', style: boldTextStyle(size: 16)),
                        8.height,
                        Text('${language.lblYouCanAlsoAddManger}', style: secondaryTextStyle(color: bodyColor)),
                        24.height,
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
                                  label: language.lblEmail,
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
                                suffixIconColor: bodyColor,
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
                              widget.isFromLogin! ? Offstage() : 24.height,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.height,
                  AppButton(
                      text: language.lblSave.toUpperCase(),
                      textStyle: boldTextStyle(color: Colors.white),
                      width: context.width(),
                      elevation: 0,
                      color: primaryColor,
                      enabled: appStore.isLoading ? false : true,
                      shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultAppButtonRadius)),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          hideKeyboard(context);
                          addRestaurantManager();
                        }
                      }).paddingSymmetric(horizontal: 16),
                ],
              ),
            ).visible(!appStore.isLoading),
            Loader().visible(appStore.isLoading)
          ],
        ),
      ),
    );
  }
}
