import 'package:help_desck_app/models/sector.model.dart';

class UserModel {
    int? user_id;
   String? name;
   String? email;
   String? password;
   String? user_type;
   String? created_at;
   String? updated_at;

  UserModel({
     this.user_id,
     this.name,
     this.email,
     this.password,
     this.user_type,
     this.created_at,
     this.updated_at,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      user_id: json['user_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      user_type: json['user_type'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

    Map toJson() {
      Map<String, dynamic> service = {
        'name': name.toString(),
        'email':email,
        'password': password,
        'user_type': user_type,
      };
      return service;
    }
}

class UserRequest {
  String? email;
  String? password;

  UserRequest({this.password, this.email});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.toString(),
      'password': password.toString()
    };
    return map;
  }
}

class LoginResponse {
  String? access_token;

  LoginResponse({this.access_token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      access_token: json["access_token"],
    );
  }
}