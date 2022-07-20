import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

class AddCartItemComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 60,
      padding: EdgeInsets.all(16),
      decoration: boxDecorationRoundedWithShadow(8, backgroundColor: appStore.isDarkMode ? context.cardColor : primaryColor, shadowColor: appStore.isDarkMode ? context.scaffoldBackgroundColor : white),
      child: Text(language.lblAddItem, style: primaryTextStyle(color: white)).center(),
    ).onTap(() {
      finish(context);
    }).center();
  }
}
