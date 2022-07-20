class UserListModel {
  Pagination? pagination;
  List<UserData>? data;

  UserListModel({this.pagination, this.data});

  UserListModel.fromJson(dynamic json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(UserData.fromJson(v));
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

class UserData {
  int? id;
  String? name;
  String? email;
  String? username;
  String? userType;
  String? gender;
  int? status;
  String? profileImage;

  UserData({this.id, this.name, this.email, this.username, this.userType, this.gender, this.status, this.profileImage});

  UserData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    userType = json['user_type'];
    gender = json['gender'];
    status = json['status'];
    profileImage = json['profile_image'];
  }

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

class Pagination {
  int? totalItems;
  int? perPage;
  int? currentPage;
  int? totalPages;
  int? from;
  int? to;
  String? nextPage;
  String? previousPage;

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
