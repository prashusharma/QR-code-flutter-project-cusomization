import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/GetCategoryListResponse.dart';
import 'package:qr_menu_laravel_flutter/utils/CachedNetworkImage.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

class CategoryWidget extends StatelessWidget {
  final Category? categoryData;
  final bool? isSelected;

  CategoryWidget({this.categoryData, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      width: 100,
      decoration: BoxDecoration(
        borderRadius: radius(defaultRadius),
        color: isSelected! ? primaryColor : context.cardColor,
      ),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(color: isSelected! ? context.cardColor : context.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(50)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: categoryData!.categoryImage.validate() == 'https://wordpress.iqonic.design/product/mobile/qr-menu-laravel/images/default.png'
                  ? Text(categoryData!.name.validate()[0].toUpperCase(), style: boldTextStyle(size: 20,color: appStore.isDarkMode ? Colors.white : bodyColor)).center()
                  : cachedImage(categoryData!.categoryImage, fit: BoxFit.cover),
            ),
          ),
          Marquee(
            directionMarguee: DirectionMarguee.oneDirection,
            child: Text(
              '${categoryData!.name}',
              style: boldTextStyle(size: 14, color: isSelected! ? Colors.white : context.iconColor),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ).paddingSymmetric(horizontal: 8, vertical: 8),
          )
        ],
      ),
    );
  }
}
