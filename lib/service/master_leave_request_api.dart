import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/leave_common_model.dart';
import 'package:dph_tn/repository/master_leave_request_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;

class MasterLeaveRequestApi implements MasterLeaveRequestRepository {
  @override
  Future<LeaveCommonModel> fetchMasterLeaveRequestResponse(
      String postJson) async {
    try {
      http.Response response =
          await http.get(Uri.parse(postJson), headers: {
        'Content-type': 'application/json',
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        print("MasterLeaveRequestApi Response: " + response.body.toString());
        return LeaveCommonModel.fromJson(json.decode(response.body));
      } else {
        print("MasterLeaveRequestApi Error: " + response.statusCode.toString());

        throw 'MasterLeaveRequestApi Error';
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
