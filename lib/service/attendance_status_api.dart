import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/attendance_status_model.dart';
import 'package:dph_tn/repository/attendance_status_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;

class AttendanceStatusApi implements AttendanceStatusRepository {
  @override
  Future<AttendanceStatusModel> fetchAttendanceStatusResponse(
      String postJson) async {
    try {
      http.Response response = await http.post(
          Uri.parse(Consts.BASE_URL + "api/attendance/checkemployeeattendance"),
          body: postJson,
          headers: {
            'Content-type': 'application/json',
            "Accept": "application/json",
          });

      if (response.statusCode == 200) {
        print("AttendanceStatusApi Success Response: " +
            response.body.toString());
        return AttendanceStatusModel.fromJson(json.decode(response.body));
      } else {
        print("AttendanceStatusApi Error: " + response.statusCode.toString());
        print('AttendanceStatusApi Error');
        throw 'AttendanceStatusApi Error';
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
