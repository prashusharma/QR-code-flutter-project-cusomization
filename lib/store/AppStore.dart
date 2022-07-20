import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/language/AppLocalizations.dart';
import 'package:qr_menu_laravel_flutter/language/Languages.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/MenuCategoryModel.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  bool doRemember = false;

  @observable
  bool isNotificationOn = true;

  @observable
  bool isDarkMode = false;

  @observable
  bool isLoading = false;

  @observable
  bool isEmailLogin = false;

  @observable
  bool isAll = true;

  @observable
  bool isAdmin = true;

  @observable
  bool isDemoAdmin = false;

  @observable
  String selectedLanguage = "";

  @observable
  String userProfileImage = '';

  @observable
  String userFullName = '';

  @observable
  String userEmail = '';

  @observable
  String userName = '';

  @observable
  String userType = '';

  @observable
  String token = '';

  @observable
  String password = '';

  @observable
  String selectedMenuStyle = "";

  @observable
  String selectedQrStyle = "";

  @observable
  String contactNumber = '';

  @observable
  int userId = 0;

  @observable
  List<MenuCategoryModel> menuListByCategory = [];

  @action
  Future<void> setIsAdmin(bool val, {bool isInitializing = false}) async {
    isAdmin = val;
    if (!isInitializing) await setValue(SharePreferencesKey.IS_ADMIN, val);
  }

  @action
  Future<void> setIsDemoAdmin(bool val, {bool isInitializing = false}) async {
    isDemoAdmin = val;
    if (!isInitializing) await setValue(SharePreferencesKey.IS_DEMO_ADMIN, val);
  }

  @action
  Future<void> setRemember(bool val, {bool isInitializing = false}) async {
    doRemember = val;
    if (!isInitializing) await setValue(SharePreferencesKey.REMEMBER_ME, val);
  }

  @action
  void setIsAll(bool val) {
    isAll = val;
  }

  @action
  void setMenuByCategoryList(List<MenuCategoryModel> list) {
    menuListByCategory = list;
  }

  @action
  void setMenuStyle(String style) {
    selectedMenuStyle = style;
  }

  @action
  void setQrStyle(String style) {
    selectedQrStyle = style;
  }

  @action
  Future<void> setToken(String val, {bool isInitializing = false}) async {
    token = val;
    if (!isInitializing) await setValue(SharePreferencesKey.TOKEN, val);
  }

  @action
  Future<void> setUserProfile(String val, {bool isInitializing = false}) async {
    userProfileImage = val;
    if (!isInitializing) await setValue(SharePreferencesKey.USER_IMAGE, val);
  }

  @action
  Future<void> setUserId(int val, {bool isInitializing = false}) async {
    userId = val;
    if (!isInitializing) await setValue(SharePreferencesKey.USER_ID, userId);
  }

  @action
  Future<void> setUserEmail(String val, {bool isInitializing = false}) async {
    userEmail = val;
    if (!isInitializing) await setValue(SharePreferencesKey.USER_EMAIL, val);
  }

  @action
  Future<void> setUserName(String val, {bool isInitializing = false}) async {
    userName = val;
    if (!isInitializing) await setValue(SharePreferencesKey.USER_NAME, val);
  }

  @action
  Future<void> setUserType(String val, {bool isInitializing = false}) async {
    userType = val;
    if (!isInitializing) await setValue(SharePreferencesKey.USER_TYPE, val);
  }

  @action
  Future<void> setFullName(String val, {bool isInitializing = false}) async {
    userFullName = val;
    if (!isInitializing) await setValue(SharePreferencesKey.FULL_NAME, val);
  }

  @action
  Future<void> setPassword(String val, {bool isInitializing = false}) async {
    password = val;
    if (!isInitializing) await setValue(SharePreferencesKey.PASSWORD, val);
  }

  @action
  Future<void> setContactNumber(String val, {bool isInitializing = false}) async {
    contactNumber = val;
    if (!isInitializing) await setValue(SharePreferencesKey.CONTACT_NUMBER, val);
  }

  @action
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(SharePreferencesKey.IS_LOGGED_IN, val);
  }

  @action
  void setLoading(bool val) {
    isLoading = val;
  }

  @action
  Future<void> setNotification(bool val, {bool isInitializing = false}) async {
    isNotificationOn = val;

    if (!isInitializing) await setValue(SharePreferencesKey.IS_NOTIFICATION_ON, val);
  }

  @action
  Future<void> setIsEmailLogin(bool val, {bool isInitializing = false}) async {
    isEmailLogin = val;

    if (!isInitializing) await setValue(SharePreferencesKey.IS_EMAIL_LOGIN, val);
  }

  @action
  Future<void> setDarkMode(bool aIsDarkMode) async {
    isDarkMode = aIsDarkMode;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = viewLineColor;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.white12;

      setStatusBarColor(scaffoldSecondaryDark);
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = primaryColor;
      shadowColorGlobal = Colors.black12;

      setStatusBarColor(Colors.white);
    }
  }

  @action
  Future<void> setLanguage(String aCode, {BuildContext? context}) async {
    selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: AppConstant.defaultLanguage);
    selectedLanguage = getSelectedLanguageModel(defaultLanguage: AppConstant.defaultLanguage)!.languageCode!;
    if (context != null) language = BaseLanguage.of(context)!;
    language = await AppLocalizations().load(Locale(selectedLanguage));
  }
}
