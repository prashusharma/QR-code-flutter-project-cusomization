import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/CurrencyModel.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';

class CurrencyScreen extends StatefulWidget {
  final CurrencyModel? selectedCurrency;

  CurrencyScreen({this.selectedCurrency});

  @override
  _CurrencyScreenState createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  List<CurrencyModel> data = CurrencyModel.getCurrencyList();

  int selectedIndex = -1;
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isUpdate = widget.selectedCurrency != null;
    if (isUpdate) {
      selectedIndex = data.indexWhere((element) => element.symbol == widget.selectedCurrency!.symbol.validate());
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color? getSelectedColor(int index) {
    if (selectedIndex == index && appStore.isDarkMode) {
      return Colors.white54;
    } else if (selectedIndex == index && !appStore.isDarkMode) {
      return primaryColor.withAlpha(40);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.lblChooseCurrencySymbol,
        showBack: true,
        backWidget: IconButton(
          onPressed: () {
            if (isUpdate) {
              finish(context, data[selectedIndex]);
            } else {
              finish(context);
            }
          },
          icon: Icon(Icons.arrow_back, color: context.iconColor),
        ),
        elevation: 0,
        color: context.scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              finish(context, data[selectedIndex]);
            },
            icon: Icon(Icons.done, color: context.iconColor),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(
            data.length,
            (index) {
              CurrencyModel currentData = data[index];
              return Container(
                width: context.width() / 2 - 24,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(borderRadius: radius(defaultRadius), color: getSelectedColor(index), border: Border.all(color: context.dividerColor)),
                child: Row(
                  children: [
                    Text(currentData.name.validate(), style: boldTextStyle()).expand(),
                    Text(currentData.symbol.validate(), style: boldTextStyle()).center(),
                  ],
                ),
              ).onTap(
                () {
                  selectedIndex = index;
                  setState(() {});
                  finish(context, data[selectedIndex]);
                },
                borderRadius: radius(defaultRadius),
              );
            },
          ),
        ),
      ),
    );
  }
}
