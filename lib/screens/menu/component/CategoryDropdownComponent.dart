import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/GetCategoryListResponse.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';

class CategoryDropdownComponent extends StatefulWidget {
  final Category? defaultValue;
  final Function(Category value) onValueChanged;
  final bool isValidate;
  final List<Category>? categoryData;

  CategoryDropdownComponent({this.defaultValue, required this.onValueChanged, required this.isValidate, this.categoryData});

  @override
  _CategoryDropdownComponentState createState() => _CategoryDropdownComponentState();
}

class _CategoryDropdownComponentState extends State<CategoryDropdownComponent> {
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
    return DropdownButtonFormField<Category>(
      onChanged: (value) {
        widget.onValueChanged.call(value!);
      },
      value: widget.defaultValue,
      isExpanded: true,
      validator: widget.isValidate
          ? (c) {
              if (c == null) return errorThisFieldRequired;
              return null;
            }
          : null,
      decoration: inputDecoration(context, label: '${language.lblChooseCategory}').copyWith(
        prefixIcon: Image.asset('images/icons/ic_Category.png', height: 12, width: 12, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
      ),
      dropdownColor: context.cardColor,
      alignment: Alignment.bottomCenter,
      items: List.generate(
        widget.categoryData!.length,
        (index) {
          Category data = widget.categoryData![index];
          return DropdownMenuItem(
            value: data,
            child: Container(
              child: Text('${data.name.validate()}', style: primaryTextStyle()),
            ),
          );
        },
      ),
    );
  }
}
