import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/AppTheme.dart';
import 'package:qr_menu_laravel_flutter/language/AppLocalizations.dart';
import 'package:qr_menu_laravel_flutter/language/Languages.dart';
import 'package:qr_menu_laravel_flutter/models/GetRestaurantListResponse.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/screens/SplashScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/userSide/UserSplashScreen.dart';
import 'package:qr_menu_laravel_flutter/services/FirebaseOptions.dart';
import 'package:qr_menu_laravel_flutter/store/AppStore.dart';
import 'package:qr_menu_laravel_flutter/store/MenuStore.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:url_strategy/url_strategy.dart';

import 'models/UserListModel.dart';

//region Global Variables
FirebaseFirestore fireStore = FirebaseFirestore.instance;

AppStore appStore = AppStore();
MenuStore menuStore = MenuStore();

GetRestaurantListResponse selectedRestaurant = GetRestaurantListResponse();

late BaseLanguage language;
List<Menu> menuListMain = [];
List<UserData> userList = [];
//endregion

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!isDesktop) {
    await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions).catchError((e) {
      log(e.toString());
      return e;
    });
  }

  setPathUrlStrategy();

  defaultRadius = 12.0;
  defaultAppButtonRadius = 12.0;
  defaultLoaderAccentColorGlobal = primaryColor;

  await initialize(aLocaleLanguageList: languageList());

  appStore.setLoggedIn(getBoolAsync(SharePreferencesKey.IS_LOGGED_IN));
  if (appStore.isLoggedIn) {
    appStore.setUserId(getIntAsync(SharePreferencesKey.USER_ID));
    appStore.setFullName(getStringAsync(SharePreferencesKey.FULL_NAME));
    appStore.setUserEmail(getStringAsync(SharePreferencesKey.USER_EMAIL));
    appStore.setPassword(getStringAsync(SharePreferencesKey.USER_PASSWORD));
    appStore.setUserProfile(getStringAsync(SharePreferencesKey.USER_IMAGE));
    appStore.setUserName(getStringAsync(SharePreferencesKey.USER_NAME));
    appStore.setToken(getStringAsync(SharePreferencesKey.TOKEN));
    appStore.setContactNumber(getStringAsync(SharePreferencesKey.CONTACT_NUMBER));
    if (getStringAsync(SharePreferencesKey.USER_TYPE) == LoginTypes.admin) {
      appStore.setIsAdmin(true);
    } else {
      appStore.setIsAdmin(false);
    }
    if (getStringAsync(SharePreferencesKey.USER_TYPE) == LoginTypes.demoAdmin) {
      appStore.setIsDemoAdmin(true);
    } else {
      appStore.setIsDemoAdmin(false);
    }
  }

  appButtonBackgroundColorGlobal = primaryColor;

  if (!isWeb) {
    int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
    if (themeModeIndex == AppThemeMode.ThemeModeLight) {
      appStore.setDarkMode(false);
    } else if (themeModeIndex == AppThemeMode.ThemeModeDark) {
      appStore.setDarkMode(true);
    }
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  //
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        scrollBehavior: SBehavior(),
        navigatorKey: navigatorKey,
        title: AppConstant.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: SplashScreen(),
        onGenerateRoute: (settings) {
          List<String> pathComponents = settings.name!.split('/');
          if (pathComponents[1].isNotEmpty) {
            return MaterialPageRoute(
              builder: (context) {
                return UserSplashScreen(result: pathComponents[1]);
              },
              settings: RouteSettings(
                name: '/${pathComponents[1]}',
              ),
            );
          }else {
            return MaterialPageRoute(builder: (_) => SplashScreen());
          }
        },
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: [
          AppLocalizations(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguage.validate(value: AppConstant.defaultLanguage)),
      ),
    );
  }
}
