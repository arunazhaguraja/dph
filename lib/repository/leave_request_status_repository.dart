import 'package:dph_tn/model/leave_request_status_model.dart';

abstract class LeaveRequestStatusRepository {
  Future<LeaveRequestStatusModel> fetchLeaveRequestStatusResponse(String type);
}