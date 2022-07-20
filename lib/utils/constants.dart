const mBaseURL = 'https://qr-menu-laravel.web.app/';
const mBaseUrl =
    "https://wordpress.iqonic.design/product/mobile/qr-menu-laravel/api/";

/// REGION LIVESTREAM KEYS
const tokenStream = 'tokenStream';
bool isSocialLogin = false;
const String perPage = '-1';

class AppConstant {
  static const appName = "Global Menu";
  static const appDescription =
      'Global Menu Laravel is a well equipped Flutter app. On the user end, it offers the user a simple way to view the menu of a restaurant without even confronting the waiter. It offers an easy, manageable & on-the-go methodology of menu viewing process. While, on the restaurant owner end, the app offers a conventional and easily manageable method to manage restaurants, food categories and menuStyles';
  static const defaultLanguage = 'en';
}

class DemoDetail {
  static const demo_email = 'steven@gmail.com';
  static const demo_pass = '123456';
}

class AppThemeMode {
  static const ThemeModeLight = 1;
  static const ThemeModeDark = 2;
  static const ThemeModeSystem = 0;
}

class SharePreferencesKey {
  static const REMEMBER_ME = 'REMEMBER_ME';

  static const IS_LOGGED_IN = 'IS_LOGGED_IN';
  static const USER_ID = 'USER_ID';
  static const USER_NAME = 'USER_NAME';
  static const FULL_NAME = 'NAME';
  static const USER_NUMBER = 'USER_NUMBER';
  static const USER_EMAIL = 'USER_EMAIL';
  static const USER_PASSWORD = 'USER_PASSWORD';
  static const USER_IMAGE = 'USER_IMAGE';
  static const IS_EMAIL_LOGIN = 'IS_EMAIL_LOGIN';
  static const PASSWORD = "PASSWORD";
  static const Language = "LANGUAGE";
  static const TOKEN = 'TOKEN';
  static const PLAYER_ID = 'PLAYER_ID';
  static const USER_TYPE = 'USER_TYPE';
  static const CONTACT_NUMBER = "CONTACT_NUMBER";

  static const IS_NOTIFICATION_ON = "IS_NOTIFICATION_ON";
  static const IS_WALKED_THROUGH = "IS_WALKED_THROUGH";

  static const QR_STYLE = "QR_STYLE";
  static const MENU_STYLE = "MENU_STYLE";

  static const IS_ADMIN = 'IS_ADMIN';
  static const IS_DEMO_ADMIN = 'IS_DEMO_ADMIN';
  static const LOGIN_TYPE = 'LOGIN_TYPE';
}

class AppImages {
  static const placeHolderImage = "images/empty_image_placeholder.jpg";
  static const app_logo = "images/qr_menu.png";
  static const noDataImage = "images/no_data.png";
  static const paperLess = "images/paper.png";
  static const language = "images/language.png";
  static const theme = "images/theme.png";
}

class MenuTypeName {
  static const news = "New";
  static const spicy = "Spicy";
  static const jain = "Jain";
  static const special = "Special";
  static const popular = "Popular";
  static const sweet = "Sweet";
}

class MenuTypeImage {
  static const newImage = "images/new1.png";
  static const spicyImage = "images/spicy1.png";
  static const jainImage = "images/jain.png";
  static const specialImage = "images/special1.png";
  static const popularImage = "images/popular1.png";
}

class Urls {
  static const termsAndConditionURL = 'https://www.google.com/';
  static const supportURL = 'https://iqonic.desky.support/';
  static const codeCanyonURL = '';
  static const mailto = 'hello@iqonic.design';
  static const documentation =
      'https://wordpress.iqonic.design/docs/product/qr-menu-laravel/';
  static const privacyPolicyURL = 'https://iqonic.design/privacy/';
}

class APIEndPoint {
  static const login = 'login';
  static const register = 'register';
  static const loginUser = 'login';
  static const socialLogin = 'social-login';
  static const changePassword = 'change-password';
  static const forgotPassword = 'forgot-password';
  static const updateProfile = 'update-profile';
  static const saveRestaurant = 'save-restaurant';
  static const updateRestaurant = 'update-restaurant';
  static const restaurantList = 'restaurant-list';
  static const restaurantDetail = 'restaurant-detail';
  static const deleteRestaurant = 'delete-restaurant';
  static const saveCategory = 'save-category';
  static const categoryList = 'category-list';
  static const deleteCategory = 'delete-category';
  static const saveMenu = 'save-menu';
  static const deleteMenu = 'delete-menu';
  static const removeFile = 'remove-file';
  static const userList = 'user-list';
}

enum FileTypes { CANCEL, CAMERA, GALLERY }

enum MenuType { IS_NEW, IS_SPICY, IS_JAIN, IS_SPECIAL, IS_POPULAR }

enum RestaurantType { IS_VEG, IS_NON_VEG }

class LoginTypes {
  static String restaurantManager = 'manager';
  static String admin = 'admin';
  static String loginTypeGoogle = 'LoginTypeGoogle';
  static String demoAdmin = 'demoadmin';
}
