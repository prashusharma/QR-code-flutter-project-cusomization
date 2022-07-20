import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/GetCategoryListResponse.dart';
import 'package:qr_menu_laravel_flutter/screens/category/AddCategoryScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/category/component/CategoryWidget.dart';

class CategoryListView extends StatefulWidget {
  final List<Category> categories;
  final bool isAdmin;
  final Function(int) onCategoryChanged;
  final int selectedIndex;
  final VoidCallback? callback;

  CategoryListView({required this.categories, required this.onCategoryChanged, required this.isAdmin, required this.selectedIndex, this.callback});

  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  @override
  void initState() {
    super.initState();
  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return HorizontalList(
      physics: NeverScrollableScrollPhysics(),
      spacing: 16,
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        Category categoryData = widget.categories[index];
        bool isSelected = widget.selectedIndex == index;

        return GestureDetector(
          onTap: () {
            appStore.setIsAll(false);
            widget.onCategoryChanged.call(index);
            menuStore.setSelectedCategoryData(widget.categories[index]);
            setState(() {});
          },
          onLongPress: () async {
            if (widget.isAdmin) {
              await AddCategoryScreen(categoryData: categoryData).launch(context);
              widget.callback?.call();
            }
          },
          child: CategoryWidget(categoryData: categoryData, isSelected: isSelected),
        );
      },
    );
  }
}
