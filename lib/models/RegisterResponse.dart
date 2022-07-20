class RegisterResponse {
  String? message;
  Data? data;

  RegisterResponse({this.message, this.data});

  RegisterResponse.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  String? name;
  String? username;
  String? email;
  String? userType;
  String? gender;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data({this.name, this.username, this.email, this.userType, this.gender, this.updatedAt, this.createdAt, this.id});

  Data.fromJson(dynamic json) {
    name = json['name'];
    username = json['username'];
    email = json['email'];
    userType = json['user_type'];
    gender = json['gender'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['username'] = username;
    map['email'] = email;
    map['user_type'] = userType;
    map['gender'] = gender;
    map['updated_at'] = updatedAt;
    map['created_at'] = createdAt;
    map['id'] = id;
    return map;
  }
}
