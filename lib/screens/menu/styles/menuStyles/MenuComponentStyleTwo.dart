import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/components/VegComponent.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/screens/menu/AddMenuItemScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/userSide/components/UserAddItemComponent.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';

// ignore: must_be_immutable
class MenuComponentStyleTwo extends StatelessWidget {
  final RestaurantDetailResponse? data;
  final Menu? menuData;
  final VoidCallback? callback;
  final bool isAdmin;
  int? quantity;
  final bool? isTablet;
  final bool? isWeb;

  MenuComponentStyleTwo({this.data, this.menuData, this.callback, required this.isAdmin, this.quantity, this.isWeb, this.isTablet});

  @override
  Widget build(BuildContext context) {
    double getWidth() {
      if (isTablet.validate()) {
        return context.width() / 2;
      } else if (this.isWeb.validate()) {
        return context.width() / 4;
      }
      return context.width() / 1;
    }

    return Container(
      width: getWidth(),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: radius(defaultRadius), color: context.scaffoldBackgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  menuData!.isVeg.validate() == 1 ? VegComponent(size: 18) : NonVegComponent(size: 18),
                  10.width,
                  if (menuData!.isNew.validate() == 1)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: primaryColor.withAlpha(30), borderRadius: radius(defaultRadius)),
                      child: Text(language.lblNew.toUpperCase(), style: boldTextStyle(size: 12, color: primaryColor)),
                    ).cornerRadiusWithClipRRect(2),
                ],
              ),
              priceWidget(currency: '${data!.restaurantDetail!.currency}', price: '${menuData!.price.validate()}', style: boldTextStyle(color: primaryColor)),
            ],
          ),
          8.height,
          Text('${menuData!.name!.trim()}', style: boldTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
          8.height,
          if (!isAdmin)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Divider(thickness: 1, color: context.dividerColor),
                8.height,
                UserAddItemComponent(
                  menuData: menuData,
                  quantity: quantity,
                  callback: () {
                    callback?.call();
                  },
                ),
              ],
            ),
        ],
      ),
    ).onTap(() async {
      if (isAdmin) {
        bool? res = await push(AddMenuItemScreen(data: data, menuData: menuData), pageRouteAnimation: PageRouteAnimation.Scale, duration: 450.milliseconds);
        if (res ?? false) {
          callback?.call();
        }
      }
    }, borderRadius: radius(6)).paddingSymmetric(horizontal: 16, vertical: 8);
  }
}

class SampleMenuTwo extends StatelessWidget {
  const SampleMenuTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWeb ? context.width() / 3 : context.width() / 1,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: radius(defaultRadius), color: context.scaffoldBackgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  VegComponent(size: 18),
                  10.width,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: primaryColor.withAlpha(30), borderRadius: radius(defaultRadius)),
                    child: Text(language.lblNew.toUpperCase(), style: boldTextStyle(size: 12, color: primaryColor)),
                  ).cornerRadiusWithClipRRect(2),
                ],
              ),
              priceWidget(currency: '\$', price: '25.55', style: boldTextStyle(color: primaryColor)),
            ],
          ),
          8.height,
          Text('Italian Pizza', style: boldTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
          8.height,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Divider(thickness: 1, color: context.dividerColor),
              8.height,
              SampleAddButton(),
            ],
          ),
        ],
      ),
    );
  }
}
