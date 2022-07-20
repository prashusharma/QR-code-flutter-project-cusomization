class RestaurantResponse {
  String? message;
  int? restaurantId;

  RestaurantResponse({this.message, this.restaurantId});

  RestaurantResponse.fromJson(dynamic json) {
    message = json['message'];
    restaurantId = json['restaurant_id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['restaurant_id'] = restaurantId;
    return map;
  }
}
