import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';

class AboutScreen extends StatefulWidget {
  final String? id;

  AboutScreen({this.id});

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.lblAbout,
        color: context.scaffoldBackgroundColor,
        elevation: 0,
        backWidget: IconButton(
            onPressed: () {
              finish(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: context.iconColor)),
      ),
      body: SnapHelperWidget<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        onSuccess: (data) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(thickness: 1, color: context.dividerColor),
            16.height,
            Container(
              decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${language.lblVersion}', style: boldTextStyle(size: 18)),
                      Text(data.version, style: primaryTextStyle(color: primaryColor)),
                    ],
                  ),
                  16.height,
                  Text(AppConstant.appDescription, style: secondaryTextStyle(color: bodyColor, size: 16)),
                ],
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
      bottomNavigationBar: AppButton(
        color: primaryColor,
        elevation: 0,
        margin: EdgeInsets.all(16),
        shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
        onTap: () {
          launchUrlCustomTab(Urls.codeCanyonURL);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(MaterialCommunityIcons.shopping_outline, color: white),
            4.width,
            Text(language.lblPurchase, style: boldTextStyle(color: white, size: 18)),
          ],
        ),
      ),
    );
  }
}
