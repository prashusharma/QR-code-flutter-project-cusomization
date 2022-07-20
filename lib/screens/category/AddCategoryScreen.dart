import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/components/ImageOptionComponent.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/AddCategoryResponse.dart';
import 'package:qr_menu_laravel_flutter/models/GetCategoryListResponse.dart';
import 'package:qr_menu_laravel_flutter/network/NetworkUtils.dart';
import 'package:qr_menu_laravel_flutter/network/RestApis.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:qr_menu_laravel_flutter/utils/modelKeys.dart';

class AddCategoryScreen extends StatefulWidget {
  final Category? categoryData;
  final int? restaurantId;

  AddCategoryScreen({this.categoryData, this.restaurantId});

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isUpdate = false;

  File? image;
  String? categoryImage = '';

  TextEditingController nameCont = TextEditingController();
  TextEditingController descCont = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode descFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.categoryData != null;
    if (isUpdate) {
      nameCont.text = widget.categoryData!.name.validate();
      descCont.text = widget.categoryData!.description.validate();
      categoryImage = widget.categoryData!.categoryImage.validate();
      setState(() {});
    }
  }

  Future<void> saveData() async {
    appStore.setLoading(true);

    MultipartRequest multiPartRequest = await getMultiPartRequest(APIEndPoint.saveCategory);
    if (isUpdate) multiPartRequest.fields[CommonKeys.id] = widget.categoryData!.id.toString().validate();

    multiPartRequest.fields[Categories.restaurantId] = isUpdate ? widget.categoryData!.restaurantId.toString().validate() : widget.restaurantId.toString().validate();
    multiPartRequest.fields[Categories.name] = nameCont.text.validate();
    multiPartRequest.fields[Categories.description] = descCont.text.validate();

    if (image != null) multiPartRequest.files.add(await MultipartFile.fromPath(Categories.categoryImage, image!.path));

    multiPartRequest.headers.addAll(buildHeaderTokens());

    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        AddCategoryResponse res = AddCategoryResponse.fromJson(jsonDecode(data));

        toast(res.message.validate(), print: true);
        appStore.setIsAll(true);

        finish(context, true);
      },
      onError: (error) {
        toast(error.toString(), print: true);
      },
    ).catchError((e) {
      toast(e.toString(), print: true);
    }).whenComplete(() => appStore.setLoading(false));
  }

  Future<void> deleteData() async {
    appStore.setLoading(true);
    Map request = {
      CommonKeys.id: widget.categoryData!.id,
    };
    await deleteCategory(request: request).then((value) {
      toast(language.lblDeleteSuccessfully);
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() {
      appStore.setLoading(false);
      appStore.setIsAll(true);

      finish(context);
    });
  }

  void updateData() {
    hideKeyboard(context);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      showConfirmDialogCustom(
        context,
        dialogType: isUpdate ? DialogType.UPDATE : DialogType.ADD,
        title: isUpdate ? '${language.lblDoYouWantToUpdate} ${widget.categoryData!.name}?' : '${language.lblDoYouWantToAddThisCategory}?',
        onAccept: (context) {
          hideKeyboard(context);

          if (!getBoolAsync(SharePreferencesKey.IS_DEMO_ADMIN))
            saveData();
          else
            toast(language.lblDemoUserText);
        },
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? '${language.lblUpdate}' : '${language.lblAddCategory}',
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: context.iconColor),
            onPressed: () {
              showConfirmDialogCustom(
                context,
                onAccept: (c) {
                  deleteData();
                },
                dialogType: DialogType.DELETE,
                title: '${language.lblTextForDeletingCategory} ${widget.categoryData!.name}?',
              );
            },
          ).visible(isUpdate),
        ],
        elevation: 0,
        color: context.scaffoldBackgroundColor,
        backWidget: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: 500),
              padding: EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Divider(thickness: 1, color: context.dividerColor),
                    16.height,
                    isUpdate
                        ? ImageOptionComponent(
                            id: widget.categoryData!.id,
                            isRes: false,
                            defaultImage: categoryImage,
                            name: language.lblAddImage,
                            onImageSelected: (File? value) async {
                              image = value;
                              categoryImage = value!.path;
                              setState(() {});
                            },
                          ).center().withSize(width: context.width() - 32, height: 230)
                        : ImageOptionComponent(
                            isRes: false,
                            defaultImage: categoryImage,
                            name: language.lblAddImage,
                            onImageSelected: (File? value) async {
                              image = value;
                              categoryImage = value!.path;
                              setState(() {});
                            },
                          ).center().withSize(width: context.width() - 32, height: 230),
                    32.height,
                    Container(
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
                      padding: EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${language.lblEnterCategoryDetails}', style: boldTextStyle()),
                          18.height,
                          AppTextField(
                            controller: nameCont,
                            textFieldType: TextFieldType.NAME,
                            textStyle: primaryTextStyle(),
                            focus: nameFocus,
                            nextFocus: descFocus,
                            decoration: inputDecoration(
                              context,
                              label: '${language.lblCategory.capitalizeFirstLetter()} ${language.lblName}',
                              textStyle: secondaryTextStyle(color: bodyColor),
                            ).copyWith(
                              prefixIcon: Image.asset('images/icons/ic_Draft.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                            ),
                          ),
                          18.height,
                          AppTextField(
                            controller: descCont,
                            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                            maxLines: 8,
                            minLines: 3,
                            textFieldType: TextFieldType.MULTILINE,
                            focus: descFocus,
                            textStyle: primaryTextStyle(),
                            textInputAction: TextInputAction.done,
                            decoration: inputDecoration(
                              context,
                              label: '${language.lblCategory.capitalizeFirstLetter()} ${language.lblDescription}',
                              textStyle: secondaryTextStyle(color: bodyColor),
                            ).copyWith(
                              prefixIcon: Image.asset('images/icons/ic_Draft.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).center(),
          ),
          Observer(builder: (_) => Loader().center().visible(appStore.isLoading)),
        ],
      ),
      bottomNavigationBar: Observer(
        builder: (_) => AppButton(
          text: language.lblSave.toUpperCase(),
          textStyle: boldTextStyle(color: Colors.white, size: 18),
          margin: EdgeInsets.all(16),
          elevation: 0,
          color: primaryColor,
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
