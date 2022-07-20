import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/screens/userSide/UserMenuListingScreen.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';

class UserSplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  final String? result;

  UserSplashScreen({this.result});

  @override
  _UserSplashScreenState createState() => _UserSplashScreenState();
}

class _UserSplashScreenState extends State<UserSplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() async {
      appStore.setLanguage(getStringAsync(SharePreferencesKey.Language, defaultValue: AppConstant.defaultLanguage), context: context);
    });
    await 5.seconds.delay;
    UserMenuListingScreen(id: widget.result.validate()).launch(context, isNewTask: true);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: context.height(),
        width: context.width(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/qr-menu.png', height: 150, width: 150),
            16.height,
            Text(AppConstant.appName, style: boldTextStyle(size: 24)),
          ],
        ),
      ).center(),
    );
  }
}
