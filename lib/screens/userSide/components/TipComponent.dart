import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

// ignore: must_be_immutable
class TipComponent extends StatelessWidget {
  int selectedTipIndex;
  int i;
  int tips;

  TipComponent({required this.selectedTipIndex, required this.i, required this.tips});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selectedTipIndex != i ?  context.cardColor :  primaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.all(6),
      child: Text(
        '$tips%',
        style: boldTextStyle(
          size: 14,
          color: selectedTipIndex != i
              ? appStore.isDarkMode
                  ? white
                  : bodyColor
              : white,
        ),
      ).paddingOnly(left: 8, right: 8),
    );
  }
}
