import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/utils/CachedNetworkImage.dart';

class QrComponentStyleOne extends StatelessWidget {
  final GlobalKey qrKey;
  final String saveUrl;
  final bool isTesting;
  final RestaurantDetail? restaurantDetail;

  QrComponentStyleOne({required this.isTesting, required this.qrKey, required this.saveUrl, this.restaurantDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      padding: EdgeInsets.only(bottom: 32, left: 16, right: 16, top: 32),
      width: context.width() - 32,
      decoration: BoxDecoration(borderRadius: radius(16), color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          (restaurantDetail!.restaurantLogo!.isNotEmpty)
              ? Offstage()
              : cachedImage(
                  restaurantDetail!.restaurantLogo.validate(),
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                ).cornerRadiusWithClipRRect(80),
          Text(
            '${restaurantDetail!.name.validate()}',
            textAlign: TextAlign.center,
            style: boldTextStyle(size: 36),
          ),
          16.height,
          Text(
            language.lblScanForOurOnlineMenu,
            textAlign: TextAlign.center,
            style: primaryTextStyle(size: 20),
          ),
          16.height,
          RepaintBoundary(
            key: qrKey,
            child: QrImage(
              version: 4,
              data: saveUrl,
              size: 250,
              backgroundColor: appStore.isDarkMode ? Colors.white : Colors.transparent,
              errorStateBuilder: (cxt, err) {
                return Container(
                  child: Center(
                    child: Text(
                      "${language.lblUhOhSomethingWentWrong}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).center();
  }
}

class SampleQrStyleOne extends StatelessWidget {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: qrKey,
      child: QrImage(
        version: 4,
        data: 'https://www.google.com/',
        size: 200,
        backgroundColor: appStore.isDarkMode ? Colors.white : Colors.transparent,
        errorStateBuilder: (cxt, err) {
          return Container(
            child: Center(
              child: Text(
                "${language.lblUhOhSomethingWentWrong}",
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
