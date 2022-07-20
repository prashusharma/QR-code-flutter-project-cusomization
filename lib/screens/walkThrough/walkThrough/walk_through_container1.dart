import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';


class WalkThroughContainer1 extends StatefulWidget {
  @override
  _WalkThroughContainer1State createState() => _WalkThroughContainer1State();
}

class _WalkThroughContainer1State extends State<WalkThroughContainer1> {
  bool button = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: context.height() * 0.15),
            Image.asset('images/walkthrough_one.png', height: context.height() * 0.45, width: context.width()),
            50.height,
            Text(language.lblGoPaperless, style: boldTextStyle(size: 20)),
            16.height,
            Text(language.lblGoPaperlessWithOurDigitalMenu, style: secondaryTextStyle(size: 14,color: bodyColor), textAlign: TextAlign.center).paddingSymmetric(horizontal: 16),
          ],
        ),
      ),
    );
  }
}
