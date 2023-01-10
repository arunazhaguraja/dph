import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/student_conditions_model.dart';
import 'package:dph_tn/repository/student_condition_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;


class StudentConditionsApi implements StudentConditionsRepository {

  @override
  Future<StudentConditionsModel> fetchStudentConditions(String postJson) async {
    try {
      http.Response response =
          await http.get(Uri.parse(Consts.BASE_URL + postJson), headers: {
        'Content-type': 'application/json',
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        print("StudentConditionsApi Response: " + response.body.toString());
        return StudentConditionsModel.fromJson(json.decode(response.body));
      } else {
        print("StudentConditionsApi Error: " + response.statusCode.toString());
        throw 'StudentConditionsApi Error';
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