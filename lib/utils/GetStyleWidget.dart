import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/MenuCategoryModel.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/qr/qrStyle/QrComponentStyleOne.dart';
import 'package:qr_menu_laravel_flutter/qr/qrStyle/QrComponentStyleThree.dart';
import 'package:qr_menu_laravel_flutter/qr/qrStyle/QrComponentStyleTwo.dart';
import 'package:qr_menu_laravel_flutter/screens/menu/styles/menuStyles/MenuComponentStyleOne.dart';
import 'package:qr_menu_laravel_flutter/screens/menu/styles/menuStyles/MenuComponentStyleThree.dart';
import 'package:qr_menu_laravel_flutter/screens/menu/styles/menuStyles/MenuComponentStyleTwo.dart';

Widget getMenuComponentWidget({
  RestaurantDetailResponse? detailResponse,
  MenuCategoryModel? data,
  VoidCallback? callback,
  Menu? menuData,
  required bool isAdmin,
  int? index,
  int? quantity,
  String? currency,
}) {
  if (appStore.selectedMenuStyle == 'Style 1') {
    return MenuComponentStyleOne(
      quantity: quantity,
      isAdmin: isAdmin,
      menuData: menuData,
      detailResponse: detailResponse,
      callback: () {
        callback?.call();
      },
      currency: detailResponse!.restaurantDetail!.currency,
    );
  } else if (appStore.selectedMenuStyle == 'Style 2') {
    return MenuComponentStyleTwo(
        quantity: quantity,
        isAdmin: isAdmin,
        data: detailResponse,
        menuData: menuData,
        callback: () {
          callback?.call();
        });
  } else if (appStore.selectedMenuStyle == 'Style 3') {
    return MenuComponentStyleThree(
      isLast: index == (data!.menu.validate().length - 1) ? true : false,
      data: detailResponse,
      menuData: menuData,
      callback: () {
        callback?.call();
      },
      isAdmin: isAdmin,
      quantity: quantity,
    );
  } else {
    return MenuComponentStyleOne(
      quantity: quantity,
      isAdmin: isAdmin,
      menuData: menuData,
      detailResponse: detailResponse,
      callback: () {
        callback?.call();
      },
      currency: detailResponse!.restaurantDetail!.currency,
    );
  }
}

Widget getQrStyleWidget(bool isTesting, GlobalKey<State<StatefulWidget>> qrKey, String saveUrl, RestaurantDetail? restaurantDetail) {
  if (appStore.selectedQrStyle == language.lblQrStyle2) {
    return QrComponentStyleTwo(isTesting: isTesting, qrKey: qrKey, saveUrl: saveUrl, restaurantDetail: restaurantDetail);
  } else if (appStore.selectedQrStyle == language.lblQrStyle3) {
    return QrComponentStyleThree(isTesting: isTesting, qrKey: qrKey, saveUrl: saveUrl, restaurantDetail: restaurantDetail);
  } else {
    return QrComponentStyleOne(isTesting: isTesting, qrKey: qrKey, saveUrl: saveUrl, restaurantDetail: restaurantDetail);
  }
}

Widget getSampleMenu(BuildContext context) {
  if (appStore.selectedMenuStyle == 'Style 2') {
    log('if...');
    return SampleMenuTwo();
  } else if (appStore.selectedMenuStyle == 'Style 3') {
    return SampleMenuThree();
  } else {
    return SampleMenuOne();
  }
}

Widget getSampleQrStyle() {
  if (appStore.selectedQrStyle == language.lblQrStyle2) {
    return SampleQrStyleTwo();
  } else if (appStore.selectedQrStyle == language.lblQrStyle3) {
    return SampleQrStyleThree();
  }
  return SampleQrStyleOne();
}
