import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/screens/menu/MenuStyleScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/settings/LanguageScreen.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:share_plus/share_plus.dart';

class UserSettingScreen extends StatefulWidget {
  const UserSettingScreen({Key? key}) : super(key: key);

  @override
  _UserSettingScreenState createState() => _UserSettingScreenState();
}

class _UserSettingScreenState extends State<UserSettingScreen> {
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

  Widget trailingIcon({bool? isVersion}) {
    if (isVersion.validate()) {
      return Row(
        children: [
          SnapHelperWidget(
            future: PackageInfo.fromPlatform(),
            onSuccess: (PackageInfo snap) {
              return Text(snap.version, style: secondaryTextStyle());
            },
          ),
          8.width,
          Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
        ],
      );
    } else {
      return Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14);
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
        builder: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: context.dividerColor, thickness: 1, indent: 16, endIndent: 16),
            SettingItemWidget(
              title: language.lblDarkMode,
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              leading: Image.asset('images/icons/ic_Theme.png', height: 24, width: 24, fit: BoxFit.cover,color: appStore.isDarkMode ? context.iconColor: bodyColor),
              titleTextStyle: boldTextStyle(size: 16),
              trailing: Transform.scale(
                scale: 0.7,
                alignment: Alignment.centerRight,
                child: CupertinoSwitch(
                  value: appStore.isDarkMode,
                  onChanged: (value) {
                    appStore.setDarkMode(value);
                    setState(() {});
                  },
                  activeColor: primaryColor,
                  trackColor: context.dividerColor,
                ),
              ),
            ),
            SettingItemWidget(
              leading: Image.asset('images/icons/ic_Language.png', height: 24, width: 24, fit: BoxFit.cover,color: appStore.isDarkMode ? context.iconColor: bodyColor),
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
              leading: Image.asset('images/icons/ic_Menu_Style.png', height: 24, width: 24, fit: BoxFit.cover,color: appStore.isDarkMode ? context.iconColor: bodyColor),
              titleTextStyle: boldTextStyle(size: 16),
              onTap: () {
                MenuStyleScreen().launch(context);
              },
              trailing: trailingIcon(),
            ),
            SettingItemWidget(
              title: language.lblPrivacyPolicy,
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              leading: Image.asset('images/icons/ic_Privacy.png', height: 24, width: 24, fit: BoxFit.cover,color: appStore.isDarkMode ? context.iconColor: bodyColor),
              titleTextStyle: boldTextStyle(size: 16),
              onTap: () {
                launchUrlCustomTab(Urls.privacyPolicyURL);
              },
            ),
            SnapHelperWidget<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              onSuccess:(d) => SettingItemWidget(
                leading: Image.asset('images/icons/ic_Rate.png', height: 24, width: 24, fit: BoxFit.cover,color: appStore.isDarkMode ? context.iconColor: bodyColor),
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                titleTextStyle: boldTextStyle(size: 16),
                title: language.lblRateUs,
                onTap: () {
                  launchUrlCustomTab('$playStoreBaseURL${d.packageName}');
                },
              ),
            ),
            SettingItemWidget(
              leading: Image.asset('images/icons/ic_Help.png', height: 24, width: 24, fit: BoxFit.cover,color: appStore.isDarkMode ? context.iconColor: bodyColor),
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              titleTextStyle: boldTextStyle(size: 16),
              title: language.lblHelpSupport,
              onTap: () {
                launchUrlCustomTab(Urls.termsAndConditionURL);
              },
            ),
            SettingItemWidget(
              leading: Image.asset('images/icons/ic_share.png', height: 24, width: 24, fit: BoxFit.cover,color: appStore.isDarkMode ? context.iconColor: bodyColor),
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              titleTextStyle: boldTextStyle(size: 16),
              title: language.lblShare,
              onTap: () {
                Share.share(
                  'Share ${AppConstant.appName} app\n\n${AppConstant.appDescription}',
                );
              },
            ),
            16.height,
          ],
        ),
      ),
    );
  }
}
