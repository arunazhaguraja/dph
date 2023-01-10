import 'package:dph_tn/model/attendance_status_model.dart';

abstract class AttendanceStatusRepository {
  Future<AttendanceStatusModel> fetchAttendanceStatusResponse(String postJson);
}
