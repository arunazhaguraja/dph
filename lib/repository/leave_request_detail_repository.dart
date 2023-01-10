import 'package:dph_tn/model/leave_request_detail_model.dart';

abstract class LeaveRequestDetailRepository {
  Future<LeaveRequestDetailModel> fetchLeaveRequestDetailResponse(String type);
}
