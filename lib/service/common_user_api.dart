import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/common_user_model.dart';
import 'package:dph_tn/repository/common_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;

class CommonUserApi implements CommonRepository {
  @override
  Future<CommonUserModel> fetchCommonUserResponse(String postJson,String type) async {
    try {
      http.Response response = await http.post(
          Uri.parse(Consts.BASE_URL + type),
          body: postJson,
          headers: {
            'Content-type': 'application/json',
            "Accept": "application/json",
          });

      if (response.statusCode == 200) {
        print("CommonUser Response: " + response.body.toString());
        return CommonUserModel.fromJson(json.decode(response.body));
      } else {
        print("CommonUser Error: " + response.statusCode.toString());
        print('CommonUser Error');
        throw 'CommonUser Error';
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
