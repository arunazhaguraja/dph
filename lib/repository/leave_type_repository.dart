import 'package:dph_tn/model/leave_type_model.dart';

abstract class LeaveTypeRepository {
  Future<LeaveTypeModel> fetchLeaveTypeResponse(String type);
}