import 'dart:convert';
import 'dart:io';

import 'package:dph_tn/model/employee_role_model.dart';
import 'package:dph_tn/repository/employee_role_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;

class EmpRoleApi implements EmpRoleRepository {
  @override
  Future<EmployeeRoleModel> fetchEmpRoleResponse(String type) async {
    try {
      http.Response response = await http
          .get(Uri.parse(Consts.BASE_URL + type), headers: {
        'Content-type': 'application/json',
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        print("EmpRoleApi Response: " + response.body.toString());
        return EmployeeRoleModel.fromJson(json.decode(response.body));
      } else {
        print("EmpRoleApi Error: " + response.statusCode.toString());

        throw 'EmpRoleApi Error';
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
