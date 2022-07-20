import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/MenuStyleModel.dart';
import 'package:qr_menu_laravel_flutter/utils/GetStyleWidget.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';

class MenuStyleScreen extends StatefulWidget {
  const MenuStyleScreen({Key? key}) : super(key: key);

  @override
  _MenuStyleScreenState createState() => _MenuStyleScreenState();
}

class _MenuStyleScreenState extends State<MenuStyleScreen> {
  int? selectedIndex;

  List<MenuStyleModel> data = MenuStyleModel.getStyleList();

  @override
  void initState() {
    if (appStore.selectedMenuStyle == '') {
      appStore.setMenuStyle(data.first.styleName.validate());
    }
    selectedIndex = data.indexWhere((element) => element.styleName == appStore.selectedMenuStyle);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.lblSetMenuStyle,
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
            Text('${language.lblSelectMenuStyles}', style: boldTextStyle()),
            16.height,
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(data.length, (i) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: radius(defaultRadius),
                    color: i == selectedIndex ? primaryColor : context.cardColor,
                  ),
                  width: context.width() / 2 - 24,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '${language.lblStyle} ${i + 1}',
                    style: boldTextStyle(color: i == selectedIndex ? Colors.white : bodyColor),
                    textAlign: TextAlign.center,
                  ),
                ).onTap(() {
                  selectedIndex = i;
                  appStore.setMenuStyle(data[i].styleName.validate());
                  setValue(SharePreferencesKey.MENU_STYLE, data[i].styleName);

                  setState(() {});
                }, borderRadius: radius(defaultRadius));
              }),
            ),
            20.height,
            Container(
              decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${appStore.selectedMenuStyle}', style: boldTextStyle()),
                  16.height,
                  getSampleMenu(context),
                ],
              ),
            ),
            20.height,
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
    );
  }
}
