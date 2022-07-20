import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

class WalkThroughContainer2 extends StatefulWidget {
  const WalkThroughContainer2({Key? key}) : super(key: key);

  @override
  _WalkThroughContainer2State createState() => _WalkThroughContainer2State();
}

class _WalkThroughContainer2State extends State<WalkThroughContainer2> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: context.height() * 0.15),
            Image.asset('images/walkthrough_two.png', height: context.height() * 0.45, width: context.width()),
            50.height,
            Text(language.lblSelectLanguage, style: boldTextStyle(size: 20)),
            16.height,
            Text(language.lblSelectLanguageDesc, style: secondaryTextStyle(color: bodyColor,size: 14), textAlign: TextAlign.center).paddingSymmetric(horizontal: 16),
          ],
        ),
      ),
    );
  }
}
