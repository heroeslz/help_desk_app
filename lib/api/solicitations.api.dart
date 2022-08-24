import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:help_desck_app/globalVariable.dart';
import 'package:help_desck_app/models/solicitation.model.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SolicitationApi {
  static Future<ResponseGetSolicitations> getSolicitationsOpen() async {
    var url = Uri.parse('${GlobalApi.url}/solicitation/open');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);


    print(response.body);

    if (response.statusCode == 200) {
      var client = ResponseGetSolicitations.fromJson(jsonDecode(response.body));
      return client;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  static Future<ResponseGetSolicitations> getSolicitationsClose() async {
    var url = Uri.parse('${GlobalApi.url}/solicitation/close');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    print(response.body);


    if (response.statusCode == 200) {
      var solicitation =
          ResponseGetSolicitations.fromJson(jsonDecode(response.body));
      return solicitation;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  static Future<SolicitationModel> getSolicitationById(int id) async {
    var url = Uri.parse('${GlobalApi.url}/solicitation/$id');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var solicitation = SolicitationModel.fromJson(jsonDecode(response.body));
      return solicitation;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  static Future<Response> resolveSolicitation(int id) async {
    var url =
        Uri.parse('${GlobalApi.url}/solicitation/resolve-solicitation/$id');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await http.put(url, headers: headers);
    return response;
  }

  static Future<Response> create(SolicitationCreateModel solicitation) async {
    var url = Uri.parse('${GlobalApi.url}/solicitation');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    var body = jsonEncode(solicitation);

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response =
        await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<Response> createSolution(SolutionCreateModel solution) async {
    var url = Uri.parse('${GlobalApi.url}/solution');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    var body = jsonEncode(solution);

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response =
    await http.post(url, headers: headers, body: body);
    return response;
  }
}
