import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/components/FilePickerDialogComponent.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/network/RestApis.dart';
import 'package:qr_menu_laravel_flutter/utils/CachedNetworkImage.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:qr_menu_laravel_flutter/utils/common.dart';
import 'package:qr_menu_laravel_flutter/utils/constants.dart';
import 'package:qr_menu_laravel_flutter/utils/modelKeys.dart';

// ignore: must_be_immutable
class ImageOptionComponent extends StatefulWidget {
  bool isRes;
  String? defaultImage;
  final String? name;
  final Function(File? image) onImageSelected;
  double? width;
  int? id;

  ImageOptionComponent({this.defaultImage, required this.onImageSelected, this.name, this.width, this.id,required this.isRes});

  @override
  _ImageOptionComponentState createState() => _ImageOptionComponentState();
}

class _ImageOptionComponentState extends State<ImageOptionComponent> {
  File? image;
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();

  }

  init() async {
    isUpdate = !widget.defaultImage.isEmptyOrNull;
  }

  Widget getImagePlatform({double? height, double? width}) {
    if (!isUpdate) {
      if (image != null) {
        if (isWeb) {
          return Image.network(
            image!.path.validate(),
            alignment: Alignment.center,
            fit: BoxFit.cover,
            height: height,
            width: width,
          ).cornerRadiusWithClipRRect(defaultRadius);
        } else {
          return Image.file(
            File(image!.path.validate()),
            alignment: Alignment.center,
            fit: BoxFit.cover,
            height: height,
            width: width,
          ).cornerRadiusWithClipRRect(defaultRadius);
        }
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/icons/image.png', height: 30, width: 30, fit: BoxFit.cover),
            8.height,
            Text('${language.lblChooseImage}', style: boldTextStyle()),
          ],
        );
      }
    } else {
      if (image != null) {
        return Image.file(
          File(image!.path.validate()),
          alignment: Alignment.center,
          fit: BoxFit.cover,
          height: height,
          width: width,
        ).cornerRadiusWithClipRRect(defaultRadius);
      } else {
        return cachedImage(widget.defaultImage, fit: BoxFit.cover, height: height, width: width).cornerRadiusWithClipRRect(defaultRadius);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DottedBorderWidget(
          padding: EdgeInsets.all(1),
          radius: defaultRadius,
          color: primaryColor,
          dotsWidth: 10,
          strokeWidth: 1.5,
          child: GestureDetector(
            onTap: () async {
              FileTypes file = await showInDialog(
                context,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
                title: Text(language.lblChooseAnAction, style: boldTextStyle()),
                builder: (p0) {
                  return FilePickerDialog(isSelected: (isUpdate || image != null));
                },
              );
              if (file == FileTypes.CANCEL) {

                image = null;
                widget.defaultImage = null;
                isUpdate = false;

                if(widget.isRes){
                  Map request = {
                    Restaurants.type: Restaurants.restaurantLogo,
                    CommonKeys.id: widget.id.validate(),
                  };

                  await deleteImage(request).then((value) {
                    image = null;
                    widget.defaultImage = null;
                    isUpdate = false;
                    setState(() {});
                  }).catchError((e) {
                  });

                }else{
                  Map request = {
                    Restaurants.type: Categories.categoryImage,
                    CommonKeys.id: widget.id.validate(),
                  };
                  await deleteImage(request).then((value) {
                    image = null;
                    widget.defaultImage = null;
                    isUpdate = false;
                    setState(() {});
                  }).catchError((e) {
                  });

                }

              }else{
                image = await getImageSource(isCamera: file == FileTypes.CAMERA ? true : false);
                widget.onImageSelected.call(image!);
                setState(() {});
              }

            },
            child: Container(
              height: 200,
              width: widget.width != null ? widget.width : context.width(),
              decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultRadius)),
              child: getImagePlatform(height: 180, width: context.width()),
            ),
          ),
        ),
        8.height,
        Text(language.lblImageSupport, style: primaryTextStyle(color: bodyColor, size: 12)),
      ],
    );
  }
}
