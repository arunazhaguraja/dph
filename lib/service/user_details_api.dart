import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/userdetailsmodel.dart';
import 'package:dph_tn/repository/user_detail_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;

class UserDetailsApi implements UserDetailsRepository {
  @override
  Future<UserDetailsModel> fetchUserDetailsResponse(String postJson) async {
    try {
      http.Response response =
          await http.get(Uri.parse(Consts.BASE_URL + postJson), headers: {
        'Content-type': 'application/json',
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        print("UserDetails Response: " + response.body.toString());
        return UserDetailsModel.fromJson(json.decode(response.body));
      } else {
        print("UserDetails Response Error: " + response.statusCode.toString());

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
