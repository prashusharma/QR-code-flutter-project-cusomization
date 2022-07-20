import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/utils/CachedNetworkImage.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

class QrComponentStyleThree extends StatelessWidget {
  final RestaurantDetail? restaurantDetail;
  final GlobalKey qrKey;
  final String saveUrl;
  final bool isTesting;

  QrComponentStyleThree({required this.isTesting, required this.qrKey, required this.saveUrl, this.restaurantDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 32, left: 16, right: 16, top: 32),
      width: context.width(),
      decoration: boxDecorationDefault(borderRadius: radiusOnly(bottomRight: 200, bottomLeft: 200), color: context.scaffoldBackgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          30.height,
          Text(
            language.lblScanForOurOnlineMenu,
            textAlign: TextAlign.center,
            style: primaryTextStyle(size: 16),
          ),
          16.height,
          RepaintBoundary(
              key: qrKey,
              child: QrImage(
                padding: EdgeInsets.all(16),
                dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle),
                backgroundColor: appStore.isDarkMode ? Colors.white : primaryColor.withAlpha(20),
                version: 4,
                data: isTesting ? restaurantDetail!.id.toString().validate() : saveUrl,
                size: 220,
                foregroundColor: Colors.black,
                errorStateBuilder: (cxt, err) {
                  return Text("${language.lblUhOhSomethingWentWrong}", textAlign: TextAlign.center).center();
                },
              ).cornerRadiusWithClipRRect(defaultRadius)),
          16.height,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              (restaurantDetail!.restaurantLogo.isEmptyOrNull)
                  ? Offstage()
                  : cachedImage(
                      restaurantDetail!.restaurantLogo.validate(),
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ).cornerRadiusWithClipRRect(80),
              8.width,
              Text(
                "${restaurantDetail!.name.validate()}",
                textAlign: TextAlign.center,
                style: boldTextStyle(size: 30, fontFamily: GoogleFonts.gloriaHallelujah().fontFamily),
              ),
            ],
          ),
          60.height,
        ],
      ),
    );
  }
}

class SampleQrStyleThree extends StatelessWidget {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: qrKey,
      child: QrImage(
        dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle),
        backgroundColor: appStore.isDarkMode ? Colors.white : Colors.transparent,
        version: 4,
        data: 'https://www.google.com/',
        size: 200,
        foregroundColor: Colors.black,
        errorStateBuilder: (cxt, err) {
          return Text("${language.lblUhOhSomethingWentWrong}", textAlign: TextAlign.center).center();
        },
      ),
    );
  }
}
