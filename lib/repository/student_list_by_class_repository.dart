import 'package:dph_tn/model/student_list_by_class_model.dart';

abstract class StudentListByClassRepository {
  Future<StudentListByClassModel> fetchStudentListByClass(String postJson);
}