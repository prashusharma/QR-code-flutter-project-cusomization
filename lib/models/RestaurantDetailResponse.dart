import 'package:qr_menu_laravel_flutter/models/GetCategoryListResponse.dart';

import 'ImageModel.dart';

class RestaurantDetailResponse {
  RestaurantDetail? restaurantDetail;
  List<Category>? category;
  List<Menu>? menu;
  Manager? manager;

  RestaurantDetailResponse({this.restaurantDetail, this.category, this.menu, this.manager});

  RestaurantDetailResponse.fromJson(dynamic json) {
    restaurantDetail = json['restaurant_detail'] != null ? RestaurantDetail.fromJson(json['restaurant_detail']) : null;
    if (json['category'] != null) {
      category = [];
      json['category'].forEach((v) {
        category?.add(Category.fromJson(v));
      });
    }
    if (json['menu'] != null) {
      menu = [];
      json['menu'].forEach((v) {
        menu?.add(Menu.fromJson(v));
      });
    }
    manager = json['manager'] != null ? Manager.fromJson(json['manager']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (restaurantDetail != null) {
      map['restaurant_detail'] = restaurantDetail?.toJson();
    }
    if (category != null) {
      map['category'] = category?.map((v) => v.toJson()).toList();
    }
    if (menu != null) {
      map['menu'] = menu?.map((v) => v.toJson()).toList();
    }
    if (manager != null) {
      map['manager'] = manager?.toJson();
    }
    return map;
  }
}

class Manager {
  Manager({
    this.id,
    this.name,
    this.email,
    this.username,
    this.userType,
    this.gender,
    this.status,
    this.profileImage,
  });

  Manager.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    userType = json['user_type'];
    gender = json['gender'];
    status = json['status'];
    profileImage = json['profile_image'];
  }

  int? id;
  String? name;
  String? email;
  String? username;
  String? userType;
  String? gender;
  int? status;
  String? profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['username'] = username;
    map['user_type'] = userType;
    map['gender'] = gender;
    map['status'] = status;
    map['profile_image'] = profileImage;
    return map;
  }
}

class Menu {
  Menu({
    this.id,
    this.name,
    this.categoryId,
    this.restaurantId,
    this.price,
    this.description,
    this.ingredient,
    this.status,
    this.isJain,
    this.isNew,
    this.isPopular,
    this.isSpecial,
    this.isSpicy,
    this.isSweet,
    this.isVeg,
    this.isNonVeg,
    this.categoryName,
    this.category,
    this.menuImage,
    this.createdAt,
    this.updatedAt,
  });

  Menu.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    restaurantId = json['restaurant_id'];
    price = json['price'];
    description = json['description'];
    ingredient = json['ingredient'];
    status = json['status'];
    isJain = json['is_jain'];
    isNew = json['is_new'];
    isPopular = json['is_popular'];
    isSpecial = json['is_special'];
    isSpicy = json['is_spicy'];
    isSweet = json['is_sweet'];
    isVeg = json['is_veg'];
    isNonVeg = json['is_non_veg'];
    categoryName = json['category_name'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    if (json['menu_image'] != null) {
      menuImage = [];
      json['menu_image'].forEach((v) {
        menuImage?.add(ImageModel.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  int? id;
  String? name;
  int? categoryId;
  int? restaurantId;
  int? price;
  String? description;
  String? ingredient;
  int? status;
  int? isJain;
  int? isNew;
  int? isPopular;
  int? isSpecial;
  int? isSpicy;
  int? isSweet;
  int? isVeg;
  int? isNonVeg;
  String? categoryName;
  Category? category;
  List<ImageModel>? menuImage;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['category_id'] = categoryId;
    map['restaurant_id'] = restaurantId;
    map['price'] = price;
    map['description'] = description;
    map['ingredient'] = ingredient;
    map['status'] = status;
    map['is_jain'] = isJain;
    map['is_new'] = isNew;
    map['is_popular'] = isPopular;
    map['is_special'] = isSpecial;
    map['is_spicy'] = isSpicy;
    map['is_sweet'] = isSweet;
    map['is_veg'] = isVeg;
    map['is_non_veg'] = isNonVeg;
    map['category_name'] = categoryName;
    if (category != null) {
      map['category'] = category?.toJson();
    }
    if (menuImage != null) {
      map['menu_image'] = menuImage?.map((v) => v.toJson()).toList();
    }
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}

class RestaurantDetail {
  int? id;
  String? name;
  String? email;
  String? contactNumber;
  int? managerId;
  String? managerName;
  String? managerImage;
  int? categoryCount;
  int? menuCount;
  String? address;
  int? isVeg;
  int? isNonVeg;
  String? description;
  int? status;
  String? currency;
  int? newItemValidity;
  String? restaurantLogo;
  List<ImageModel>? restaurantImage;
  String? createdAt;
  String? updatedAt;
  int? discount;


  RestaurantDetail({
    this.id,
    this.name,
    this.email,
    this.contactNumber,
    this.managerId,
    this.managerName,
    this.managerImage,
    this.categoryCount,
    this.menuCount,
    this.address,
    this.isVeg,
    this.isNonVeg,
    this.description,
    this.status,
    this.currency,
    this.newItemValidity,
    this.restaurantLogo,
    this.restaurantImage,
    this.createdAt,
    this.updatedAt,
    this.discount,
  });

  RestaurantDetail.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contactNumber = json['contact_number'];
    managerId = json['manager_id'];
    managerName = json['manager_name'];
    managerImage = json['manager_image'];
    categoryCount = json['category_count'];
    menuCount = json['menu_count'];
    address = json['address'];
    isVeg = json['is_veg'];
    isNonVeg = json['is_non_veg'];
    description = json['description'];
    status = json['status'];
    currency = json['currency'];
    newItemValidity = json['new_item_validity'];
    restaurantLogo = json['restaurant_logo'];
    if (json['restaurant_image'] != null) {
      restaurantImage = [];
      json['restaurant_image'].forEach((v) {
        restaurantImage?.add(ImageModel.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['contact_number'] = contactNumber;
    map['manager_id'] = managerId;
    map['manager_name'] = managerName;
    map['manager_image'] = managerImage;
    map['category_count'] = categoryCount;
    map['menu_count'] = menuCount;
    map['address'] = address;
    map['is_veg'] = isVeg;
    map['is_non_veg'] = isNonVeg;
    map['description'] = description;
    map['status'] = status;
    map['currency'] = currency;
    map['new_item_validity'] = newItemValidity;
    map['restaurant_logo'] = restaurantLogo;
    if (restaurantImage != null) {
      map['restaurant_image'] = restaurantImage?.map((v) => v.toJson()).toList();
    }
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['discount'] = discount;
    return map;
  }
}

