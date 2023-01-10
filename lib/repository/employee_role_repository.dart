import 'package:dph_tn/model/employee_role_model.dart';

abstract class EmpRoleRepository {
  Future<EmployeeRoleModel> fetchEmpRoleResponse(String type);
}