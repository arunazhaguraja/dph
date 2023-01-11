import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/school_emp_model.dart';
import 'package:dph_tn/model/school_list_emp_model.dart';
import 'package:dph_tn/repository/school_list_emp_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;

class SchoolListEmpApi implements SchoolListEMPRepository {
  @override
  Future<SchoolEmpModel> fetchSchoolListEmp(String postJson) async {
    print("SchoolList Api: " +
        "https://attendance.timesmed.in/School/Get_Date_Wise_Screened_Schools?" +
        postJson);
    try {
      http.Response response = await http.get(
          Uri.parse(
              "https://attendance.timesmed.in/School/Get_Date_Wise_Screened_Schools?" +
                  postJson),
          headers: {
            'Content-type': 'application/json',
            "Accept": "application/json",
          });

      if (response.statusCode == 200) {
        print("SchoolListEmpApi Response: " + response.body.toString());
        return SchoolEmpModel.fromJson(json.decode(response.body));
      } else {
        print("SchoolListEmpApi Error: " + response.statusCode.toString());
        throw 'SchoolListEmpApi Error';
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
