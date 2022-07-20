import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/components/NoDataComponent.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/MenuCategoryModel.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/network/RestApis.dart';
import 'package:qr_menu_laravel_flutter/screens/menu/styles/categoryStyles/MenuListCategoryComponent.dart';
import 'package:qr_menu_laravel_flutter/screens/userSide/UserSettingScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/userSide/ViewCartScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/userSide/components/UserCategoryListComponent.dart';
import 'package:qr_menu_laravel_flutter/screens/userSide/components/UserViewCartBottomNavComponent.dart';
import 'package:qr_menu_laravel_flutter/utils/CachedNetworkImage.dart';
import 'package:qr_menu_laravel_flutter/utils/GetStyleWidget.dart';

class UserMenuListingScreen extends StatefulWidget {
  final String? id;

  UserMenuListingScreen({this.id});

  @override
  _UserMenuListingScreenState createState() => _UserMenuListingScreenState();
}

class _UserMenuListingScreenState extends State<UserMenuListingScreen> {
  RestaurantDetailResponse? restaurantData = RestaurantDetailResponse();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() async {
      setStatusBarColor(context.scaffoldBackgroundColor);
      await restaurantDetail();
    });
  }

  Future<void> restaurantDetail() async {
    appStore.setLoading(true);
    await getRestaurantDetail(restaurantId: widget.id!.toInt().validate()).then((value) {
      restaurantData = value;
      menuListMain = restaurantData!.menu.validate();
      menuStore.setSelectedCategoryData(null);
      appStore.setIsAll(true);

      setState(() {});
    }).catchError((e) {
      log(e.toString());
    }).whenComplete(() {
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        restaurantData!.toJson().isNotEmpty ? '${restaurantData!.restaurantDetail!.name.validate()}' : '',
        color: context.scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              push(UserSettingScreen(), pageRouteAnimation: PageRouteAnimation.SlideBottomTop).then((value) {
                setState(() {});
              });
            },
            icon: Image.asset('images/icons/ic_Setting.png', height: 24, width: 24, color: context.iconColor),
          ),
        ],
        backWidget: cachedImage(
          restaurantData!.toJson().isNotEmpty ? '${restaurantData!.restaurantDetail!.restaurantLogo.validate()}' : '',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ).cornerRadiusWithClipRRect(defaultRadius).paddingAll(8),
        elevation: 0.5,
      ),
      body: restaurantData!.toJson().isEmpty
          ? Loader()
          : Observer(
              builder: (_) => Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 60, top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        UserCategoryListComponent(restaurantData: restaurantData),
                        Stack(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: appStore.isAll ? appStore.menuListByCategory.length : appStore.menuListByCategory.take(1).length,
                              itemBuilder: (_, i) {
                                MenuCategoryModel menuCatData = appStore.menuListByCategory[i];
                                return Container(
                                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
                                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MenuListCategoryComponent(categoryData: menuCatData.category!, isAdmin: false),
                                      Wrap(
                                        alignment: WrapAlignment.start,
                                        children: List.generate(menuCatData.menu!.length, (i) {
                                          Menu? menuData = menuCatData.menu![i].menu;

                                          int quantity = 0;
                                          menuStore.cartList.forEach((element) {
                                            if (element.menu == menuData) {
                                              quantity = element.quantity.validate();
                                            }
                                          });

                                          return getMenuComponentWidget(
                                            isAdmin: false,
                                            callback: () {
                                              setState(() {});
                                            },
                                            quantity: quantity,
                                            menuData: menuData,
                                            data: menuCatData,
                                            detailResponse: restaurantData,
                                            index: i,
                                          );
                                        }),
                                      )
                                    ],
                                  ).paddingSymmetric(vertical: 8),
                                );
                              },
                            ),
                            NoMenuComponent(categoryName: menuStore.selectedCategoryData?.name.validate()).center().visible(restaurantData!.menu!.isEmpty && !appStore.isLoading),
                            Loader().center().visible(appStore.isLoading),
                          ],
                        ),
                      ],
                    ),
                  ).visible(!appStore.isLoading),
                  Loader().center().visible(appStore.isLoading),
                ],
              ),
            ),
      bottomNavigationBar: menuStore.cartList.isNotEmpty
          ? UserViewCartBottomNavComponent(restaurantData: restaurantData).onTap(() {
              ViewCartScreen(restaurantData: restaurantData!).launch(context).then((value) {
                setState(() {});
              });
            })
          : Offstage(),
    );
  }
}
