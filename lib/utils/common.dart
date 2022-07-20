import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:html/parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/MenuCategoryModel.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', subTitle: 'English', languageCode: 'en', fullLanguageCode: 'en_en-US', flag: 'images/flag/ic_us.png'),
    LanguageDataModel(id: 2, name: 'Hindi', subTitle: 'हिंदी', languageCode: 'hi', fullLanguageCode: 'hi_hi-IN', flag: 'images/flag/ic_india.png'),
    LanguageDataModel(id: 3, name: 'Arabic', subTitle: 'عربي', languageCode: 'ar', fullLanguageCode: 'ar_ar-AR', flag: 'images/flag/ic_ar.png'),
  ];
}

InputDecoration inputDecoration(BuildContext context, {String? hint, String? label, TextStyle? textStyle, Widget? prefix, EdgeInsetsGeometry? contentPadding, Widget? prefixIcon}) {
  return InputDecoration(
    contentPadding: contentPadding,
    labelText: label,
    hintText: hint,
    hintStyle: textStyle ?? secondaryTextStyle(),
    labelStyle: textStyle ?? secondaryTextStyle(),
    prefix: prefix,
    prefixIcon: prefixIcon,
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: Colors.red, width: 1.0)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: Colors.red, width: 1.0)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(width: 1.0, color: context.dividerColor)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(width: 1.0, color: context.dividerColor)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(defaultRadius), borderSide: BorderSide(color: primaryColor, width: 1.0)),
    alignLabelWithHint: true,
  );
}

Future<File> getImageSource({bool isCamera = true}) async {
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
  return File(pickedImage!.path);
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

Future<List<File>> getMultipleFile() async {
  FilePickerResult? filePickerResult;
  List<File> imgList = [];
  filePickerResult = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);

  if (filePickerResult != null) {
    imgList = filePickerResult.paths.map((path) => File(path!)).toList();
  }
  return imgList;
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

void reduceFromCart({required int quantity, required Menu menuData, Function? set}) {
  menuStore.cartList.forEach((element) {
    if (quantity > 0 && element.menu == menuData) {
      element.quantity = quantity;
    } else if (quantity == 0) {
      QuantityMenuModel data = menuStore.cartList.firstWhere((element) => element.menu == menuData);
      menuStore.cartList.remove(data);
    }
  });
}

void launchUrlCustomTab(String? url) {
  if (url.validate().isNotEmpty) {
    try {
      launch(
        url!,
        customTabsOption: CustomTabsOption(
          enableDefaultShare: true,
          enableInstantApps: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          toolbarColor: primaryColor,
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } on Exception catch (e) {
      log('Error : $e');
    }
  }
}

void addToCart({required int quantity, required Menu menuData}) {
  if (menuStore.cartList.isEmpty) {
    menuStore.setCartList(menuData, quantity);
  } else {
    if (menuStore.cartList.any((element) => element.menu == menuData)) {
      QuantityMenuModel data = menuStore.cartList.firstWhere((element) => element.menu == menuData);
      data.quantity = quantity;
    } else {
      menuStore.setCartList(menuData, quantity);
    }
  }
}

int totalItems() {
  int itemCount = 0;
  menuStore.cartList.forEach((element) {
    itemCount = itemCount + element.quantity.validate();
  });
  return itemCount;
}

int totalCost() {
  int totalCost = 0;
  menuStore.cartList.forEach((element) {
    totalCost = totalCost + (element.quantity.validate() * element.menu!.price.validate());
  });

  return totalCost;
}

Widget priceWidget({TextStyle? style,String? price,String? currency}){
  return Text('$currency$price',style: style);
}