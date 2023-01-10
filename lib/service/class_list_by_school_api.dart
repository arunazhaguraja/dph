import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/class_list_by_school_model.dart';
import 'package:dph_tn/repository/class_list_by_school_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;

class ClassListBySchoolApi implements ClassListBySchoolRepository {
  @override
  Future<ClassListBySchoolModel> fetchClassListBySchool(String postJson) async {
    try {
      http.Response response =
          await http.get(Uri.parse(Consts.BASE_URL + postJson), headers: {
        'Content-type': 'application/json',
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        print("ClassListBySchoolApi Response: " + response.body.toString());
        return ClassListBySchoolModel.fromJson(json.decode(response.body));
      } else {
        print("ClassListBySchoolApi Error: " + response.statusCode.toString());
        throw 'ClassListBySchoolApi Error';
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
