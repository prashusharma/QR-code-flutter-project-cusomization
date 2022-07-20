import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/screens/category/component/CategoryItemWidget.dart';

// ignore: must_be_immutable
class UserCategoryListComponent extends StatelessWidget {
  RestaurantDetailResponse? restaurantData;

  UserCategoryListComponent({this.restaurantData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryItemWidget(
          isAdmin: false,
          categories: restaurantData!.category.validate(),
          restaurantId: restaurantData!.restaurantDetail!.id.validate(),
          callback: () {
            //
          },
        ),
        Text(
          language.lblMenuItems,
          style: boldTextStyle(size: 20, color: context.iconColor),
        ).paddingOnly(left: 16, right: 16, top: 16),
      ],
    );
  }
}
