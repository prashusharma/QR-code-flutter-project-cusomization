import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';

// ignore: must_be_immutable
class UserViewCartBottomNavComponent extends StatefulWidget {
  RestaurantDetailResponse? restaurantData;

  UserViewCartBottomNavComponent({this.restaurantData});

  @override
  _UserViewCartBottomNavComponentState createState() => _UserViewCartBottomNavComponentState();
}

class _UserViewCartBottomNavComponentState extends State<UserViewCartBottomNavComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: primaryColor, borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius)),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${totalItems()} ${language.lblItemsInCart}.', style: primaryTextStyle(color: Colors.white)),
              priceWidget(currency: '${widget.restaurantData!.restaurantDetail!.currency}', price: '${totalCost().toDouble()}', style: boldTextStyle(color: Colors.white)),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(8)),
            child: Text(language.lblViewCart, style: boldTextStyle(color: context.iconColor)),
          ),
        ],
      ),
    );
  }
}
