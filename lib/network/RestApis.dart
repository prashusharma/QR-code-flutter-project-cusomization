import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/ForgotPasswordResponse.dart';
import 'package:qr_menu_laravel_flutter/models/GetCategoryListResponse.dart';
import 'package:qr_menu_laravel_flutter/models/GetRestaurantListResponse.dart';
import 'package:qr_menu_laravel_flutter/models/LoginResponse.dart';
import 'package:qr_menu_laravel_flutter/models/RegisterResponse.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/models/UserListModel.dart';
import 'package:qr_menu_laravel_flutter/network/NetworkUtils.dart';
import 'package:qr_menu_laravel_flutter/screens/auth/SignInScreen.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';

Future<RegisterResponse> createUser(Map request) async {
  return RegisterResponse.fromJson(await (handleResponse(await buildHttpResponse(APIEndPoint.register, request: request, method: HttpMethod.POST))));
}

Future<LoginResponse> loginUser(Map request, {bool isSocialLogin = false}) async {
  LoginResponse res = LoginResponse.fromJson(await handleResponse(await buildHttpResponse(isSocialLogin ? APIEndPoint.socialLogin : APIEndPoint.login, request: request, method: HttpMethod.POST)));
  if (!isSocialLogin) appStore.setIsEmailLogin(true);
  log('${res.data!.userType.validate() == LoginTypes.admin}');

  if (res.data!.userType == LoginTypes.admin) {
    appStore.setIsAdmin(true);
  } else {
    appStore.setIsAdmin(false);
  }

  if (res.data!.userType == LoginTypes.demoAdmin) {
    appStore.setIsDemoAdmin(true);
  } else {
    appStore.setIsDemoAdmin(false);
  }

  appStore.setLoggedIn(true);
  appStore.setUserId(res.data!.id.validate());
  appStore.setUserEmail(res.data!.email.validate());
  appStore.setToken(res.data!.apiToken.validate());
  appStore.setUserName(res.data!.username.validate());
  appStore.setUserType(res.data!.userType.validate());
  appStore.setUserProfile(res.data!.profileImage.validate());
  appStore.setContactNumber(res.data!.contactNumber.validate());

  return res;
}

Future<PasswordResponse> changePassword(Map request) async {
  return PasswordResponse.fromJson(await handleResponse(await buildHttpResponse(APIEndPoint.changePassword, request: request, method: HttpMethod.POST)));
}

Future<PasswordResponse> forgotPassword(Map request) async {
  return PasswordResponse.fromJson(await handleResponse(await buildHttpResponse(APIEndPoint.forgotPassword, request: request, method: HttpMethod.POST)));
}

Future<GetRestaurantListResponse> getRestaurant({int? managerId}) async {
  return GetRestaurantListResponse.fromJson(await (handleResponse(await buildHttpResponse(
      appStore.isAdmin ? '${APIEndPoint.restaurantList}?&per_page=$perPage' : '${APIEndPoint.restaurantList}?manager_id=$managerId&per_page=$perPage',
      method: HttpMethod.GET))));
}

Future<GetCategoryListResponse> getCategory({int? restaurantId}) async {
  return GetCategoryListResponse.fromJson(await (handleResponse(await buildHttpResponse('${APIEndPoint.categoryList}?restaurant_id=$restaurantId', method: HttpMethod.GET))));
}

Future deleteCategory({Map? request}) async {
  return await handleResponse(await buildHttpResponse('${APIEndPoint.deleteCategory}', request: request, method: HttpMethod.POST));
}

Future<RestaurantDetailResponse> getRestaurantDetail({int? restaurantId}) async {
  return RestaurantDetailResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.restaurantDetail}?restaurant_id=$restaurantId', method: HttpMethod.GET)));
}

Future deleteRestaurant({Map? request}) async {
  return await handleResponse(await buildHttpResponse('${APIEndPoint.deleteRestaurant}', request: request, method: HttpMethod.POST));
}

Future deleteMenuItem({Map? request}) async {
  return await handleResponse(await buildHttpResponse('${APIEndPoint.deleteMenu}', request: request, method: HttpMethod.POST));
}

Future deleteImage(Map? request) async {
  return await handleResponse(await buildHttpResponse('${APIEndPoint.removeFile}', request: request, method: HttpMethod.POST));
}

Future<UserListModel> getUserList({Map? request}) async {
  return UserListModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.userList}?per_page=$perPage', request: request, method: HttpMethod.GET)));
}

Future<void> logout(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: primaryColor.withAlpha(30), borderRadius: radius(100)),
                child: Image.asset('images/icons/ic_Logout.png', height: 40, width: 40, fit: BoxFit.cover),
              ),
              30.height,
              Text('${language.lblAreYouSureYouWantToLogOut}', style: boldTextStyle(), textAlign: TextAlign.center),
              30.height,
              Row(
                children: [
                  AppButton(
                    text: language.lblCancel,
                    elevation: 0,
                    color: context.scaffoldBackgroundColor,
                    textStyle: boldTextStyle(color: bodyColor),
                    onTap: () {
                      finish(context);
                    },
                  ).expand(),
                  16.width,
                  AppButton(
                    text: language.lblLogout,
                    textStyle: boldTextStyle(color: Colors.white),
                    elevation: 0,
                    color: primaryColor,
                    onTap: () async {

                      if(!appStore.doRemember){
                        await appStore.setUserId(0);
                        await appStore.setUserEmail('');
                        await appStore.setPassword('');
                        await appStore.setUserName('');
                        await appStore.setToken('');
                        await appStore.setPassword('');
                        await appStore.setLoggedIn(false);
                        await appStore.setIsEmailLogin(false);
                        await appStore.setIsAdmin(false);
                      }

                      SignInScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Scale, isNewTask: true, duration: 450.milliseconds);
                    },
                  ).expand()
                ],
              )
            ],
          ),
        ),
      );
    },
  );

}


