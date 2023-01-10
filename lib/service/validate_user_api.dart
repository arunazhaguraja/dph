import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/validate_user_model.dart';
import 'package:dph_tn/repository/ValidateUserRepository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;

class ValidateUserApi implements ValidateUserRepository {
  @override
  Future<ValidateUserModel> fetchValidateUserResponse(
      String postJson, String type) async {
    try {
      http.Response response = await http.post(
          Uri.parse(Consts.BASE_URL + type),
          body: postJson,
          headers: {
            'Content-type': 'application/json',
            "Accept": "application/json",
          });

      if (response.statusCode == 200) {
        print("ValidateUser Response: " + response.body.toString());
        return ValidateUserModel.fromJson(json.decode(response.body));
      } else {
        print("ValidateUser Error: " + response.statusCode.toString());
        print('ValidateUser Error');
        throw 'ValidateUser Error';
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
