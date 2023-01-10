import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/leave_request_detail_model.dart';
import 'package:dph_tn/repository/leave_request_detail_repository.dart';
import 'package:http/http.dart' as http;

class LeaveRequestDetailApi implements LeaveRequestDetailRepository {
  @override
  Future<LeaveRequestDetailModel> fetchLeaveRequestDetailResponse(
      String type) async {
    try {
      http.Response response = await http.get(
          Uri.parse(
              "http://template.timesmed.in/Master/Load_RequestedLeave_Approval_Mobile?" +
                  type),
          headers: {
            'Content-type': 'application/json',
            "Accept": "application/json",
          });

      if (response.statusCode == 200) {
        print("LeaveRequestDetailApi Response: " + response.body.toString());
        return LeaveRequestDetailModel.fromJson(json.decode(response.body));
      } else {
        print("LeaveRequestDetailApi Error: " + response.statusCode.toString());

        throw 'LeaveRequestDetailApi Error';
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
