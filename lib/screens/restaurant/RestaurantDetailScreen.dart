import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/GetCategoryListResponse.dart';
import 'package:qr_menu_laravel_flutter/models/GetRestaurantListResponse.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/network/RestApis.dart';
import 'package:qr_menu_laravel_flutter/qr/QrGenerateScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/restaurant/AddRestaurantScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/restaurant/components/RestaurantMenuList.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:qr_menu_laravel_flutter/utils/modelKeys.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant? data;
  final int? restaurantId;
  final VoidCallback? callback;

  RestaurantDetailScreen({this.data, required this.restaurantId, this.callback});

  @override
  RestaurantDetailScreenState createState() => RestaurantDetailScreenState();
}

class RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  List<Category> categoryList = [];
  RestaurantDetailResponse? restaurantData = RestaurantDetailResponse();

  bool showAppBarOptions = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      setStatusBarColor(context.scaffoldBackgroundColor);
      restaurantDetail();
    });
  }

  Future<void> restaurantDetail() async {
    await 1.seconds.delay;
    appStore.setLoading(true);
    await getRestaurantDetail(restaurantId: widget.restaurantId.validate()).then((value) {
      restaurantData = null;
      appStore.setLoading(false);

      restaurantData = value;
      menuListMain = restaurantData!.menu.validate();
      menuStore.setSelectedCategoryData(null);
      showAppBarOptions = true;

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      log(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> deleteData() async {
    appStore.setLoading(true);
    Map request = {CommonKeys.id: widget.restaurantId.validate()};
    deleteRestaurant(request: request).then((value) {
      toast(language.lblDeleteSuccessfully);
      widget.callback?.call();
      finish(context, true);
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        restaurantData!.toJson().isNotEmpty ? '${restaurantData!.restaurantDetail!.name.validate()}' : '',
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              QrGenerateScreen(restaurantDetail: restaurantData!.restaurantDetail).launch(context);
            },
            icon: Icon(Icons.qr_code, color: context.iconColor),
          ).visible(showAppBarOptions),
          PopupMenuButton(
            color: context.cardColor,
            enabled: true,
            onSelected: (v) async {
              if (v == 1) {
                await AddRestaurantScreen(data: widget.data).launch(context);
                widget.callback!.call();

                finish(context, true);
              } else if (v == 2) {
                showConfirmDialogCustom(
                  context,
                  dialogType: DialogType.DELETE,
                  title: '${language.lblDoYouWantToDeleteRestaurant}?',
                  onAccept: (c) {
                    if (!getBoolAsync(SharePreferencesKey.IS_DEMO_ADMIN))
                      deleteData();
                    else
                      toast(language.lblDemoUserText);
                  },
                );
              } else {
                toast(language.lblWrongSelection);
              }
            },
            shape: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
            icon: Icon(Icons.more_horiz, color: context.iconColor),
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
          ).paddingRight(8).visible(showAppBarOptions),
        ],
        color: context.scaffoldBackgroundColor,
        backWidget: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.iconColor),
          onPressed: () {
            widget.callback!.call();
            finish(context, true);
          },
        ),
      ),
      body: Stack(
        children: [
          if (restaurantData!.toJson().isNotEmpty)
            RestaurantMenuList(
              isAdmin: true,
              data: restaurantData,
              callback: () {
                restaurantDetail();
              },
            ),
          Observer(builder: (_) => Loader().visible(appStore.isLoading).center()),
        ],
      ),
    );
  }
}
