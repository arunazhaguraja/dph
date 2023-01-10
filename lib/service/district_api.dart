import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/district_model.dart';

import 'package:dph_tn/repository/district_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;

class DistrictApi implements DistrictRepository {
  @override
  Future<DistricModel> fetchDistrictResponse(String type) async {
    try {
      http.Response response = await http.get(
          Uri.parse(Consts.BASE_URL_TEMPLATE + type),
         
          headers: {
            'Content-type': 'application/json',
            "Accept": "application/json",
          });

      if (response.statusCode == 200) {
        print("DistrictApi Response: " + response.body.toString());
        return DistricModel.fromJson(json.decode(response.body));
      } else {
        print("DistrictApi Error: " + response.statusCode.toString());
        print('DistrictApi Error');
        throw 'DistrictApi Error';
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
