import 'package:qr_menu_laravel_flutter/models/GetCategoryListResponse.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';

class MenuCategoryModel {
  int? categoryId;
  Category? category;
  List<QuantityMenuModel>? menu;

  MenuCategoryModel({this.categoryId, this.menu,this.category});
}

class QuantityMenuModel {
  Menu? menu;
  int? quantity;

  QuantityMenuModel({this.quantity,this.menu});
}
