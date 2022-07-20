import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/UserListModel.dart';
import 'package:qr_menu_laravel_flutter/utils/CachedNetworkImage.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';

class UserListDropdownComponent extends StatefulWidget {
  final UserData? defaultValue;
  final Function(UserData value) onValueChanged;
  final bool isValidate;
  final List<UserData>? userData;

  UserListDropdownComponent({this.defaultValue, required this.onValueChanged, required this.isValidate, this.userData});

  @override
  UserListDropdownComponentState createState() => UserListDropdownComponentState();
}

class UserListDropdownComponentState extends State<UserListDropdownComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<UserData>(
      onChanged: (value) {
        widget.onValueChanged.call(value!);
      },
      value: widget.defaultValue,
      isExpanded: true,
      validator: widget.isValidate
          ? (c) {
              if (c == null) return errorThisFieldRequired;
              return null;
            }
          : null,
      decoration: inputDecoration(context, label: '${language.lblSelectManager}').copyWith(
        prefixIcon: Image.asset('images/icons/ic_User.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
      ),
      dropdownColor: context.cardColor,
      alignment: Alignment.bottomCenter,
      items: List.generate(
        widget.userData!.length,
        (index) {
          UserData data = widget.userData![index];
          return DropdownMenuItem(
            value: data,
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${data.name.validate()}', style: primaryTextStyle()),
                  cachedImage(data.profileImage.validate(), height: 25, width: 25, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
