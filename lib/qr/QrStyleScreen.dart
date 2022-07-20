import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/QrStyleModel.dart';
import 'package:qr_menu_laravel_flutter/utils/CachedNetworkImage.dart';
import 'package:qr_menu_laravel_flutter/utils/GetStyleWidget.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';

class QrStyleScreen extends StatefulWidget {
  @override
  _QrStyleScreenState createState() => _QrStyleScreenState();
}

class _QrStyleScreenState extends State<QrStyleScreen> {
  int? selectedIndex;

  List<QrStyleModel> data = QrStyleModel.getQrStyleList();

  @override
  void initState() {
    if (appStore.selectedQrStyle == '') {
      appStore.setQrStyle(data.first.styleName.validate());
    }
    selectedIndex = data.indexWhere((element) => element.styleName == appStore.selectedQrStyle);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(
          language.lblSetQrStyle,
          showBack: true,
          elevation: 0,
          color: context.scaffoldBackgroundColor,
          backWidget: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: context.iconColor),
            onPressed: () {
              finish(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.done, color: context.iconColor),
              onPressed: () {
                finish(context);
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(thickness: 1, color: context.dividerColor),
              16.height,
              Text('${language.lblSelectQRStyles}', style: boldTextStyle()),
              16.height,
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(data.length, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: radius(defaultRadius),
                      color: index == selectedIndex ? primaryColor : context.cardColor,
                    ),
                    width: context.width() / 2 - 24,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '${language.lblStyle} ${index + 1}',
                      style: boldTextStyle(color: index == selectedIndex ? Colors.white : bodyColor),
                      textAlign: TextAlign.center,
                    ),
                  ).onTap(() {
                    selectedIndex = index;
                    appStore.setQrStyle(data[index].styleName.validate());
                    setValue(SharePreferencesKey.QR_STYLE, data[index].styleName);

                    setState(() {});
                  }, borderRadius: radius(defaultRadius));
                }),
              ),
              20.height,
              Container(
                constraints: BoxConstraints(maxWidth: 500),
                width: context.width(),
                decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${appStore.selectedQrStyle}', style: boldTextStyle()),
                    8.height,
                    Container(
                      width: context.width(),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(defaultRadius)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          8.height,
                          if (selectedIndex == 2) Text('${language.lblScanForOurOnlineMenu}', style: secondaryTextStyle()),
                          8.height,
                          getSampleQrStyle(),
                          if (selectedIndex == 0 || selectedIndex == 1) 8.height,
                          if (selectedIndex == 0 || selectedIndex == 1) Text('${language.lblScanForOurOnlineMenu}', style: secondaryTextStyle(), textAlign: TextAlign.center),
                          if (selectedIndex == 0 || selectedIndex == 1) 8.height,
                          10.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (selectedIndex == 2) cachedImage('images/pizza.jpg', height: 30, width: 30, fit: BoxFit.cover).cornerRadiusWithClipRRect(15),
                              if (selectedIndex == 2) 8.width,
                              if (selectedIndex == 0 || selectedIndex == 2) Text('${language.lblYourRestaurantName}', style: boldTextStyle()),
                            ],
                          ),
                        ],
                      ),
                    ).center(),
                  ],
                ),
              ),
              20.height,

            ],
          ).paddingSymmetric(horizontal: 16),
        ));
  }
}
