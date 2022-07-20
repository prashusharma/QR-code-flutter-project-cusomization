import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    localeLanguageList.forEach((element) {
      if (appStore.selectedLanguage == element.languageCode.validate()) {
        selectedIndex = localeLanguageList.indexOf(element);
        setState(() {});
      }
    });
  }

  Color? getSelectedColor(LanguageDataModel data) {
    if (appStore.selectedLanguage == data.languageCode.validate() && appStore.isDarkMode) {
      return Colors.white54;
    } else if (appStore.selectedLanguage == data.languageCode.validate() && !appStore.isDarkMode) {
      return primaryColor.withAlpha(40);
    } else {
      return null;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.lblLanguage,
        showBack: true,
        elevation: 0,
        color: context.scaffoldBackgroundColor,
        backWidget: IconButton(
            onPressed: () {
              finish(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: context.iconColor)),
      ),
      body: Column(
        children: [
          Divider(thickness: 1, color: context.dividerColor, endIndent: 16, indent: 16),
          ...List.generate(
            localeLanguageList.length,
            (index) {
              LanguageDataModel data = localeLanguageList[index];
              return Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                color: appStore.selectedLanguage == data.languageCode.validate() ? context.cardColor : context.scaffoldBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(data.flag.validate(), width: 34),
                        16.width,
                        Text('${data.name.validate()}', style: boldTextStyle(size: 18, color: selectedIndex == index ? context.iconColor : bodyColor)),
                      ],
                    ),
                    if (appStore.selectedLanguage == data.languageCode.validate()) Icon(Icons.check, color: primaryColor)
                  ],
                ).onTap(
                  () async {
                    selectedIndex = index;
                    setValue(SELECTED_LANGUAGE_CODE, data.languageCode);
                    selectedLanguageDataModel = data;
                    appStore.setLanguage(data.languageCode!, context: context);

                    setState(() {});
                    finish(context);
                  },
                  borderRadius: radius(defaultRadius),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
