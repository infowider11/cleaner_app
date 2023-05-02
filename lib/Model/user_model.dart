import 'package:cleanerapp/constants/global_data.dart';

class user_model {
  User_data? data;
  String? message;
  int? status;

  user_model({this.data, this.message, this.status});

  user_model.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new User_data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class User_data {
  String? id;
  String? name;
  String? email;
  String? phone;
  UserType? userType;
  String? profileImage;
  String? status;

  User_data(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.userType,
        this.profileImage,
        this.status});

  User_data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    phone = json['phone'] ?? "";
    userType = json['type']=="1"? UserType.Secratary : json['type']=="2"? UserType.Supervisor :  json['type']=="3"? UserType.Logistics :
                 json['type']=="4"? UserType.Maintenance : UserType.Cleaners ;
    profileImage = json['profile_image'] ?? "";
    status = json['status'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['type'] = this.userType;
    data['profile_image'] = this.profileImage;
    data['status'] = this.status;
    return data;
  }
}
