import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/screens/userSide/components/CartCardComponent.dart';
import 'package:qr_menu_laravel_flutter/screens/userSide/components/TipComponent.dart';
import 'package:qr_menu_laravel_flutter/utils/CachedNetworkImage.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';

class ViewCartScreen extends StatefulWidget {
  final RestaurantDetailResponse restaurantData;

  ViewCartScreen({required this.restaurantData});

  @override
  _ViewCartScreenState createState() => _ViewCartScreenState();
}

class _ViewCartScreenState extends State<ViewCartScreen> {
  List<int> tipList = [5, 10, 15, 20, 25, 30];

  int? selectedTipIndex = -1;
  double discount = 0;
  double totalAmount = 0;
  double totalTips = 0;
  int? tip = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      setStatusBarColor(context.scaffoldBackgroundColor);
    });
    totalBill();
  }

  void totalBill() {
    discount = totalCost() - (totalCost() - (totalCost() * widget.restaurantData.restaurantDetail!.discount.validate()) / 100).toDouble().abs();
    if (selectedTipIndex != -1) totalTips = ((totalCost() * tip.validate()) / 100).toDouble().abs();
    totalAmount = (totalCost() - discount + totalTips).toDouble().abs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: context.scaffoldBackgroundColor,
        appBar: appBarWidget(
          language.lblCart,
          color: context.scaffoldBackgroundColor,
          elevation: 0,
          backWidget: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: context.iconColor),
            onPressed: () {
              finish(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Divider(color: context.dividerColor, thickness: 1, indent: 16, endIndent: 16),
            if (menuStore.cartList.isNotEmpty)
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListView.builder(
                        itemCount: menuStore.cartList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          Menu? menuData = menuStore.cartList[index].menu;

                          int quantity = menuStore.cartList[index].quantity.validate();
                          return CartCardComponent(
                            quantity: quantity,
                            restaurantData: widget.restaurantData,
                            menuData: menuData,
                            callback: () {
                              totalBill();
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                    Text(language.lblTips, style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 16),
                    8.height,
                    HorizontalList(
                        itemCount: tipList.length,
                        itemBuilder: (_, i) {
                          int tips = tipList[i];
                          return TipComponent(
                            selectedTipIndex: selectedTipIndex.validate(),
                            i: i,
                            tips: tips,
                          ).onTap(() {
                            if (selectedTipIndex == i) {
                              selectedTipIndex = -1;
                              tip = 0;
                            } else {
                              selectedTipIndex = i;
                              tip = tips;
                            }
                            totalBill();
                            setState(() {});
                          });
                        }).paddingSymmetric(horizontal: 8),
                    16.height,
                  ],
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                cachedImage(AppImages.noDataImage, height: 200),
                16.height,
                Text(language.lblEmptyCart, style: boldTextStyle(size: 20)),
              ],
            ).visible(menuStore.cartList.isEmpty).center()
          ],
        ),
        bottomNavigationBar: menuStore.cartList.isNotEmpty
            ? Material(
                elevation: 20,
                color: context.scaffoldBackgroundColor,
                child: Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
                  padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${language.lblAmount}', style: secondaryTextStyle(color: bodyColor, weight: FontWeight.w600)),
                          priceWidget(
                            currency: widget.restaurantData.restaurantDetail!.currency,
                            price: totalCost().toDouble().toString(),
                            style: secondaryTextStyle(weight: FontWeight.w600),
                          ),
                        ],
                      ).paddingAll(8),
                      if (discount != 0)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('${language.lblDiscount} ', style: secondaryTextStyle(color: bodyColor, weight: FontWeight.w600)),
                                Text(
                                  '(${widget.restaurantData.restaurantDetail!.discount}%) off',
                                  style: secondaryTextStyle(color: discountColor, weight: FontWeight.w600),
                                ),
                              ],
                            ),
                            priceWidget(
                              currency: '- ${widget.restaurantData.restaurantDetail!.currency}',
                              price: '${discount.roundToDouble()}',
                              style: secondaryTextStyle(color: discountColor, weight: FontWeight.w600),
                            ),
                          ],
                        ).paddingAll(8),
                      if (selectedTipIndex != -1)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${language.lblTips} ($tip%)', style: secondaryTextStyle(color: bodyColor, weight: FontWeight.w600)),
                            priceWidget(
                              currency: '+ ${widget.restaurantData.restaurantDetail!.currency}',
                              price: '$totalTips',
                              style: secondaryTextStyle(weight: FontWeight.w600),
                            ),
                          ],
                        ).paddingAll(8),
                      8.height,
                      Divider(thickness: 1, height: 0.5, color: context.dividerColor),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language.lblTotalAmount, style: boldTextStyle()),
                          priceWidget(
                            currency: '${widget.restaurantData.restaurantDetail!.currency}',
                            price: '${totalAmount.roundToDouble()}',
                            style: boldTextStyle(size: 18, color: primaryColor),
                          ),
                        ],
                      ).paddingAll(8),
                    ],
                  ),
                ),
              )
            : Offstage(),
      ),
    );
  }
}
