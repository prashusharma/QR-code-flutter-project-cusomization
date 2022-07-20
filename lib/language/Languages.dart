import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage? of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage);

  String get lblLanguage;

  String get lblUpdateIngredient;

  String get lblAddIngredient;

  String get lblName;

  String get lblCancel;

  String get lblUpdate;

  String get lblAdd;

  String get lblNew;

  String get lblCategories;

  String get lblLongPressOnCategoryForMoreOptions;

  String get lblA;

  String get lblAll;

  String get lblChooseCurrencySymbol;

  String get lblCamera;

  String get lblGallery;

  String get lblForgetPassword;

  String get lblEnterYouEmail;

  String get lblEmail;

  String get lblEnterValidEmail;

  String get lblResetPassword;

  String get lblResetPasswordLinkHasSentYourMail;

  String get lblTextForDeletingCategory;

  String get lblWrongSelection;

  String get lblEdit;

  String get lblDelete;

  String get lblSpicy;

  String get lblJain;

  String get lblSpecial;

  String get lblPopular;

  String get lblMenuItems;

  String get lblNoMenuFor;

  String get lblCategory;

  String get lblNoData;

  String get lblLight;

  String get lblDark;

  String get lblSystemDefault;

  String get lblAbout;

  String get lblVersion;

  String get lblPurchase;

  String get lblAddImage;

  String get lblChooseAnAction;

  String get lblAddCategory;

  String get lblDoYouWantToUpdate;

  String get lblDoYouWantToAddThisCategory;

  String get lblDescription;

  String get lblAddMenuItem;

  String get lblDoYouWantToDelete;

  String get lblDoYouWantToAddThisMenuItem;

  String get lblChooseCategory;

  String get lblPrice;

  String get lblIngredients;

  String get lblNewDescription;

  String get lblVeg;

  String get lblVegDescription;

  String get lblSpicyDescription;

  String get lblJainDescription;

  String get lblSpecialDescription;

  String get lblSweet;

  String get lblSweetDescription;

  String get lblPopularDescription;

  String get lblAddLogoImage;

  String get lblAddRestaurantImage;

  String get lblUpdateRestaurant;

  String get lblAddRestaurant;

  String get lblDoYouWantToUpdateRestaurant;

  String get lblDoYouWantToAddRestaurant;


  String get lblNonVeg;

  String get lblContact;

  String get lblCurrency;

  String get lblNewItemValidity;

  String get lblAddress;

  String get lblPasswordSuccessfullyChanged;

  String get lblOldPassword;

  String get lblOldPasswordIsNotCorrect;

  String get lblNewPassword;

  String get lblConfirmPassword;

  String get lblPasswordLengthShouldBeMoreThanSix;

  String get lblBothPasswordShouldBeMatched;

  String get lblOldPasswordShouldNotBeSameAsNewPassword;

  String get lblSave;

  String get lblHello;

  String get lblNoRestaurant;

  String get lbDoYouWantToUpdateProfile;

  String get lblEditProfile;

  String get lblNumber;

  String get lblTryAgain;

  String get lblQR;

  String get lblScanForOurOnlineMenu;

  String get lblUhOhSomethingWentWrong;

  String get lblScanned;

  String get lblNoPermission;

  String get lblDoYouWantToDeleteRestaurant;

  String get lblSettings;

  String get lblChangePassword;

  String get lblUserLoginWithSocialAccountCannotChangeThePassword;

  String get lblDarkMode;

  String get lblPrivacyPolicy;

  String get lblRateUs;

  String get lblTerms;

  String get lblShare;

  String get lblLogout;

  String get lblPassword;

  String get lblForgotPassword;

  String get lblDontHaveAnAccount;

  String get lblAlreadyHaveAccount;

  String get lblGoPaperless;

  String get lblGoPaperlessWithOurDigitalMenu;

  String get lblGetStarted;

  String get lblRemoveImage;

  String get lblSelectLanguage;

  String get lblSelectTheme;

  String get lblSelectThemeDesc;

  String get lblSelectLanguageDesc;

  String get lblHelpSupport;

  String get lblSetMenuStyle;

  String get lblSetQrStyle;

  String get lblMenuStyle1;

  String get lblMenuStyle2;

  String get lblMenuStyle3;

  String get lblMenuStyle4;

  String get lblMenuStyle5;

  String get lblMenuStyle6;

  String get lblQrStyle1;

  String get lblQrStyle2;

  String get lblQrStyle3;

  String get camera;

  String get selectImgNote;

  String get lblMyRestaurant;

  String get lblAddRestaurantManager;

  String get lblUpdateSuccessfully;

  String get lblLoginSuccessFully;

  String get lblScanQRCode;

  String get lblDeleteSuccessfully;

  String get lblAreYouSureWantToRemoveThisImage;

  String get lblChooseMenuItemImages;

  String get lblYouCantThisIsVegRestaurant;

  String get lblYouCantThisIsNonVegRestaurant;

  String get lblChooseRestaurantImages;

  String get lblItemsInCart;

  String get lblViewCart;

  String get lblCart;

  String get lblRemove;

  String get lblAddItem;

  String get lblTips;

  String get lblItemTotal;

  String get lblDiscount;

  String get lblTotalAmount;

  String get lblNoCategory;

  String get lblImageSupport;

  String get lblChooseImage;

  String get lblAreYouSureYouWantToLogOut;

  String get lblSelectQRStyles;

  String get lblYourRestaurantName;

  String get lblEmailAddress;

  String get lblRememberMe;

  String get lblLogin;

  String get lblOrContinueWith;

  String get lblGoogle;

  String get lblApple;

  String get lblRegister;

  String get lblYour;

  String get lblAddManager;

  String get lblYouCanAlsoAddManger;

  String get lblResetYourPassword;

  String get lblResetPasswordText;

  String get lblEnterYourProfileDetails;

  String get lblHelloUserWelcomeToQR;

  String get lblWelcomeBackText;

  String get lblEnterCategoryDetails;

  String get lblEnterFoodItemDetails;

  String get lblOtherDetailsToAdd;

  String get lblSelectMenuStyles;

  String get lblStyle;

  String get lblSelectManager;

  String get lblEnterRestaurantDetails;

  String get lblWelcomeBackHaveANiceDay;

  String get lblSearchYourRestaurant;

  String get lblAppLanguage;

  String get lblAddToCart;

  String get lblAmount;

  String get lblSkip;

  String get lblDemoUserText;

  String get lblListening;

  String get lblTapToSpeak;

  String get lblEmptyCart;
}
