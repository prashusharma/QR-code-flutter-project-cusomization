import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/models/UpdateProfileResponse.dart';
import 'package:qr_menu_laravel_flutter/models/UserModel.dart';
import 'package:qr_menu_laravel_flutter/network/NetworkUtils.dart';
import 'package:qr_menu_laravel_flutter/utils/CachedNetworkImage.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:qr_menu_laravel_flutter/utils/modelKeys.dart';

import '../../main.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  UserModel currentUser = UserModel();

  TextEditingController nameCont = TextEditingController();
  TextEditingController numCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();

  FocusNode contactFocus = FocusNode();

  File? imageFile;
  XFile? pickedFile;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    nameCont.text = appStore.userName;
    emailCont.text = appStore.userEmail;
    numCont.text = appStore.contactNumber;
    passCont.text = appStore.password;

    setState(() {});
  }

  void _getFromGallery() async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile!.path);
      setState(() {});
    }
  }

  _getFromCamera() async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile!.path);
      setState(() {});
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: language.lblGallery,
              leading: Icon(Icons.image, color: primaryColor),
              onTap: () {
                _getFromGallery();
                finish(context);
              },
            ),
            Divider(),
            SettingItemWidget(
              title: language.camera,
              leading: Icon(Icons.camera, color: primaryColor),
              onTap: () {
                _getFromCamera();
                finish(context);
              },
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> updateProfile() async {
    appStore.setLoading(true);
    MultipartRequest multiPartRequest = await getMultiPartRequest(APIEndPoint.updateProfile);
    multiPartRequest.fields[Users.userName] = nameCont.text;
    multiPartRequest.fields[Users.contactNumber] = numCont.text;
    multiPartRequest.fields[Users.email] = emailCont.text;

    if (imageFile != null) {
      multiPartRequest.files.add(await MultipartFile.fromPath(Users.profileImage, imageFile!.path));
    } else {
      cachedImage(appStore.userProfileImage, fit: BoxFit.cover);
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());

    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        toast(language.lblUpdateSuccessfully, print: true);

        UpdateProfileResponse res = UpdateProfileResponse.fromJson(jsonDecode(data));
        appStore.setUserEmail(res.data!.email.validate());
        appStore.setUserName(res.data!.username.validate());
        appStore.setUserType(res.data!.userType.validate());
        appStore.setUserProfile(res.data!.profileImage.validate());
        appStore.setContactNumber(res.data!.contactNumber.validate());
        toast(res.message.validate());

        finish(context);
      },
      onError: (error) {
        appStore.setLoading(false);
        toast(error.toString(), print: true);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: appBarWidget(
          '${language.lblEditProfile}',
          color: context.scaffoldBackgroundColor,
          elevation: 0,
          backWidget: IconButton(
            onPressed: () {
              finish(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: context.iconColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Divider(thickness: 1, color: context.dividerColor, indent: 16, endIndent: 16),
              20.height,
              Stack(
                children: [
                  imageFile != null
                      ? Image.file(imageFile!, width: 140, height: 140, fit: BoxFit.cover).cornerRadiusWithClipRRect(70)
                      : Observer(
                          builder: (_) => cachedImage(
                            appStore.userProfileImage,
                            height: 140,
                            width: 140,
                            fit: BoxFit.cover,
                          ).cornerRadiusWithClipRRect(70),
                        ),
                  Positioned(
                    bottom: 8,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: boxDecorationWithRoundedCorners(
                        boxShape: BoxShape.circle,
                        backgroundColor: primaryColor,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Image.asset('images/icons/ic_Camera.png', height: 20, width: 20, fit: BoxFit.cover, color: white),
                    ).onTap(() async {
                      _showBottomSheet(context);
                    }),
                  ).visible(!isSocialLogin)
                ],
              ),
              16.height,
              Container(
                constraints: BoxConstraints(maxWidth: 500),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
                padding: EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${language.lblEnterYourProfileDetails}', style: boldTextStyle()),
                      18.height,
                      AppTextField(
                        textInputAction: TextInputAction.next,
                        controller: nameCont,
                        nextFocus: contactFocus,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(context, label: '${language.lblName}').copyWith(
                          prefixIcon: Image.asset('images/icons/ic_User.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                        ),
                      ),
                      16.height,
                      AppTextField(
                        textInputAction: TextInputAction.done,
                        controller: emailCont,
                        readOnly: true,
                        textFieldType: TextFieldType.EMAIL,
                        enabled: currentUser.isEmailLogin,
                        decoration: inputDecoration(context, label: '${language.lblEmail}').copyWith(
                          prefixIcon: Image.asset('images/icons/ic_Message.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                        ),
                      ),
                      16.height,
                      AppTextField(
                        textInputAction: TextInputAction.done,
                        controller: numCont,
                        focus: contactFocus,
                        maxLength: 12,
                        textFieldType: TextFieldType.PHONE,
                        buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                        decoration: inputDecoration(context, label: '${language.lblNumber}').copyWith(
                          prefixIcon: Image.asset('images/icons/ic_Phone.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                        ),
                      ),
                      32.height,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ).visible(!appStore.isLoading, defaultWidget: Loader()),
        bottomNavigationBar: AppButton(
          text: language.lblSave.toUpperCase(),
          textStyle: boldTextStyle(color: Colors.white, size: 18),
          margin: EdgeInsets.all(16),
          elevation: 0,
          color: primaryColor,
          enabled: appStore.isLoading ? false : true,
          shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultAppButtonRadius)),
          onTap: () {
            showConfirmDialogCustom(
              context,
              dialogType: DialogType.UPDATE,
              title: '${language.lbDoYouWantToUpdateProfile}?',
              onAccept: (context) async {
                hideKeyboard(context);
                if (!getBoolAsync(SharePreferencesKey.IS_DEMO_ADMIN)) {
                  await updateProfile();
                } else {
                  toast(language.lblDemoUserText);
                }
              },
            );
          },
        ).visible(!appStore.isLoading),
      ),
    );
  }
}
