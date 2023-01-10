import 'package:dph_tn/model/general_student_report_model.dart';

abstract class StudentPresentAbsentRepository {
  Future<GeneralStudentReportModel> fetchStudentPresentAbsent(String postJson);
}