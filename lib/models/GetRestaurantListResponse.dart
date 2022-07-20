import 'package:qr_menu_laravel_flutter/models/ImageModel.dart';

class GetRestaurantListResponse {
  Pagination? pagination;
  List<Restaurant>? data;

  GetRestaurantListResponse({this.pagination, this.data});

  GetRestaurantListResponse.fromJson(dynamic json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Restaurant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Restaurant {
  int? id;
  String? name;
  String? email;
  String? contactNumber;
  int? managerId;
  String? managerName;
  String? managerImage;
  String? address;
  int? isVeg;
  int? isNonVeg;
  String? description;
  int? status;
  String? currency;
  int? newItemValidity;
  String? restaurantLogo;
  int? categoryCount;
  int? menuCount;
  List<ImageModel>? restaurantImage;
  int? discount;

  Restaurant({
    this.id,
    this.name,
    this.email,
    this.contactNumber,
    this.managerId,
    this.managerName,
    this.managerImage,
    this.address,
    this.isVeg,
    this.isNonVeg,
    this.description,
    this.status,
    this.currency,
    this.newItemValidity,
    this.restaurantLogo,
    this.restaurantImage,
    this.categoryCount,
    this.menuCount,
    this.discount,
  });

  Restaurant.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contactNumber = json['contact_number'];
    managerId = json['manager_id'];
    managerName = json['manager_name'];
    managerImage = json['manager_image'];
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
    categoryCount = json['category_count'];
    menuCount = json['menu_count'];
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
    map['category_count'] = categoryCount;
    map['menu_count'] = menuCount;
    map['discount']  = discount;
    return map;
  }
}

class Pagination {
  int? totalItems;
  var perPage;
  int? currentPage;
  int? totalPages;
  int? to;
  int? from;
  var nextPage;
  int? previousPage;

  Pagination({this.totalItems, this.perPage, this.currentPage, this.totalPages, this.to, this.from, this.nextPage, this.previousPage});

  Pagination.fromJson(dynamic json) {
    totalItems = json['total_items'];
    perPage = json['per_page'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    to = json['to'];
    from = json['from'];
    nextPage = json['next_page'];
    previousPage = json['previous_page'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_items'] = totalItems;
    map['per_page'] = perPage;
    map['currentPage'] = currentPage;
    map['totalPages'] = totalPages;
    map['to'] = to;
    map['from'] = from;
    map['next_page'] = nextPage;
    map['previous_page'] = previousPage;
    return map;
  }
}
