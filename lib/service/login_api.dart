import 'dart:convert';
import 'dart:io';

import 'package:dph_tn/model/login_response.dart';
import 'package:dph_tn/repository/login_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;

class LoginApi implements LoginRepository {
  @override
  Future<LoginResponse> fetchLoginResponse(
      String postJson, String from, String token, String id) async {
    try {
      http.Response response = await http.post(
          Uri.parse(Consts.BASE_URL + "api/user/update"),
          body: postJson,
          headers: {
            'Content-type': 'application/json',
            "Accept": "application/json",
            'Authorization': 'Bearer ' + token
          });

      if (response.statusCode == 200) {
        print("Register Response: " + response.body.toString());
        return LoginResponse.fromJson(json.decode(response.body));
      } else {
        print("Register Response Error: " + response.statusCode.toString());
        print('Failed to load post');
        throw 'Failed to load post';
      }
    } on SocketException {
      throw 'No Internet connection';
    } on HttpException {
      throw "Couldn't find the post";
    } on FormatException {
      throw "Bad response format";
    }
  }
}
