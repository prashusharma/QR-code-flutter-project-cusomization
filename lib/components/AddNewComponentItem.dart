import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

class AddNewComponentItem extends StatelessWidget {
  final void Function()? onTap;

  AddNewComponentItem({this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text('${language.lblAdd} ${language.lblNew}', style: boldTextStyle(color: primaryColor)),
    );
  }
}
