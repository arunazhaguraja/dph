import 'package:dph_tn/model/general_leave_model.dart';
import 'package:dph_tn/model/leave_common_model.dart';

abstract class LoopLeaveRepository {
  Future<GeneralLeaveModel> fetchLoopLeaveResponse(String type);
}