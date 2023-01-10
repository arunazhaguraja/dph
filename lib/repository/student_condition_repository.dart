
import 'package:dph_tn/model/student_conditions_model.dart';

abstract class StudentConditionsRepository {
  Future<StudentConditionsModel> fetchStudentConditions(String postJson);
}