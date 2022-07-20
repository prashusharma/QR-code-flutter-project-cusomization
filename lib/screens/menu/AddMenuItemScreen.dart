import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/AddMenuItemResponse.dart';
import 'package:qr_menu_laravel_flutter/models/GetCategoryListResponse.dart';
import 'package:qr_menu_laravel_flutter/models/ImageModel.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';
import 'package:qr_menu_laravel_flutter/network/NetworkUtils.dart';
import 'package:qr_menu_laravel_flutter/network/RestApis.dart';
import 'package:qr_menu_laravel_flutter/screens/menu/component/CategoryDropdownComponent.dart';
import 'package:qr_menu_laravel_flutter/screens/menu/component/MenuItemDetailComponent.dart';
import 'package:qr_menu_laravel_flutter/utils/CachedNetworkImage.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:qr_menu_laravel_flutter/utils/modelKeys.dart';

import 'component/AddIngredientDialogComponent.dart';

class AddMenuItemScreen extends StatefulWidget {
  final RestaurantDetailResponse? data;
  final Menu? menuData;

  AddMenuItemScreen({this.data, this.menuData});

  @override
  AddMenuItemScreenState createState() => AddMenuItemScreenState();
}

class AddMenuItemScreenState extends State<AddMenuItemScreen> {
  var _formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();
  TextEditingController descCont = TextEditingController();
  TextEditingController categoryCont = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  FocusNode descFocus = FocusNode();
  FocusNode categoryFocus = FocusNode();

  Category? selectedCategory;

  String? currencySymbol = '';

  bool isUpdate = false;
  bool ingredientUpdate = false;
  bool isNew = true;
  bool isVeg = false;
  bool isSpicy = false;
  bool isJain = false;
  bool isSpecial = false;
  bool isSweet = false;
  bool isPopular = false;

  List<Category> categoryList = [];

  List<File> menuItemFiles = [];
  List<ImageModel> itemImageFiles = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    menuItemFiles.clear();
    itemImageFiles.clear();
    isUpdate = widget.menuData != null;

    ingredient.clear();
    categoryList = widget.data!.category.validate();
    currencySymbol = widget.data!.restaurantDetail!.currency.validate();

    if (isUpdate) {
      widget.data!.category!.forEach((element) {
        if (element.id == widget.menuData!.categoryId) {
          selectedCategory = element;
        }
      });

      nameCont.text = widget.menuData!.name.validate();
      priceCont.text = widget.menuData!.price.toString().validate();
      descCont.text = widget.menuData!.description.validate();
      itemImageFiles.addAll(widget.menuData!.menuImage.validate());
      isVeg = widget.data!.restaurantDetail!.isVeg.validate() == 1 ? true : false;
      isVeg = widget.menuData!.isVeg == 1 ? true : false;
      isSpicy = widget.menuData!.isSpicy == 1 ? true : false;
      isJain = widget.menuData!.isJain == 1 ? true : false;
      isSpecial = widget.menuData!.isSpecial == 1 ? true : false;
      isSweet = widget.menuData!.isSweet == 1 ? true : false;
      isPopular = widget.menuData!.isPopular == 1 ? true : false;

      final difference = daysBetween(DateTime.parse('${widget.menuData!.createdAt}'), DateTime.now());

      if (difference >= widget.data!.restaurantDetail!.newItemValidity.validate()) {
        isNew = false;
      } else {
        if (widget.menuData!.isNew == 0) {
          isNew = false;
        } else {
          isNew = true;
        }
      }

      if (widget.menuData!.ingredient != null) {
        ingredient.addAll(widget.menuData!.ingredient.validate().split(','));
      }

      setState(() {});
    } else {
      ingredient = [];
      selectedCategory = widget.data!.category!.first;
      isVeg = widget.data!.restaurantDetail!.isVeg.validate() == 1 ? true : false;
    }
  }

  Future<void> saveData() async {
    appStore.setLoading(true);

    MultipartRequest multiPartRequest = await getMultiPartRequest(APIEndPoint.saveMenu);
    if (isUpdate) multiPartRequest.fields[CommonKeys.id] = widget.menuData!.id.toString().validate();
    multiPartRequest.fields[Menus.name] = nameCont.text;
    multiPartRequest.fields[Menus.categoryId] = selectedCategory!.id.toString().validate();
    multiPartRequest.fields[Menus.restaurantId] = widget.data!.restaurantDetail!.id.toString().validate();
    multiPartRequest.fields[Menus.price] = priceCont.text;
    multiPartRequest.fields[Menus.description] = descCont.text;

    String ingredientTemp = '';

    if (ingredient.isNotEmpty) {
      ingredient.forEach((element) {
        if (ingredientTemp.isNotEmpty) {
          ingredientTemp = '$ingredientTemp,${element.validate()}';
        } else {
          ingredientTemp = element.validate();
        }
      });
    }

    multiPartRequest.fields[Menus.ingredient] = ingredientTemp;
    multiPartRequest.fields[CommonKeys.status] = '1';
    multiPartRequest.fields[Menus.isJain] = isJain ? '1' : '0';
    multiPartRequest.fields[Menus.isVeg] = isVeg ? '1' : '0';
    multiPartRequest.fields[Menus.isNonVeg] = !isVeg ? '1' : '0';
    multiPartRequest.fields[Menus.isNew] = isNew ? '1' : '0';
    multiPartRequest.fields[Menus.isPopular] = isPopular ? '1' : '0';
    multiPartRequest.fields[Menus.isSpecial] = isSpecial ? '1' : '0';
    multiPartRequest.fields[Menus.isSpicy] = isSpicy ? '1' : '0';
    multiPartRequest.fields[Menus.isSweet] = isSweet ? '1' : '0';

    if (menuItemFiles.isNotEmpty) {
      await Future.forEach<File>(menuItemFiles, (element) async {
        log(Menus.menuImage + '_${menuItemFiles.indexOf(element)}');
        multiPartRequest.files.add(await MultipartFile.fromPath(Menus.menuImage + '_${menuItemFiles.indexOf(element)}', element.path));
      });
    }

    if (menuItemFiles.isNotEmpty) multiPartRequest.fields[CommonKeys.attachmentCount] = menuItemFiles.length.toString();

    multiPartRequest.headers.addAll(buildHeaderTokens());

    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        AddMenuItemResponse res = AddMenuItemResponse.fromJson(jsonDecode(data));

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
    Map request = {CommonKeys.id: widget.menuData!.id};
    deleteMenuItem(request: request).then((value) {
      toast(value['message']);
      appStore.setIsAll(true);
      finish(context, true);
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }

  Future<void> updateData() async {
    hideKeyboard(context);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      hideKeyboard(context);

      showConfirmDialogCustom(
        context,
        dialogType: isUpdate ? DialogType.UPDATE : DialogType.ADD,
        title: isUpdate ? '${language.lblDoYouWantToUpdate} ${widget.menuData!.name}?' : '${language.lblDoYouWantToAddThisMenuItem}?',
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

  Future<void> removeFiles({ImageModel? itemData, bool isFiles = false, File? fileData}) async {
    showConfirmDialogCustom(
      context,
      dialogType: DialogType.DELETE,
      title: language.lblAreYouSureWantToRemoveThisImage,
      onAccept: (context) async {
        hideKeyboard(context);
        if (!isFiles) {
          Map request = {
            Restaurants.type: Menus.menuImage,
            CommonKeys.id: itemData!.id.validate(),
          };

          appStore.setLoading(true);
          await deleteImage(request).then((value) {
            appStore.setLoading(false);
            itemImageFiles.remove(itemData);

            toast(language.lblDeleteSuccessfully);
          }).catchError((e) {
            appStore.setLoading(false);
            toast(e.toString());
          });
        } else {
          appStore.setLoading(true);
          await 1.milliseconds.delay;
          appStore.setLoading(false);

          toast(language.lblDeleteSuccessfully);
          menuItemFiles.remove(fileData!);
        }
        setState(() {});
      },
    );
  }

  bool isTapEnabledOnVeg() {
    if (widget.data!.restaurantDetail!.isVeg.validate() == 1 && widget.data!.restaurantDetail!.isNonVeg.validate() == 0) {
      return true;
    } else {
      if (widget.data!.restaurantDetail!.isVeg.validate() == 0 && widget.data!.restaurantDetail!.isNonVeg.validate() == 1) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  BoxDecoration commonDecoration() {
    return BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius), border: Border.all(width: 1, color: context.dividerColor));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBarWidget(
        isUpdate ? '${language.lblUpdate}' : '${language.lblAddMenuItem}',
        actions: [
          IconButton(
            onPressed: () {
              showConfirmDialogCustom(
                context,
                onAccept: (c) {

                  if (!getBoolAsync(SharePreferencesKey.IS_DEMO_ADMIN))
                    deleteData();
                  else
                    toast(language.lblDemoUserText);
                },
                dialogType: DialogType.DELETE,
                title: '${language.lblDoYouWantToDelete} ${widget.menuData!.name.validate()}?',
              );
            },
            icon: Icon(Icons.delete, color: context.iconColor),
          ).visible(isUpdate),
        ],
        color: context.scaffoldBackgroundColor,
        elevation: 0,
        backWidget: IconButton(
            onPressed: () {
              finish(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: context.iconColor)),
      ),
      body: Observer(
        builder: (_) => Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 500),
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(thickness: 1, color: context.dividerColor),
                      16.height,
                      Container(
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.center,
                        decoration: boxDecorationWithShadow(blurRadius: 0, borderRadius: radius(8), backgroundColor: context.cardColor),
                        child: Column(
                          children: [
                            Icon(Icons.add, size: 28, color: context.iconColor),
                            Text(language.lblChooseMenuItemImages, style: secondaryTextStyle()),
                          ],
                        ),
                      ).onTap(() async {
                        menuItemFiles.addAll(await getMultipleFile());
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
                            if (menuItemFiles.isNotEmpty)
                              HorizontalList(
                                  itemCount: menuItemFiles.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    return Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Image.file(menuItemFiles[i], width: 100, height: 100, fit: BoxFit.cover).cornerRadiusWithClipRRect(6),
                                        Icon(Icons.delete, color: white).onTap(() {
                                          removeFiles(fileData: menuItemFiles[i], isFiles: true);
                                        }),
                                      ],
                                    );
                                  }).paddingBottom(16),
                            if (itemImageFiles.isNotEmpty)
                              HorizontalList(
                                  itemCount: itemImageFiles.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    return Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        cachedImage(itemImageFiles[i].url.validate(), width: 100, height: 100, fit: BoxFit.cover).cornerRadiusWithClipRRect(6),
                                        Icon(Icons.delete, color: white).onTap(() async {
                                          removeFiles(itemData: itemImageFiles[i]);
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
                            Text('${language.lblEnterFoodItemDetails}', style: boldTextStyle()),
                            16.height,
                            AppTextField(
                              textStyle: primaryTextStyle(),
                              focus: nameFocus,
                              nextFocus: categoryFocus,
                              textInputAction: TextInputAction.next,
                              decoration: inputDecoration(
                                context,
                                label: "${language.lblName}",
                                textStyle: secondaryTextStyle(color: bodyColor),
                              ).copyWith(
                                prefixIcon: Image.asset('images/icons/ic_Draft.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                              ),
                              controller: nameCont,
                              textFieldType: TextFieldType.NAME,
                            ),
                            16.height,
                            CategoryDropdownComponent(
                              isValidate: true,
                              categoryData: categoryList,
                              defaultValue: selectedCategory,
                              onValueChanged: (value) async {
                                selectedCategory = value;
                                await 1.seconds.delay;
                              },
                            ),
                            16.height,
                            AppTextField(
                              textStyle: primaryTextStyle(),
                              focus: priceFocus,
                              nextFocus: descFocus,
                              textInputAction: TextInputAction.next,
                              decoration: inputDecoration(
                                context,
                                label: "${language.lblPrice}",
                                textStyle: secondaryTextStyle(color: bodyColor),
                              ).copyWith(
                                prefixIcon: IconButton(
                                  icon: Text(currencySymbol.validate(), style: secondaryTextStyle(size: 24, color: bodyColor)),
                                  onPressed: () {},
                                ),
                              ),
                              controller: priceCont,
                              textFieldType: TextFieldType.PHONE,
                            ),
                            16.height,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              width: context.width(),
                              decoration: commonDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'images/icons/ic_Notebook.png',
                                            height: 20,
                                            width: 20,
                                            fit: BoxFit.cover,
                                            color: bodyColor,
                                          ).paddingAll(8),
                                          8.width,
                                          Text(language.lblIngredients, style: secondaryTextStyle(color: bodyColor)),
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add, color: bodyColor),
                                        onPressed: () {
                                          showInDialog(
                                            context,
                                            contentPadding: EdgeInsets.all(0),
                                            builder: (c) {
                                              return AddIngredientDialogComponent();
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    spacing: 16,
                                    runSpacing: 16,
                                    runAlignment: WrapAlignment.start,
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    children: List.generate(
                                      ingredient.length,
                                      (index) => Chip(
                                        labelStyle: primaryTextStyle(size: 16),
                                        label: Text(ingredient[index].capitalizeFirstLetter()),
                                        deleteIcon: Icon(Icons.clear, color: Colors.red, size: 20),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        backgroundColor: context.cardColor,
                                        onDeleted: () {
                                          ingredient.removeAt(index);
                                          setState(() {});
                                        },
                                      ).onTap(() {
                                        showInDialog(
                                          context,
                                          contentPadding: EdgeInsets.all(0),
                                          builder: (c) {
                                            return AddIngredientDialogComponent(value: ingredient[index]);
                                          },
                                        );
                                        hideKeyboard(context);
                                      }, borderRadius: radius(80)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            16.height,
                            AppTextField(
                              textStyle: primaryTextStyle(),
                              focus: descFocus,
                              textInputAction: TextInputAction.done,
                              decoration: inputDecoration(
                                context,
                                label: language.lblDescription,
                                textStyle: secondaryTextStyle(color: bodyColor),
                              ).copyWith(
                                prefixIcon: Image.asset('images/icons/ic_Draft.png', height: 16, width: 16, fit: BoxFit.cover, color: bodyColor).paddingAll(12),
                              ),
                              controller: descCont,
                              minLines: 3,
                              maxLines: 3,
                              textFieldType: TextFieldType.MULTILINE,
                            ),
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
                            Text('${language.lblOtherDetailsToAdd}', style: boldTextStyle()),
                            8.height,
                            MenuItemDetailComponent(
                              title: language.lblNew,
                              subtitle: language.lblNewDescription,
                              isSelected: isNew,
                              onChanged: (val) {
                                isNew = val;
                                setState(() {});
                              },
                            ),
                            MenuItemDetailComponent(
                              title: language.lblVeg,
                              subtitle: language.lblVegDescription,
                              isTappedEnabled: isTapEnabledOnVeg(),
                              isSelected: isVeg,
                              onChanged: (bool val) {
                                if (widget.data!.restaurantDetail!.isVeg.validate() == 1 && widget.data!.restaurantDetail!.isNonVeg.validate() == 1) {
                                  isVeg = val;
                                } else if (widget.data!.restaurantDetail!.isVeg.validate() == 1 && widget.data!.restaurantDetail!.isNonVeg.validate() == 0) {
                                  isVeg = true;
                                  toast(language.lblYouCantThisIsVegRestaurant);
                                } else if (widget.data!.restaurantDetail!.isVeg.validate() == 0 && widget.data!.restaurantDetail!.isNonVeg.validate() == 1) {
                                  isVeg = false;
                                  toast(language.lblYouCantThisIsNonVegRestaurant);
                                } else {
                                  isVeg = false;
                                }
                                setState(() {});
                              },
                            ),
                            MenuItemDetailComponent(
                              title: language.lblSpicy,
                              subtitle: language.lblSpicyDescription,
                              isSelected: isSpicy,
                              onChanged: (val) {
                                isSpicy = val;
                                setState(() {});
                              },
                            ),
                            MenuItemDetailComponent(
                              title: language.lblJain,
                              subtitle: language.lblJainDescription,
                              isSelected: isJain,
                              onChanged: (val) {
                                isJain = val;
                                setState(() {});
                              },
                            ),
                            MenuItemDetailComponent(
                              title: language.lblSpecial,
                              subtitle: language.lblSpecialDescription,
                              isSelected: isSpecial,
                              onChanged: (val) {
                                isSpecial = val;
                                setState(() {});
                              },
                            ),
                            MenuItemDetailComponent(
                              title: language.lblSweet,
                              subtitle: language.lblSweetDescription,
                              isSelected: isSweet,
                              onChanged: (val) {
                                isSweet = val;
                                setState(() {});
                              },
                            ),
                            MenuItemDetailComponent(
                              title: language.lblPopular,
                              subtitle: language.lblPopularDescription,
                              isSelected: isPopular,
                              onChanged: (val) {
                                isPopular = val;
                                setState(() {});
                              },
                            ),
                          ],
                        ).center(),
                      ),
                    ],
                  ),
                ),
              ).center(),
            ).visible(!appStore.isLoading, defaultWidget: Loader()),
          ],
        ),
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
