class PasswordResponse {
  String? message;
  bool? status;

  PasswordResponse({this.message, this.status});

  PasswordResponse.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    return map;
  }
}
