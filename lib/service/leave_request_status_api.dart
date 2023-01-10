import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/leave_request_status_model.dart';
import 'package:dph_tn/repository/leave_request_status_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;

class LeaveRequestStatusApi implements LeaveRequestStatusRepository {
  @override
  Future<LeaveRequestStatusModel> fetchLeaveRequestStatusResponse(
      String type) async {
    try {
      http.Response response = await http
          .get(Uri.parse(Consts.BASE_URL_TEMPLATE + type), headers: {
        'Content-type': 'application/json',
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        print("LeaveRequestStatusApi Response: " + response.body.toString());
        return LeaveRequestStatusModel.fromJson(json.decode(response.body));
      } else {
        print("LeaveRequestStatusApi Error: " + response.statusCode.toString());

        throw 'LeaveRequestStatusApi Error';
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
