import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

// ignore: must_be_immutable
class MenuItemDetailComponent extends StatefulWidget {
  final String title;
  final String subtitle;
  bool isSelected;
  final bool? isTappedEnabled;
  final Function(bool val) onChanged;

  MenuItemDetailComponent({required this.title, required this.subtitle, required this.isSelected, required this.onChanged, this.isTappedEnabled});

  @override
  _MenuItemDetailComponentState createState() => _MenuItemDetailComponentState();
}

class _MenuItemDetailComponentState extends State<MenuItemDetailComponent> {
  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.isSelected;
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingItemWidget(
      title: widget.title,
      titleTextStyle: primaryTextStyle(color: bodyColor),
      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
      trailing: Transform.scale(
        scale: 0.7,
        alignment: Alignment.centerRight,
        child: CupertinoSwitch(
          value: isSelected,
          onChanged: (val) {
            if (widget.isTappedEnabled.validate(value: false)) {
              widget.onChanged(false);
            } else {
              isSelected = !isSelected;
              widget.onChanged(isSelected);
            }
            setState(() {});
          },
          activeColor: primaryColor,
          trackColor: primaryColor.withAlpha(30),
        ),
      ),
      onTap: () {
        if (widget.isTappedEnabled.validate(value: false)) {
          widget.onChanged(false);
        } else {
          isSelected = !isSelected;
          widget.onChanged(isSelected);
        }
        setState(() {});
      },
    );
  }
}
