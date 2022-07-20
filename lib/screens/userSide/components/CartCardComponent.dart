import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/components/VegComponent.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/MenuCategoryModel.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/screens/userSide/components/UserAddItemComponent.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';

class CartCardComponent extends StatefulWidget {
  final Menu? menuData;
  final RestaurantDetailResponse restaurantData;
  final int quantity;
  final VoidCallback? callback;

  CartCardComponent({this.menuData, required this.restaurantData, required this.quantity, this.callback});

  @override
  State<CartCardComponent> createState() => _CartCardComponentState();
}

class _CartCardComponentState extends State<CartCardComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
      decoration: BoxDecoration(borderRadius: radius(defaultRadius), color: context.scaffoldBackgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  widget.menuData!.isVeg.validate() == 1 ? VegComponent(size: 18) : NonVegComponent(size: 18),
                  10.width,
                  if (widget.menuData!.isNew.validate() == 1)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: primaryColor.withAlpha(30), borderRadius: radius(defaultRadius)),
                      child: Text(language.lblNew.toUpperCase(), style: boldTextStyle(size: 12, color: primaryColor)),
                    ).cornerRadiusWithClipRRect(2),
                ],
              ),
              priceWidget(
                currency: '${widget.restaurantData.restaurantDetail!.currency}',
                price: '${widget.menuData!.price.validate()}',
                style: boldTextStyle(color: primaryColor),
              ),
            ],
          ),
          8.height,
          Text('${widget.menuData!.name!.trim()}', style: boldTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
          4.height,
          Text('${widget.menuData!.ingredient.validate()}', style: secondaryTextStyle(size: 12, color: bodyColor)),
          8.height,
          Divider(thickness: 1, color: context.dividerColor),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserAddItemComponent(
                menuData: widget.menuData,
                quantity: widget.quantity,
                callback: () {
                  widget.callback?.call();
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(borderRadius: radius(8), color: headingColor),
                child: Icon(Icons.delete_outline, color: Colors.white),
              ).onTap(() {
                QuantityMenuModel data = menuStore.cartList.firstWhere((element) => element.menu == widget.menuData);
                menuStore.cartList.remove(data);
                widget.callback?.call();
              })
            ],
          ),
        ],
      ),
    );
  }
}
