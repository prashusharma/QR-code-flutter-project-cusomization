import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/screens/auth/SignInScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/restaurant/DashboardScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/walkThrough/walk_through_screen.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      appStore.setLanguage(getStringAsync(SharePreferencesKey.Language, defaultValue: AppConstant.defaultLanguage), context: context);
      setStatusBarColor(context.scaffoldBackgroundColor);
    });
    await 2.seconds.delay;

    if (getBoolAsync(SharePreferencesKey.IS_WALKED_THROUGH)) {
      if (getBoolAsync(SharePreferencesKey.IS_LOGGED_IN)) {
        DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      } else {
        SignInScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Scale, isNewTask: true, duration: 450.milliseconds);
      }
    } else {
      WalkThroughScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }
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
