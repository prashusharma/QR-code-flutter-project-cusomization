import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/components/ImageOptionComponent.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/CurrencyModel.dart';
import 'package:qr_menu_laravel_flutter/models/GetRestaurantListResponse.dart';
import 'package:qr_menu_laravel_flutter/models/ImageModel.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantResponse.dart';
import 'package:qr_menu_laravel_flutter/models/UserListModel.dart';
import 'package:qr_menu_laravel_flutter/network/NetworkUtils.dart';
import 'package:qr_menu_laravel_flutter/network/RestApis.dart';
import 'package:qr_menu_laravel_flutter/screens/restaurant/CurrencyScreen.dart';
import 'package:qr_menu_laravel_flutter/screens/restaurant/components/UserListDropdownComponent.dart';
import 'package:qr_menu_laravel_flutter/utils/CachedNetworkImage.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:qr_menu_laravel_flutter/utils/modelKeys.dart';

class AddRestaurantScreen extends StatefulWidget {
  final Restaurant? data;
  final int? userId;

  AddRestaurantScreen({this.userId, this.data});

  @override
  _AddRestaurantScreenState createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController idCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();
  TextEditingController mailCont = TextEditingController();
  TextEditingController contactCont = TextEditingController();
  TextEditingController currencyCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController descCont = TextEditingController();
  TextEditingController dateCont = TextEditingController();
  TextEditingController discountCont = TextEditingController();

  List<File> restaurantFiles = [];
  List<ImageModel> restImageFiles = [];

  FocusNode nameNode = FocusNode();
  FocusNode mailNode = FocusNode();
  FocusNode contactNode = FocusNode();
  FocusNode currencyNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode descNode = FocusNode();
  FocusNode dateNode = FocusNode();
  FocusNode discountNode = FocusNode();
  CurrencyModel? sel = CurrencyModel();

  bool isVeg = false;
  bool isNonVeg = false;
  bool isUpdate = false;
  bool isCheck = false;

  File? logoImage;
  String restaurantLogo = '';

  String currency = '';
  UserData? selectedManager;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    restaurantFiles.clear();
    restImageFiles.clear();
    isUpdate = widget.data != null;

    if (isUpdate) {
      isVeg = widget.data!.isVeg == 1 ? true : false;
      isNonVeg = widget.data!.isNonVeg == 1 ? true : false;
      nameCont.text = widget.data!.name.validate();
      mailCont.text = widget.data!.email.validate();
      contactCont.text = widget.data!.contactNumber.validate();
      addressCont.text = widget.data!.address.validate();
      descCont.text = widget.data!.description.validate();
      dateCont.text = widget.data!.newItemValidity.validate().toString();
      restaurantLogo = widget.data!.restaurantLogo.validate();
      discountCont.text = widget.data!.discount.toString().validate();

      sel = CurrencyModel(symbol: widget.data!.currency);

      CurrencyModel.getCurrencyList().forEach((element) {
        if (element.symbol == widget.data!.currency.validate()) {
          currencyCont.text = "${element.symbol.validate()} ${element.name.validate()}";
          currency = widget.data!.currency.validate();
        }
      });

      restImageFiles.addAll(widget.data!.restaurantImage!);
    }

    if (appStore.isAdmin) await getUser();

    if (appStore.isAdmin && userList.isNotEmpty) {
      selectedManager = userList.first;
    }
    setState(() {});
  }

  Future<void> getUser() async {
    appStore.setLoading(true);
    userList.clear();

    Map request = {
      Users.userType: LoginTypes.restaurantManager,
    };

    await getUserList(request: request).then((value) {
      userList.addAll(value.data!);
      log('User Length: ${userList.length}');

      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }

  Future<void> saveData() async {
    appStore.setLoading(true);

    MultipartRequest multiPartRequest = await getMultiPartRequest(APIEndPoint.saveRestaurant);
    if (isUpdate) multiPartRequest.fields[CommonKeys.id] = widget.data!.id.toString().validate();

    if (appStore.isAdmin) multiPartRequest.fields[Restaurants.managerId] = selectedManager!.id.toString().validate();

    multiPartRequest.fields[Restaurants.name] = nameCont.text;
    multiPartRequest.fields[Restaurants.email] = mailCont.text;
    multiPartRequest.fields[Restaurants.contact] = contactCont.text;
    multiPartRequest.fields[Restaurants.currency] = currency;
    multiPartRequest.fields[Restaurants.newItemForDays] = dateCont.text;
    multiPartRequest.fields[Restaurants.address] = addressCont.text;
    multiPartRequest.fields[Restaurants.description] = descCont.text;
    multiPartRequest.fields[Restaurants.managerId] = appStore.userId.toString();
    multiPartRequest.fields[Restaurants.name] = nameCont.text;
    multiPartRequest.fields[Restaurants.discount] = discountCont.text;
    multiPartRequest.fields[Restaurants.isVeg] = isVeg ? '1' : '0';
    multiPartRequest.fields[Restaurants.isNonVeg] = isNonVeg ? '1' : '0';

    if (logoImage != null) multiPartRequest.files.add(await MultipartFile.fromPath(Restaurants.restaurantLogo, logoImage!.path));

    if (restaurantFiles.isNotEmpty) {
      await Future.forEach<File>(restaurantFiles, (element) async {
        log(Restaurants.restaurantImage + '_${restaurantFiles.indexOf(element)}');
        multiPartRequest.files.add(await MultipartFile.fromPath(Restaurants.restaurantImage + '_${restaurantFiles.indexOf(element)}', element.path));
      });
    }
    if (restaurantFiles.isNotEmpty) multiPartRequest.fields[CommonKeys.attachmentCount] = restaurantFiles.length.toString();

    multiPartRequest.headers.addAll(buildHeaderTokens());

    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        RestaurantResponse res = RestaurantResponse.fromJson(jsonDecode(data));

        toast(res.message.validate(), print: true);
        finish(context, true);
      },
      onError: (error) {
        toast(error.toString(), print: true);
      },
    ).whenComplete(() => appStore.setLoading(false));
  }

  Future<void> updateData() async {
    hideKeyboard(context);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (isVeg == false && isNonVeg == false) {
        isCheck = true;
      } else {
        showConfirmDialogCustom(
          context,
          dialogType: isUpdate ? DialogType.UPDATE : DialogType.ADD,
          title: isUpdate ? '${language.lblDoYouWantToUpdateRestaurant}?' : '${language.lblDoYouWantToAddRestaurant}?',
          onAccept: (context) {
            hideKeyboard(context);

            if (!getBoolAsync(SharePreferencesKey.IS_DEMO_ADMIN))
              saveData();
            else
              toast(language.lblDemoUserText);
          },
        );
      }
    } else {
      if (isVeg == false && isNonVeg == false) {
        isCheck = true;
      }
    }
    setState(() {});
  }

  Future<void> removeFiles({ImageModel? restData, bool isFiles = false, File? fileData}) async {
    showConfirmDialogCustom(
      context,
      dialogType: DialogType.DELETE,
      title: language.lblAreYouSureWantToRemoveThisImage,
      onAccept: (context) async {
        hideKeyboard(context);
        if (!isFiles) {
          Map request = {
            Restaurants.type: Restaurants.restaurantImage,
            CommonKeys.id: restData!.id.validate(),
          };

          log(request);

          appStore.setLoading(true);
          await deleteImage(request).then((value) {
            restImageFiles.remove(restData);
            toast(language.lblDeleteSuccessfully);
          }).catchError((e) {
            toast(e.toString());
          }).whenComplete(() => appStore.setLoading(false));
        } else {
          appStore.setLoading(true);
          await 1.milliseconds.delay;
          appStore.setLoading(false);
          toast(language.lblDeleteSuccessfully);
          restaurantFiles.remove(fileData!);
        }
        setState(() {});
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: appBarWidget(
          isUpdate ? '${language.lblUpdateRestaurant}' : '${language.lblAddRestaurant}',
          color: context.scaffoldBackgroundColor,
          elevation: 0,
          backWidget: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: context.iconColor),
            onPressed: () {
              finish(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(thickness: 1, color: context.dividerColor),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      16.height,
                      isUpdate
                          ? ImageOptionComponent(
                              isRes: true,
                              id: widget.data!.id,
                              defaultImage: restaurantLogo,
                              name: language.lblAddLogoImage,
                              onImageSelected: (File? value) async {
                                logoImage = value;
                                restaurantLogo = value!.path;
                                setState(() {});
                              },
                            )
                          : ImageOptionComponent(
                              isRes: true,
                              defaultImage: restaurantLogo,
                              name: language.lblAddLogoImage,
                              onImageSelected: (File? value) async {
                                logoImage = value;
                                restaurantLogo = value!.path;
                                setState(() {});
                              },
                            ),
                    ],
                  ).center(),
                  16.height,
                  Container(
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.center,
                    decoration: boxDecorationWithShadow(blurRadius: 0, borderRadius: radius(8), backgroundColor: context.cardColor),
                    child: Column(
                      children: [
                        Icon(Icons.add, size: 28, color: context.iconColor),
                        8.height,
                        Text(language.lblChooseRestaurantImages, style: secondaryTextStyle()),
                      ],
                    ),
                  ).onTap(() async {
                    restaurantFiles.addAll(await getMultipleFile());
                    setState(() {});
                  }),
                  8.height,
                  Text(language.selectImgNote, style: secondaryTextStyle(size: 8, color: Colors.red)),
                  16.height,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (restaurantFiles.isNotEmpty)
                          HorizontalList(
                              itemCount: restaurantFiles.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Image.file(restaurantFiles[i], width: 100, height: 100, fit: BoxFit.cover).cornerRadiusWithClipRRect(6),
                                    Icon(Icons.delete, color: white).onTap(() {
                                      removeFiles(fileData: restaurantFiles[i], isFiles: true);
                                    }),
                                  ],
                                );
                              }).paddingBottom(16),
                        if (restImageFiles.isNotEmpty)
                          HorizontalList(
                              itemCount: restImageFiles.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    cachedImage(restImageFiles[i].url.validate(), width: 100, height: 100, fit: BoxFit.cover).cornerRadiusWithClipRRect(6),
                                    Icon(Icons.delete, color: white).onTap(() async {
                                      removeFiles(restData: restImageFiles[i]);
                                    }),
                                  ],
                                );
                              }).paddingBottom(16),
                      ],
                    ),
                  ),
                  16.height,
                  Container(
                    decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
                    padding: EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${language.lblEnterRestaurantDetails}', style: boldTextStyle()),
                        16.height,
                        if (appStore.isAdmin && userList.isNotEmpty)
                          UserListDropdownComponent(
                            isValidate: true,
                            userData: userList,
                            defaultValue: selectedManager,
                            onValueChanged: (value) async {
                              selectedManager = value;
                              toast(selectedManager!.id.toString().validate());
                              await 1.seconds.delay;
                            },
                          ),
                        if (appStore.isAdmin && userList.isNotEmpty) 16.height,
                        AppTextField(
                          controller: nameCont,
                          textFieldType: TextFieldType.NAME,
                          focus: nameNode,
                          nextFocus: mailNode,
                          decoration: inputDecoration(context, label: "${language.lblName}", textStyle: secondaryTextStyle(color: bodyColor)).copyWith(
                            prefixIcon: Image.asset('images/icons/ic_User.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                          ),
                        ),
                        16.height,
                        AppTextField(
                          controller: mailCont,
                          textFieldType: TextFieldType.EMAIL,
                          focus: mailNode,
                          nextFocus: contactNode,
                          decoration: inputDecoration(
                            context,
                            label: "${language.lblEmail}",
                            textStyle: secondaryTextStyle(color: bodyColor),
                          ).copyWith(
                            prefixIcon: Image.asset('images/icons/ic_Message.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                          ),
                        ),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: context.dividerColor), borderRadius: radius(8)),
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                              margin: EdgeInsets.only(right: 8),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      isVeg = !isVeg;
                                      setState(() {});
                                    },
                                    child: isVeg
                                        ? Container(
                                            decoration: BoxDecoration(color: primaryColor, borderRadius: radius(4)),
                                            child: Icon(Icons.check, color: Colors.white, size: 20),
                                          )
                                        : Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(color: primaryColor.withAlpha(30), borderRadius: radius(4)),
                                          ),
                                  ),
                                  12.width,
                                  Text('${language.lblVeg}', style: secondaryTextStyle(color: bodyColor)),
                                ],
                              ),
                            ).onTap(() {
                              isVeg = !isVeg;
                              setState(() {});
                            }).expand(),
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: context.dividerColor), borderRadius: radius(8)),
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                              margin: EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      isNonVeg = !isNonVeg;
                                      setState(() {});
                                    },
                                    child: isNonVeg
                                        ? Container(
                                            decoration: BoxDecoration(color: primaryColor, borderRadius: radius(4)),
                                            child: Icon(Icons.check, color: Colors.white, size: 20),
                                          )
                                        : Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(color: primaryColor.withAlpha(30), borderRadius: radius(4)),
                                          ),
                                  ),
                                  12.width,
                                  Text('${language.lblNonVeg}', style: secondaryTextStyle(color: bodyColor)),
                                ],
                              ),
                            ).onTap(() {
                              isNonVeg = !isNonVeg;
                              setState(() {});
                            }).expand(),
                          ],
                        ),
                        16.height,
                        AppTextField(
                          controller: contactCont,
                          focus: contactNode,
                          nextFocus: currencyNode,
                          textFieldType: TextFieldType.PHONE,
                          textInputAction: TextInputAction.next,
                          decoration: inputDecoration(
                            context,
                            label: "${language.lblContact}",
                            textStyle: secondaryTextStyle(color: bodyColor),
                          ).copyWith(
                            prefixIcon: Image.asset('images/icons/ic_Phone.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(12),
                          ],
                        ),
                        16.height,
                        AppTextField(
                          controller: currencyCont,
                          readOnly: true,
                          textFieldType: TextFieldType.NAME,
                          focus: currencyNode,
                          nextFocus: dateNode,
                          decoration: inputDecoration(
                            context,
                            label: "${language.lblCurrency}",
                            textStyle: secondaryTextStyle(color: bodyColor),
                          ).copyWith(prefixIcon: Icon(LineIcons.money_bill, color: bodyColor, size: 20)),
                          onTap: () async {
                            sel = await push(CurrencyScreen(selectedCurrency: sel));
                            if (sel != null) {
                              currencyCont.text = "${sel!.symbol.validate()} ${sel!.name.validate()}";
                              currency = sel!.symbol.validate();
                              setState(() {});
                            }
                          },
                        ),
                        16.height,
                        AppTextField(
                          controller: dateCont,
                          textFieldType: TextFieldType.PHONE,
                          focus: dateNode,
                          nextFocus: discountNode,
                          minLines: 1,
                          isValidationRequired: true,
                          decoration: inputDecoration(
                            context,
                            label: "${language.lblNewItemValidity}",
                            textStyle: secondaryTextStyle(color: bodyColor),
                          ).copyWith(
                            prefixIcon: Image.asset('images/icons/ic_Notebook.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                          ),
                        ),
                        16.height,
                        AppTextField(
                          controller: discountCont,
                          textFieldType: TextFieldType.PHONE,
                          focus: discountNode,
                          nextFocus: addressNode,
                          minLines: 1,
                          isValidationRequired: true,
                          decoration: inputDecoration(
                            context,
                            label: "${language.lblDiscount}",
                            textStyle: secondaryTextStyle(color: bodyColor),
                          ).copyWith(
                            prefixIcon: Image.asset('images/icons/ic_Notebook.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                          ),
                        ),
                        16.height,
                        AppTextField(
                          controller: addressCont,
                          textInputAction: TextInputAction.next,
                          minLines: 2,
                          focus: addressNode,
                          nextFocus: descNode,
                          textFieldType: TextFieldType.MULTILINE,
                          decoration: inputDecoration(
                            context,
                            label: "${language.lblAddress}",
                            textStyle: secondaryTextStyle(color: bodyColor),
                          ).copyWith(
                            prefixIcon: Image.asset('images/icons/ic_Location.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                          ),
                        ),
                        16.height,
                        AppTextField(
                          textInputAction: TextInputAction.done,
                          controller: descCont,
                          textFieldType: TextFieldType.MULTILINE,
                          focus: descNode,
                          minLines: 3,
                          decoration: inputDecoration(
                            context,
                            label: "${language.lblDescription}",
                            textStyle: secondaryTextStyle(color: bodyColor),
                          ).copyWith(
                            prefixIcon: Image.asset('images/icons/ic_Draft.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  50.height,
                ],
              ),
            ).paddingSymmetric(horizontal: 16),
          ).center(),
        ).visible(!appStore.isLoading, defaultWidget: Loader()),
        bottomNavigationBar: AppButton(
          text: language.lblSave.toUpperCase(),
          textStyle: boldTextStyle(color: Colors.white, size: 18),
          margin: EdgeInsets.all(16),
          color: primaryColor,
          elevation: 0,
          enabled: appStore.isLoading ? false : true,
          shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultAppButtonRadius)),
          onTap: () {
            updateData();
          },
        ).visible(!appStore.isLoading),
      ),
    );
  }
}
