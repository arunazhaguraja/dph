import 'package:dph_tn/model/master_attendance_report.dart';

abstract class UserMasterAttendanceRepository {
  Future<MasterAttendanceReportModel> fetchUserMasterAttendanceResponse(
      String postJson);
}
