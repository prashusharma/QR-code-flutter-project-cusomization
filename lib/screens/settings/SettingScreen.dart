import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/network/RestApis.dart';
import 'package:qr_menu_laravel_flutter/qr/QrStyleScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/auth/AddRestaurantMangerScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/auth/ChangePasswordScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/menu/MenuStyleScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/settings/AboutScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/settings/LanguageScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/settings/components/EditProfileCard.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:share_plus/share_plus.dart';

class SettingScreen extends StatefulWidget {
  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      setStatusBarColor(context.scaffoldBackgroundColor);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget trailingIcon({bool? isVersion}) {
    if (isVersion.validate()) {
      return Row(
        children: [
          SnapHelperWidget(
            future: PackageInfo.fromPlatform(),
            onSuccess: (PackageInfo snap) {
              return Text(snap.version, style: secondaryTextStyle(color: bodyColor));
            },
          ),
          8.width,
          Icon(Icons.arrow_forward_ios, color: bodyColor, size: 14),
        ],
      );
    } else {
      return Icon(Icons.arrow_forward_ios, color: bodyColor, size: 14);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.lblSettings,
        color: context.scaffoldBackgroundColor,
        elevation: 0,
        backWidget: IconButton(
          onPressed: () {
            finish(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: context.iconColor),
        ),
      ),
      body: Observer(
        builder: (_) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: context.dividerColor, thickness: 1, indent: 16, endIndent: 16),
              EditProfileCard(),
              SettingItemWidget(
                title: language.lblDarkMode,
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                leading: Image.asset('images/icons/ic_Theme.png', height: 24, width: 24, fit: BoxFit.cover, color: appStore.isDarkMode ? context.iconColor : bodyColor),
                titleTextStyle: boldTextStyle(size: 16),
                trailing: Transform.scale(
                  scale: 0.7,
                  alignment: Alignment.centerRight,
                  child: CupertinoSwitch(
                    value: appStore.isDarkMode,
                    onChanged: (value) {
                      appStore.setDarkMode(value);
                      if (value) {
                        setValue(THEME_MODE_INDEX, 2);
                      } else {
                        setValue(THEME_MODE_INDEX, 1);
                      }
                      setState(() {});
                    },
                    activeColor: primaryColor,
                    trackColor: context.dividerColor,
                  ),
                ),
              ),
              SettingItemWidget(
                leading: Image.asset('images/icons/ic_Lock.png', height: 24, width: 24, fit: BoxFit.cover, color: appStore.isDarkMode ? context.iconColor : bodyColor),
                padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
                title: '${language.lblChangePassword}',
                titleTextStyle: boldTextStyle(size: 16),
                onTap: () {
                  if (getBoolAsync(SharePreferencesKey.IS_EMAIL_LOGIN)) {
                    push(ChangePasswordScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
                  } else {
                    toast(language.lblUserLoginWithSocialAccountCannotChangeThePassword);
                  }
                },
                trailing: trailingIcon(),
              ),
              SettingItemWidget(
                leading: Image.asset('images/icons/ic_Users.png', height: 24, width: 24, fit: BoxFit.cover, color: appStore.isDarkMode ? context.iconColor : bodyColor),
                padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
                title: language.lblAddRestaurantManager,
                titleTextStyle: boldTextStyle(size: 16),
                onTap: () {
                  push(AddRestaurantMangerScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
                },
                trailing: trailingIcon(),
              ).visible(appStore.isAdmin),
              SettingItemWidget(
                leading: Image.asset('images/icons/ic_Language.png', height: 24, width: 24, fit: BoxFit.cover, color: appStore.isDarkMode ? context.iconColor : bodyColor),
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                title: "${language.lblAppLanguage}",
                titleTextStyle: boldTextStyle(size: 16),
                trailing: trailingIcon(),
                onTap: () {
                  push(LanguageScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
                },
              ),
              SettingItemWidget(
                title: language.lblSetMenuStyle,
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                leading: Image.asset('images/icons/ic_Menu_Style.png', height: 24, width: 24, fit: BoxFit.cover, color: appStore.isDarkMode ? context.iconColor : bodyColor),
                titleTextStyle: boldTextStyle(size: 16),
                onTap: () {
                  push(MenuStyleScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
                },
                trailing: trailingIcon(),
              ),
              SettingItemWidget(
                title: language.lblSetQrStyle,
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                leading: Image.asset('images/icons/ic_Qr_Style.png', height: 24, width: 24, fit: BoxFit.cover, color: appStore.isDarkMode ? context.iconColor : bodyColor),
                titleTextStyle: boldTextStyle(size: 16),
                onTap: () {
                  push(QrStyleScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
                },
                trailing: trailingIcon(),
              ),
              SettingItemWidget(
                title: language.lblPrivacyPolicy,
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                leading: Image.asset('images/icons/ic_Privacy.png', height: 24, width: 24, fit: BoxFit.cover, color: appStore.isDarkMode ? context.iconColor : bodyColor),
                titleTextStyle: boldTextStyle(size: 16),
                onTap: () {
                  launchUrlCustomTab(Urls.privacyPolicyURL);
                },
              ),
              isWeb
                  ? Offstage()
                  : SnapHelperWidget<PackageInfo>(
                      onSuccess: (d) => SettingItemWidget(
                        leading: Image.asset('images/icons/ic_Rate.png', height: 24, width: 24, fit: BoxFit.cover, color: appStore.isDarkMode ? context.iconColor : bodyColor),
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                        titleTextStyle: boldTextStyle(size: 16),
                        title: language.lblRateUs,
                        onTap: () {
                          launchUrlCustomTab('$playStoreBaseURL${d.packageName}');
                        },
                      ),
                      future: PackageInfo.fromPlatform(),
                    ),
              SettingItemWidget(
                leading: Image.asset('images/icons/ic_Help.png', height: 24, width: 24, fit: BoxFit.cover, color: appStore.isDarkMode ? context.iconColor : bodyColor),
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                titleTextStyle: boldTextStyle(size: 16),
                title: language.lblHelpSupport,
                onTap: () {
                  launchUrlCustomTab(Urls.termsAndConditionURL);
                },
              ),
              isWeb
                  ? Offstage()
                  : SettingItemWidget(
                      leading: Image.asset('images/icons/ic_share.png', height: 24, width: 24, fit: BoxFit.cover, color: appStore.isDarkMode ? context.iconColor : bodyColor),
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                      titleTextStyle: boldTextStyle(size: 16),
                      title: language.lblShare,
                      onTap: () {
                        Share.share(
                          'Share ${AppConstant.appName} app\n\n${AppConstant.appDescription}',
                        );
                      },
                    ),
              SettingItemWidget(
                title: language.lblAbout,
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                leading: Image.asset('images/icons/ic_About.png', height: 24, width: 24, fit: BoxFit.cover, color: appStore.isDarkMode ? context.iconColor : bodyColor),
                titleTextStyle: boldTextStyle(size: 16),
                onTap: () {
                  push(AboutScreen(), pageRouteAnimation: PageRouteAnimation.Slide);
                },
                trailing: trailingIcon(isVersion: true),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppButton(
        text: '${language.lblLogout.toUpperCase()}',
        textStyle: boldTextStyle(color: Colors.white, size: 18),
        margin: EdgeInsets.all(16),
        elevation: 0,
        color: primaryColor,
        shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultAppButtonRadius)),
        onTap: () {
          hideKeyboard(context);
          logout(context);
        },
      ),
    );
  }
}
