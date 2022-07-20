import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/models/GetCategoryListResponse.dart';
import 'package:qr_menu_laravel_flutter/network/RestApis.dart';
import 'package:qr_menu_laravel_flutter/screens/category/AddCategoryScreen.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:qr_menu_laravel_flutter/utils/modelKeys.dart';

import '../../../../main.dart';

class MenuListCategoryComponent extends StatelessWidget {
  final Category categoryData;
  final bool isAdmin;
  final VoidCallback? callback;

  MenuListCategoryComponent({required this.categoryData, this.isAdmin = false, this.callback});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(categoryData.name.validate(), style: boldTextStyle(color: bodyColor, size: 20)).paddingSymmetric(horizontal: 16),
        if (isAdmin)
          PopupMenuButton(
            color: context.cardColor,
            enabled: true,
            icon: Icon(Icons.more_horiz, color: context.iconColor),
            onSelected: (v) async {
              if (v == 1) {
                bool? res = await AddCategoryScreen(categoryData: categoryData).launch(context);
                if (res ?? false) {
                  callback?.call();
                }
              } else if (v == 2) {
                Map request = {
                  CommonKeys.id: categoryData.id.validate(),
                };

                if (!getBoolAsync(SharePreferencesKey.IS_DEMO_ADMIN)) {
                  await deleteCategory(request: request).then((value) {
                    appStore.setLoading(false);
                    appStore.setIsAll(true);
                    menuStore.setSelectedCategoryData(null);

                    callback?.call();
                    toast('${language.lblDeleteSuccessfully}');
                  }).catchError((e) {
                    appStore.setLoading(false);
                    toast(e.toString());
                  });
                } else {
                  toast(language.lblDemoUserText);
                }
              } else {
                toast('${language.lblWrongSelection}');
              }
            },
            shape: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 1,
                child: SettingItemWidget(
                  padding: EdgeInsets.all(0),
                  onTap: null,
                  leading: Icon(Icons.edit, color: context.iconColor, size: 20),
                  title: '${language.lblEdit}',
                  titleTextStyle: primaryTextStyle(),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: SettingItemWidget(
                  onTap: null,
                  leading: Icon(Icons.delete, color: context.iconColor, size: 20),
                  padding: EdgeInsets.all(0),
                  title: '${language.lblDelete}',
                  titleTextStyle: primaryTextStyle(),
                ),
              )
            ],
          ).paddingSymmetric(horizontal: 8),
      ],
    );
  }
}
