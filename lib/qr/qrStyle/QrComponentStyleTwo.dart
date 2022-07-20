import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';

class QrComponentStyleTwo extends StatelessWidget {
  final RestaurantDetail? restaurantDetail;
  final GlobalKey qrKey;
  final String saveUrl;
  final bool isTesting;

  QrComponentStyleTwo({required this.isTesting, required this.qrKey, required this.saveUrl, this.restaurantDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      padding: EdgeInsets.only(bottom: 32, left: 16, right: 16, top: 32),
      width: context.width() - 32,
      decoration: boxDecorationDefault(borderRadius: radius(16), color: context.cardColor, border: Border.all(color: context.dividerColor, width: 3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            key: qrKey,
            child: QrImage(
              version: 4,
              eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.circle),
              dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle),
              data: isTesting ? restaurantDetail!.id.toString().validate() : saveUrl,
              size: 250,
              backgroundColor: appStore.isDarkMode ? Colors.white : Colors.transparent,
              foregroundColor: Colors.black,
              errorStateBuilder: (cxt, err) {
                return Text("${language.lblUhOhSomethingWentWrong}", textAlign: TextAlign.center).center();
              },
            ),
          ),
          16.height,
          Text(
            language.lblScanForOurOnlineMenu,
            textAlign: TextAlign.center,
            style: primaryTextStyle(size: 20),
          ),
          16.height,
          Text(
            "${restaurantDetail!.name.validate()}",
            textAlign: TextAlign.center,
            style: boldTextStyle(size: 36),
          ),
        ],
      ),
    ).center();
  }
}

class SampleQrStyleTwo extends StatelessWidget {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: qrKey,
      child: QrImage(
        version: 4,
        eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.circle),
        dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle),
        data: 'https://www.google.com/',
        size: 200,
        backgroundColor: appStore.isDarkMode ? Colors.white : Colors.transparent,
        foregroundColor: Colors.black,
        errorStateBuilder: (cxt, err) {
          return Text("${language.lblUhOhSomethingWentWrong}", textAlign: TextAlign.center).center();
        },
      ),
    );
  }
}
