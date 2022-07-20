import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/screens/auth/EditProfileScreen.dart';
import 'package:qr_menu_laravel_flutter/utils/CachedNetworkImage.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

class EditProfileCard extends StatelessWidget {
  const EditProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder:(_) => Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                cachedImage(appStore.userProfileImage, height: 50, width: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(70),
                16.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appStore.userName, style: boldTextStyle(size: 18)),
                    Text(appStore.userEmail, style: secondaryTextStyle(color: bodyColor)),
                  ],
                )
              ],
            ),
            Image.asset('images/icons/ic_Edit.png',height: 30).onTap((){
              push(EditProfileScreen(),pageRouteAnimation: PageRouteAnimation.Slide);
            }),
          ],
        ),
      ),
    );
  }
}
