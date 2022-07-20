class UpdateProfileResponse {
  Data? data;
  String? message;

  UpdateProfileResponse({this.data, this.message});

  UpdateProfileResponse.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['message'] = message;
    return map;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? username;
  String? emailVerifiedAt;
  String? userType;
  String? gender;
  String? playerId;
  String? uid;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? profileImage;
  String? contactNumber;

  Data({this.id, this.name, this.email, this.username, this.emailVerifiedAt, this.userType, this.gender, this.playerId, this.uid, this.status, this.createdAt, this.updatedAt, this.profileImage,this.contactNumber});

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    emailVerifiedAt = json['email_verified_at'];
    userType = json['user_type'];
    gender = json['gender'];
    playerId = json['player_id'];
    uid = json['uid'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileImage = json['profile_image'];
    contactNumber = json['contact_number'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['username'] = username;
    map['email_verified_at'] = emailVerifiedAt;
    map['user_type'] = userType;
    map['gender'] = gender;
    map['player_id'] = playerId;
    map['uid'] = uid;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['profile_image'] = profileImage;
    map['contact_number'] = contactNumber;
    return map;
  }
}
