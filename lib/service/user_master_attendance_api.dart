import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/master_attendance_report.dart';
import 'package:dph_tn/repository/user_master_attendance_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;

class UserMasterAttendanceApi implements UserMasterAttendanceRepository {
  @override
  Future<MasterAttendanceReportModel> fetchUserMasterAttendanceResponse(
      String postJson) async {
    try {
      http.Response response = await http.get(
          Uri.parse(
              "https://attendance.timesmed.in/Web_API/Get_UserAttendance_List_API?Employee_Id=" +
                  postJson),
          headers: {
            'Content-type': 'application/json',
            "Accept": "application/json",
          });
      print("Response body ${response.body}");

      if (response.statusCode == 200) {
        print("UserMasterAttendanceApi Success Response: " +
            response.body.toString());
        return MasterAttendanceReportModel.fromJson(json.decode(response.body));
      } else {
        print(
            "UserMasterAttendanceApi Error: " + response.statusCode.toString());

        throw 'UserMasterAttendanceApi Error';
      }
    } on SocketException {
      throw 'No internet connection';
    } on HttpException {
      throw "Couldn't find the post";
    } on FormatException {
      throw "Bad response format";
    }
  }
}
