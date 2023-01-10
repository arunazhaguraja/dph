import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/leave_type_model.dart';
import 'package:dph_tn/repository/leave_type_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;

class LeaveTypeApi implements LeaveTypeRepository {
  @override
  Future<LeaveTypeModel> fetchLeaveTypeResponse(String type) async {
    try {
      http.Response response = await http
          .get(Uri.parse(Consts.BASE_URL_TEMPLATE + type), headers: {
        'Content-type': 'application/json',
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        print("LeaveTypeApi Response: " + response.body.toString());
        return LeaveTypeModel.fromJson(json.decode(response.body));
      } else {
        print("LeaveTypeApi Error: " + response.statusCode.toString());

        throw 'LeaveTypeApi Error';
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
