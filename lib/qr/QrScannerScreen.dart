import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/screens/userSide/UserSplashScreen.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:scan/scan.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScanner extends StatefulWidget {
  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  ScanController controller = ScanController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            ScanView(
              controller: controller,
              scanAreaScale: .7,
              scanLineColor: Colors.green,
              onCapture: (data) {
                if (data.validate().isNotEmpty) {
                  if (data.validateURL()) {
                    if (data.contains(mBaseURL)) {
                      UserSplashScreen(result: data.split('/')[3]).launch(context);
                    } else {
                      launch(data, forceWebView: true, enableJavaScript: true);
                    }
                  } else {
                    toast(data.validate());
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
