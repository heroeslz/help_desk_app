import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:help_desck_app/globalVariable.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/solicitation.model.dart';

class SectorApi {
  static Future<Response> getSectors() async {
    var client = http.Client();
    if (kDebugMode) print('aqui');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    try{
      Response response = await http.get(Uri.parse('https://help-ceuma.herokuapp.com/sector'), headers: headers);
      if (kDebugMode) { print(response); }
      if (kDebugMode)print('response $response');
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

  static Future<Response> createSector(SectorCreateModel sector) async {
    var url = Uri.parse('${GlobalApi.url}/sector');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    var body = jsonEncode(sector);

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response =  await http.post(url, headers: headers, body: body);
    return response;
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}