class AddMenuItemResponse {
  String? message;
  int? categoryId;

  AddMenuItemResponse({this.message, this.categoryId});

  AddMenuItemResponse.fromJson(dynamic json) {
    message = json['message'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['category_id'] = categoryId;
    return map;
  }
}
