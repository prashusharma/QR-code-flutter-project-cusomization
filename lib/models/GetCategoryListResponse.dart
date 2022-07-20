class GetCategoryListResponse {
  Pagination? pagination;
  List<Category>? data;

  GetCategoryListResponse({this.pagination, this.data});

  GetCategoryListResponse.fromJson(dynamic json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Category.fromJson(v));
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

class Category {
  int? id;
  String? name;
  int? status;
  String? categoryImage;
  String? description;
  int? restaurantId;

  Category({this.id, this.name, this.status, this.categoryImage, this.description,this.restaurantId});

  Category.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    categoryImage = json['category_image'];
    description = json['description'];
    restaurantId = json['restaurant_id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['status'] = status;
    map['description'] = description;
    map['restaurant_id'] = restaurantId;
    return map;
  }
}

class Pagination {
  int? totalItems;
  int? perPage;
  int? currentPage;
  int? totalPages;
  int? from;
  int? to;
  int? nextPage;
  int? previousPage;

  Pagination({this.totalItems, this.perPage, this.currentPage, this.totalPages, this.from, this.to, this.nextPage, this.previousPage});

  Pagination.fromJson(dynamic json) {
    totalItems = json['total_items'];
    perPage = json['per_page'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    from = json['from'];
    to = json['to'];
    nextPage = json['next_page'];
    previousPage = json['previous_page'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_items'] = totalItems;
    map['per_page'] = perPage;
    map['currentPage'] = currentPage;
    map['totalPages'] = totalPages;
    map['from'] = from;
    map['to'] = to;
    map['next_page'] = nextPage;
    map['previous_page'] = previousPage;
    return map;
  }
}
