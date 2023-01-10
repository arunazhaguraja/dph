import 'package:dph_tn/model/leave_common_model.dart';

abstract class MasterLeaveRequestRepository{
Future<LeaveCommonModel> fetchMasterLeaveRequestResponse(String postJson);
}