import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/attendance_report_model.dart';
import 'package:dph_tn/repository/attendance_report_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;

class AttendanceReportApi implements AttendanceReportRepository {
  @override
  Future<AttendanceReportModel> fetchAttendanceReportResponse(
      String postJson) async {
    try {
      http.Response response =
          await http.get(Uri.parse(Consts.BASE_URL_TEMPLATE + postJson), headers: {
        'Content-type': 'application/json',
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        print("AttendanceReport Success Response: " + response.body.toString());
        return AttendanceReportModel.fromJson(json.decode(response.body));
      } else {
        print("AttendanceReportApi Error: " + response.statusCode.toString());
        print('AttendanceReportApi Error');
        throw 'AttendanceReportApi Error';
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
