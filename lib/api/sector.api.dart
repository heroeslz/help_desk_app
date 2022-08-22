import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:help_desck_app/globalVariable.dart';
import 'package:help_desck_app/models/sector.model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class SectorApi {
  static Future<Response> getSectors() async {
    var url = Uri.parse('${GlobalApi.url}/sector');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    return response;
  }
}