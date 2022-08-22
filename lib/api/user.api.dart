import 'dart:io';

import 'package:help_desck_app/models/user.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserApi {
  static Future<Response> login(UserRequest userRequest) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var url = Uri.parse('http://192.168.15.8:3000/auth');

    final response = await http.post(
      url,
      body: userRequest.toJson(),
    );
    if (response.statusCode == 201) {
      var accessToken2 =
          LoginResponse.fromJson(json.decode(response.body)).access_token;
      await _prefs.setString('access_token', accessToken2!);
      return response;
    } else {
      return response;
    }
  }

  static Future<Response> createAccount(UserModel userRequest) async {
    var url = Uri.parse('http://192.168.15.8:3000/user');

    var body = jsonEncode(userRequest);

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    return response;
  }
}
