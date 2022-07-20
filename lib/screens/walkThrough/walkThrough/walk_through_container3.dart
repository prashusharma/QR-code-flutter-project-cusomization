import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

class WalkThroughContainer3 extends StatefulWidget {
  const WalkThroughContainer3({Key? key}) : super(key: key);

  @override
  _WalkThroughContainer3State createState() => _WalkThroughContainer3State();
}

class _WalkThroughContainer3State extends State<WalkThroughContainer3> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: context.height() * 0.15),
            Image.asset('images/walkthrough_three.png', height: context.height() * 0.45, width: context.width()),
            50.height,
            Text(language.lblSelectTheme, style: boldTextStyle(size: 20)),
            16.height,
            Text(language.lblSelectThemeDesc, style: secondaryTextStyle(color: bodyColor, size: 14), textAlign: TextAlign.center).paddingSymmetric(horizontal: 16),
          ],
        ),
      ),
    );
  }
}
