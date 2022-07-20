import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/screens/auth/SignInScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/walkThrough/walkThrough/walk_through_container1.dart';
import 'package:qr_menu_laravel_flutter/screens/walkThrough/walkThrough/walk_through_container2.dart';
import 'package:qr_menu_laravel_flutter/screens/walkThrough/walkThrough/walk_through_container3.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';

class WalkThroughScreen extends StatefulWidget {
  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController pageController = PageController(initialPage: 0);
  int currentPageIndex = 0;

  List<Widget> data = [];

  @override
  void initState() {
    super.initState();
    setStatusBarColor(primaryColor);
    init();
  }

  Future<void> init() async {
    data.add(WalkThroughContainer1());
    data.add(WalkThroughContainer3());
    data.add(WalkThroughContainer2());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                height: context.height() * 0.54,
                width: context.width(),
                color: primaryColor,
              ),
            ],
          ),
          PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              currentPageIndex = index;
              setState(() {});
            },
            itemCount: 3,
            itemBuilder: (context, index) {
              if (index == 0) {
                return WalkThroughContainer1();
              } else if (index == 1) {
                return WalkThroughContainer2();
              } else {
                return WalkThroughContainer3();
              }
            },
          ),
          Positioned(
            bottom: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < data.length; i++)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: i == currentPageIndex ? 24 : 6,
                        decoration: BoxDecoration(
                          color: i == currentPageIndex ? primaryColor : primaryColor.withOpacity(0.5),
                          borderRadius: radius(12),
                        ),
                      ),
                  ],
                ),
                24.height,
                AnimatedCrossFade(
                  sizeCurve: Curves.bounceOut,
                  crossFadeState: currentPageIndex == 2 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 550),
                  firstChild: Text('${language.lblSkip}'.toUpperCase(), style: boldTextStyle(size: 18)).onTap(() async {
                    setValue(SharePreferencesKey.IS_WALKED_THROUGH, true);

                    SignInScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Scale, duration: 450.milliseconds);
                  }, borderRadius: radius()),
                  secondChild: Text(language.lblGetStarted.toUpperCase(), style: boldTextStyle(size: 18)).onTap(() {
                    setValue(SharePreferencesKey.IS_WALKED_THROUGH, true);

                    SignInScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Scale, duration: 450.milliseconds);
                  }, borderRadius: radius()),
                ),
                16.height,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
