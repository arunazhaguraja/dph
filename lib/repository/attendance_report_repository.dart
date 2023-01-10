import 'package:dph_tn/model/attendance_report_model.dart';

abstract class AttendanceReportRepository {
  Future<AttendanceReportModel> fetchAttendanceReportResponse(String postJson);
}
