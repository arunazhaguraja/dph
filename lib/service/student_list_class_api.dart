import 'dart:convert';
import 'dart:io';
import 'package:dph_tn/model/student_list_by_class_model.dart';
import 'package:dph_tn/repository/student_list_by_class_repository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:http/http.dart' as http;


class StudentListClassApi implements StudentListByClassRepository {

  @override
  Future<StudentListByClassModel> fetchStudentListByClass(String postJson) async {
     try {
      http.Response response =
          await http.get(Uri.parse(Consts.BASE_URL + postJson), headers: {
        'Content-type': 'application/json',
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        print("StudentListClassApi Response: " + response.body.toString());
        return StudentListByClassModel.fromJson(json.decode(response.body));
      } else {
        print("StudentListClassApi Error: " + response.statusCode.toString());
        throw 'StudentListClassApi Error';
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