import 'dart:convert';
import 'dart:io';

import 'package:dph_tn/model/general_student_report_model.dart';
import 'package:dph_tn/repository/student_present_absent_repository.dart';
import 'package:http/http.dart' as http;

class StudentPresentAbsentApi implements StudentPresentAbsentRepository {
  @override
  Future<GeneralStudentReportModel> fetchStudentPresentAbsent(
      String postJson) async {
    try {
      http.Response response = await http.post(
          Uri.parse(
              "https://attendance.timesmed.in/School/Add_School_Screening"),
          body: postJson,
          headers: {
            'Content-type': 'application/json',
            "Accept": "application/json",
          });

      if (response.statusCode == 200) {
        print("StudentPresentAbsentApi Response: " + response.body.toString());
        return GeneralStudentReportModel.fromJson(json.decode(response.body));
      } else {
        print(
            "StudentPresentAbsentApi Error: " + response.statusCode.toString());
        throw 'StudentPresentAbsentApi Error';
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
