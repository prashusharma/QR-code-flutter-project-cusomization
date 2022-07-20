import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/utils/GetStyleWidget.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QrGenerateScreen extends StatefulWidget {
  final RestaurantDetail? restaurantDetail;

  QrGenerateScreen({this.restaurantDetail});

  @override
  _QrGenerateScreenState createState() => _QrGenerateScreenState();
}

class _QrGenerateScreenState extends State<QrGenerateScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String saveUrl = "";
  bool isTesting = false;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    screenshotController = ScreenshotController();

    if (widget.restaurantDetail!.id != null) {
      saveUrl = widget.restaurantDetail!.id.validate().toString();
      saveUrl = "$mBaseURL${widget.restaurantDetail!.id.validate()}";
    } else {
      saveUrl = 'www.google.com';
    }

    setState(() {});
  }

  void getScreenShot() async {
    screenshotController.capture(delay: Duration(milliseconds: 10)).then((Uint8List? image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);

        await Share.shareFiles([imagePath.path]);
      }
    }).catchError((onError) {
      toast(language.lblTryAgain);
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        '${widget.restaurantDetail!.name.validate()} ${language.lblQR} ',
        color: context.scaffoldBackgroundColor,
        actions: [
          !isWeb
              ? IconButton(
                  icon: Icon(Icons.share, color: context.iconColor),
                  onPressed: () {
                    getScreenShot();
                  },
                )
              : Offstage(),
          16.width,
        ],
        elevation: 0.5
      ),
      backgroundColor: appStore.selectedQrStyle == language.lblQrStyle3 ? (appStore.isDarkMode ? context.scaffoldBackgroundColor : Colors.white70.withOpacity(0.92)) : context.scaffoldBackgroundColor,
      body: Screenshot(
        controller: screenshotController,
        child: getQrStyleWidget(isTesting, qrKey, saveUrl, widget.restaurantDetail),
      ),
    );
  }
}
