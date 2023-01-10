import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/general_leave_model.dart';
import 'package:dph_tn/model/leave_common_model.dart';
import 'package:dph_tn/repository/loop_leave_repository.dart';
import 'package:http/http.dart' as http;

class LoopLeaveApi implements LoopLeaveRepository {
  @override
  Future<GeneralLeaveModel> fetchLoopLeaveResponse(String type) async {
    try {
      http.Response response = await http
          .get(Uri.parse(type), headers: {
        'Content-type': 'application/json',
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        print("LoopLeaveApi Response: " + response.body.toString());
        return GeneralLeaveModel.fromJson(json.decode(response.body));
      } else {
        print("LoopLeaveApi Error: " + response.statusCode.toString());

        throw 'LoopLeaveApi Error';
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
