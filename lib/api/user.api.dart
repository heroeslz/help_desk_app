import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:help_desck_app/api/sector.api.dart';
import 'package:help_desck_app/globalVariable.dart';
import 'package:help_desck_app/models/user.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserApi {
  static Future<Response> login(UserRequest userRequest) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var url = Uri.parse('${GlobalApi.url}/auth');

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

    var url = Uri.parse('${GlobalApi.url}/user');

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

  static Future<Response> getUsers() async {
    var client = http.Client();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    
    try{
      Response response = await http.get(Uri.parse('https://help-ceuma.herokuapp.com/user'), headers: headers);
      return response;
    }
    on SocketException {
      if (kDebugMode) { print('SocketException'); }
      throw const SocketException('SocketException');
    }
    catch(e) {
      if (kDebugMode) { print(e); }
      throw AppException('Error');
    }
    finally {
      if (kDebugMode) {
        print('close');
      }
      client.close();
    }
  }

  static Future<Response> deleteUser(id) async {
    var client = http.Client();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    try{
      Response response = await http.delete(Uri.parse('https://help-ceuma.herokuapp.com/user/$id'), headers: headers);
      return response;
    }
    on SocketException {
      if (kDebugMode) { print('SocketException'); }
      throw const SocketException('SocketException');
    }
    catch(e) {
      if (kDebugMode) { print(e); }
      throw AppException('Error');
    }
    finally {
      if (kDebugMode) {
        print('close');
      }
      client.close();
    }
  }
}
