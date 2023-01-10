
import 'package:dph_tn/model/school_emp_model.dart';

abstract class SchoolListEMPRepository {
  Future<SchoolEmpModel> fetchSchoolListEmp(String postJson);
}
