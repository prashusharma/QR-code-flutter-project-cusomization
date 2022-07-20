import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/utils/CachedNetworkImage.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';

class NoMenuComponent extends StatelessWidget {
  final String? categoryName;

  NoMenuComponent({this.categoryName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          cachedImage(AppImages.noDataImage, height: 250),
          16.height,
          Text('${language.lblNoMenuFor} ${categoryName.validate(value: "All")} ', style: boldTextStyle(size: 20)),
        ],
      ).paddingTop(80),
    ).center();
  }
}

class NoRestaurantComponent extends StatelessWidget {
  final String? errorName;

  NoRestaurantComponent({this.errorName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          cachedImage(AppImages.noDataImage, height: 200),
          16.height,
          Text(errorName ?? language.lblNoData, style: boldTextStyle(size: 20)),
        ],
      ).paddingTop(80),
    );
  }
}
