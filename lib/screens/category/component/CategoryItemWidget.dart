import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/components/AddNewComponentItem.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/GetCategoryListResponse.dart';
import 'package:qr_menu_laravel_flutter/screens/category/AddCategoryScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/category/component/CategoryListView.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

class CategoryItemWidget extends StatefulWidget {
  final List<Category> categories;
  final bool isAdmin;
  final int? restaurantId;
  final VoidCallback? callback;

  CategoryItemWidget({required this.categories, required this.isAdmin, this.restaurantId, this.callback});

  @override
  _CategoryItemWidgetState createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<CategoryItemWidget> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${language.lblCategories} (${widget.categories.length.validate()})', style: boldTextStyle(size: 20)),
            if (widget.isAdmin)
              AddNewComponentItem(onTap: () async {
                bool? res = await push(AddCategoryScreen(restaurantId: widget.restaurantId.validate()));
                if (res ?? false) {
                  widget.callback?.call();
                }
              }),
          ],
        ).paddingSymmetric(horizontal: 16),
        8.height,
        Container(
          width: context.width(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    selectedIndex = -1;
                    menuStore.setSelectedCategoryData(null);
                    appStore.setIsAll(true);
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: radius(defaultRadius),
                      color: selectedIndex == -1 ? primaryColor : context.cardColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(color: selectedIndex == -1 ? context.cardColor : context.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(50)),
                          child: Text("${language.lblA}", style: boldTextStyle(size: 20,color: appStore.isDarkMode ? Colors.white : bodyColor)).center(),
                        ),
                        Text(
                          language.lblAll,
                          style: boldTextStyle(size: 16, color: selectedIndex == -1 ? Colors.white : context.iconColor),
                          textAlign: TextAlign.center,
                        ).paddingSymmetric(horizontal: 8, vertical: 8)
                      ],
                    ),
                  ),
                ).paddingOnly(top: 8, right: 8, bottom: 8),
                CategoryListView(
                  categories: widget.categories,
                  selectedIndex: selectedIndex,
                  isAdmin: widget.isAdmin,
                  onCategoryChanged: (index) {
                    selectedIndex = index;
                    setState(() {});
                  },
                  callback: () {
                    widget.callback?.call();
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
          ),
        ).visible(widget.categories.isNotEmpty),
        Text(language.lblNoCategory).visible(widget.categories.isEmpty).center()
      ],
    );
  }
}
