import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/components/VegComponent.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/GetCategoryListResponse.dart';
import 'package:qr_menu_laravel_flutter/models/GetRestaurantListResponse.dart';
import 'package:qr_menu_laravel_flutter/screens/restaurant/RestaurantDetailScreen.dart';
import 'package:qr_menu_laravel_flutter/utils/CachedNetworkImage.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

class RestaurantCardComponent extends StatefulWidget {
  final Restaurant data;
  final VoidCallback? callback;

  RestaurantCardComponent({required this.data, this.callback});

  @override
  State<RestaurantCardComponent> createState() => _RestaurantCardComponentState();
}

class _RestaurantCardComponentState extends State<RestaurantCardComponent> {
  List<Category> categoryList = [];

  @override
  void initState() {
    super.initState();
  }

  Widget checkRestaurantType({required int isVeg, required int isNonVeg}) {
    double size = 16;
    if (isNonVeg == 1 && isVeg == 1) {
      return Row(
        children: [
          VegComponent(size: size),
          8.width,
          NonVegComponent(size: size),
        ],
      );
    } else if (isVeg == 1) {
      return VegComponent(size: size);
    } else if (isNonVeg == 1) {
      return NonVegComponent(size: size);
    } else {
      return Offstage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              widget.data.restaurantImage!.isNotEmpty
                  ? cachedImage(
                      widget.data.restaurantImage!.first.url.validate(),
                      height: 160,
                      width: context.width(),
                      fit: BoxFit.cover,
                    ).cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), topLeft: defaultRadius.toInt())
                  : cachedImage(
                      '',
                      height: 160,
                      width: context.width(),
                      fit: BoxFit.cover,
                    ).cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), topLeft: defaultRadius.toInt()),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(borderRadius: radius(50), color: context.cardColor),
                  child: checkRestaurantType(isVeg: widget.data.isVeg.validate(), isNonVeg: widget.data.isNonVeg.validate()),
                ),
              ),
            ],
          ),
          8.height,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.data.name.validate()}',
                style: boldTextStyle(size: 20, color: appStore.isDarkMode ? Colors.white : headingColor),
              ),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${language.lblCategory.capitalizeFirstLetter()}:', style: primaryTextStyle(size: 16, color: bodyColor)),
                  Text('${widget.data.categoryCount.validate()}', style: boldTextStyle(size: 16)),
                ],
              ),
              Divider(color: context.dividerColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${language.lblMenuItems}:', style: primaryTextStyle(size: 16, color: bodyColor)),
                  Text('${widget.data.menuCount.validate()}', style: boldTextStyle(size: 16)),
                ],
              ),
              8.height,
            ],
          ).paddingAll(16),
        ],
      ),
    ).onTap(
      () async {
        await push(
          RestaurantDetailScreen(data: widget.data, restaurantId: widget.data.id.validate(), callback: () {}),
          pageRouteAnimation: PageRouteAnimation.Slide,
        ).then((value) {
          widget.callback?.call();
        });
      },
      borderRadius: radius(defaultRadius),
    );
  }
}
