import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/components/NoDataComponent.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/GetRestaurantListResponse.dart';
import 'package:qr_menu_laravel_flutter/network/RestApis.dart';
import 'package:qr_menu_laravel_flutter/screens/restaurant/AddRestaurantScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/restaurant/VoiceSearchScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/restaurant/components/ResturantCardComponent.dart';
import 'package:qr_menu_laravel_flutter/screens/settings/SettingScreen.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  List<Restaurant> restaurantList = [];
  List<Restaurant> tempList = [];

  TextEditingController searchController = TextEditingController();

  int foodItemCount = 0;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    init();
    getMyRestaurantList();
  }

  Future<void> init() async {
    await 2.milliseconds.delay;
    appStore.setLoading(true);
    setStatusBarColor(context.scaffoldBackgroundColor);
  }

  Future<void> getMyRestaurantList() async {
    await getRestaurant(managerId: appStore.userId.validate()).then((value) {
      appStore.setLoading(false);

      restaurantList.clear();
      restaurantList.addAll(value.data!);
      log('Restaurant length: ${restaurantList.length}');

      tempList = restaurantList;
      searchController.clear();

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void setTempList({String? text}) {
    tempList = restaurantList.where((element) {
      final resName = element.name!.toLowerCase();

      return resName.contains(text.validate().toLowerCase());
    }).toList();

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        appStore.setLoading(true);
        getMyRestaurantList();
      },
      child: Observer(
        builder: (_) => Scaffold(
          appBar: appBarWidget(
            "${language.lblHello} ${appStore.userName}",
            titleWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${language.lblHello} ${appStore.userName}',
                  style: boldTextStyle(size: 18, color: appStore.isDarkMode ? Colors.white : headingColor),
                ),
                Text(
                  '${language.lblWelcomeBackHaveANiceDay}',
                  style: secondaryTextStyle(color: bodyColor, size: 12),
                )
              ],
            ).paddingTop(12),
            showBack: false,
            elevation: 0,
            actions: [
              Image.asset(
                'images/icons/ic_Setting.png',
                height: 24,
                width: 24,
                color: context.iconColor,
              ).paddingOnly(left: 16, right: 16).onTap(() {
                push(SettingScreen(), pageRouteAnimation: PageRouteAnimation.Scale, duration: 450.milliseconds).then((value) => setState(() {}));
              }),
            ],
            color: context.scaffoldBackgroundColor,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    30.height,
                    Container(
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(32)),
                      child: AppTextField(
                        controller: searchController,
                        autoFocus: false,
                        textFieldType: TextFieldType.NAME,
                        onChanged: (text) {
                          setTempList(text: text);
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: isWeb ? 16 : 12),
                          border: InputBorder.none,
                          hintText: '${language.lblSearchYourRestaurant}...',
                          hintStyle: primaryTextStyle(color: bodyColor, size: 16),
                          prefixIcon: Image.asset('images/icons/ic_Search.png', height: 16, width: 16, color: context.iconColor).paddingAll(16),
                          suffixIcon: Image.asset(
                            'images/icons/ic_mic.png',
                            height: 16,
                            width: 16,
                            color: context.iconColor,
                          ).paddingAll(16).onTap(() {
                            VoiceSearchScreen().launch(context).then((value) {
                              if(value != null){
                                searchController.text = value.toString();
                                setState(() {});
                              }
                              setTempList(text: value.toString());
                            });
                          }, highlightColor: Colors.transparent, splashColor: Colors.transparent),
                        ),
                      ),
                    ),
                    30.height,
                    Text('${language.lblMyRestaurant} (${tempList.length})', style: boldTextStyle(size: 18)),
                    16.height,
                    Responsive(
                      mobile: ListView.builder(
                        padding: EdgeInsets.only(bottom: 40),
                        itemCount: tempList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return RestaurantCardComponent(
                              data: tempList[index],
                              callback: () async {
                                getMyRestaurantList();
                              }).paddingSymmetric(vertical: 8);
                        },
                      ),
                      web: GridView.builder(
                        itemCount: tempList.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return RestaurantCardComponent(
                              data: tempList[index],
                              callback: () async {
                                getMyRestaurantList();
                              }).paddingSymmetric(vertical: 8);
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2,
                          mainAxisExtent: 330,
                        ),
                      ),
                    ).visible(restaurantList.isNotEmpty),
                    if (!appStore.isLoading && (restaurantList.isEmpty || tempList.isEmpty)) NoRestaurantComponent(errorName: "${language.lblNoRestaurant}"),
                    70.height,
                  ],
                ).paddingSymmetric(horizontal: 16),
              ),
              Loader().visible(appStore.isLoading).center()
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, size: 30, color: Colors.white),
            backgroundColor: primaryColor,
            elevation: 0,
            onPressed: () async {
              await push(AddRestaurantScreen(userId: getIntAsync(SharePreferencesKey.USER_ID))).then((value) {
                getMyRestaurantList();
              });
            },
          ),
        ),
      ),
    );
  }
}
