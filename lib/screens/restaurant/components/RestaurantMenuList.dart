import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/components/AddNewComponentItem.dart';
import 'package:qr_menu_laravel_flutter/components/NoDataComponent.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/MenuCategoryModel.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/screens/category/component/CategoryItemWidget.dart';
import 'package:qr_menu_laravel_flutter/screens/menu/AddMenuItemScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/menu/styles/categoryStyles/MenuListCategoryComponent.dart';
import 'package:qr_menu_laravel_flutter/utils/GetStyleWidget.dart';

class RestaurantMenuList extends StatefulWidget {
  final bool isAdmin;
  final RestaurantDetailResponse? data;
  final VoidCallback? callback;

  RestaurantMenuList({this.isAdmin = false, this.data, this.callback});

  @override
  _RestaurantMenuListState createState() => _RestaurantMenuListState();
}

class _RestaurantMenuListState extends State<RestaurantMenuList> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await 2.milliseconds.delay;
    appStore.setIsAll(true);
    menuStore.setSelectedCategoryData(null);
  }

  double getMainAxisExtent() {
    if (appStore.selectedMenuStyle == language.lblMenuStyle1) {
      return 220;
    } else if (appStore.selectedMenuStyle == language.lblMenuStyle2) {
      return 150;
    } else if (appStore.selectedMenuStyle == language.lblMenuStyle3) {
      return 180;
    } else {
      return 220;
    }
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Divider(color: context.dividerColor, indent: 16, endIndent: 16, thickness: 1),
            16.height,
            CategoryItemWidget(
              isAdmin: widget.isAdmin,
              categories: widget.data!.category.validate(),
              restaurantId: widget.data!.restaurantDetail!.id.validate(),
              callback: () {
                widget.callback?.call();
              },
            ),
            16.height,
            Row(
              children: [
                Text(
                  language.lblMenuItems,
                  style: boldTextStyle(size: 20, color: context.iconColor),
                ).expand(),
                if (widget.isAdmin)
                  AddNewComponentItem(onTap: () async {
                    await push(AddMenuItemScreen(data: widget.data));
                    widget.callback?.call();
                  }),
              ],
            ).paddingSymmetric(horizontal: 16),
            16.height,
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
                          MenuListCategoryComponent(
                              categoryData: menuCatData.category!,
                              isAdmin: widget.isAdmin,
                              callback: () {
                                widget.callback?.call();
                              }),
                          Responsive(
                            mobile: Wrap(
                              alignment: WrapAlignment.start,
                              children: List.generate(menuCatData.menu.validate().length, (i) {
                                Menu menuData = menuCatData.menu.validate()[i].menu!;
                                return getMenuComponentWidget(
                                  isAdmin: widget.isAdmin,
                                  callback: () {
                                    widget.callback!.call();
                                  },
                                  menuData: menuData,
                                  data: menuCatData,
                                  detailResponse: widget.data,
                                  index: i,
                                );
                              }),
                            ),
                            web: GridView.builder(
                              itemBuilder: (BuildContext context, int i) {
                                Menu menuData = menuCatData.menu.validate()[i].menu!;
                                return getMenuComponentWidget(
                                  isAdmin: widget.isAdmin,
                                  callback: () {
                                    widget.callback!.call();
                                  },
                                  menuData: menuData,
                                  data: menuCatData,
                                  detailResponse: widget.data,
                                  index: i,
                                );
                              },
                              itemCount: menuCatData.menu.validate().length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 16,
                                mainAxisExtent: getMainAxisExtent(),
                              ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                            ),
                          ),
                        ],
                      ).paddingSymmetric(vertical: 16),
                    );
                  },
                ),
                NoMenuComponent(categoryName: menuStore.selectedCategoryData?.name.validate()).center().visible(appStore.menuListByCategory.isEmpty && !appStore.isLoading),
                Loader().center().visible(appStore.isLoading),
              ],
            ),
          ],
        ),
      ).visible(!appStore.isLoading),
    );
  }
}
