import 'package:dph_tn/repository/ValidateUserRepository.dart';
import 'package:dph_tn/repository/attendance_report_repository.dart';
import 'package:dph_tn/repository/attendance_status_repository.dart';
import 'package:dph_tn/repository/class_list_by_school_repository.dart';
import 'package:dph_tn/repository/common_repository.dart';
import 'package:dph_tn/repository/district_repository.dart';
import 'package:dph_tn/repository/employee_role_repository.dart';
import 'package:dph_tn/repository/leave_request_detail_repository.dart';
import 'package:dph_tn/repository/leave_request_status_repository.dart';
import 'package:dph_tn/repository/leave_type_repository.dart';
import 'package:dph_tn/repository/login_repository.dart';
import 'package:dph_tn/repository/loop_leave_repository.dart';
import 'package:dph_tn/repository/master_leave_request_repository.dart';
import 'package:dph_tn/repository/school_list_emp_repository.dart';
import 'package:dph_tn/repository/student_condition_repository.dart';
import 'package:dph_tn/repository/student_list_by_class_repository.dart';
import 'package:dph_tn/repository/student_present_absent_repository.dart';
import 'package:dph_tn/repository/user_detail_repository.dart';
import 'package:dph_tn/repository/user_master_attendance_repository.dart';
import 'package:dph_tn/service/attendance_report_api.dart';
import 'package:dph_tn/service/attendance_status_api.dart';
import 'package:dph_tn/service/class_list_by_school_api.dart';
import 'package:dph_tn/service/common_user_api.dart';
import 'package:dph_tn/service/district_api.dart';
import 'package:dph_tn/service/employee_role_api.dart';
import 'package:dph_tn/service/leave_request_detail_api.dart';
import 'package:dph_tn/service/leave_request_status_api.dart';
import 'package:dph_tn/service/leave_type_api.dart';
import 'package:dph_tn/service/login_api.dart';
import 'package:dph_tn/service/loop_leave_request_api.dart';
import 'package:dph_tn/service/master_leave_request_api.dart';
import 'package:dph_tn/service/school_list_emp_api.dart';
import 'package:dph_tn/service/student_condition_api.dart';
import 'package:dph_tn/service/student_list_class_api.dart';
import 'package:dph_tn/service/student_present_absent_api.dart';
import 'package:dph_tn/service/user_details_api.dart';
import 'package:dph_tn/service/user_master_attendance_api.dart';
import 'package:dph_tn/service/validate_user_api.dart';

class Injector {
  static final Injector _instance = Injector.internal();

  factory Injector() => _instance;

  Injector.internal();

  LoginRepository get loginRep {
    return LoginApi();
  }

  ValidateUserRepository get validateRepo {
    return ValidateUserApi();
  }

  CommonRepository get commonRepo {
    return CommonUserApi();
  }

  SchoolListEMPRepository get schoolListEmpRepo {
    return SchoolListEmpApi();
  }

  UserDetailsRepository get userDetailsRepo {
    return UserDetailsApi();
  }

  AttendanceReportRepository get attendanceReportRepo {
    return AttendanceReportApi();
  }

  DistrictRepository get districtRepo {
    return DistrictApi();
  }

  AttendanceStatusRepository get attendanceStatusRepo {
    return AttendanceStatusApi();
  }

  LeaveTypeRepository get leaveTypeRepo {
    return LeaveTypeApi();
  }

  MasterLeaveRequestRepository get leaveRequestMaster {
    return MasterLeaveRequestApi();
  }

  EmpRoleRepository get empRoleRepo {
    return EmpRoleApi();
  }

  LoopLeaveRepository get loopLeaveRepo {
    return LoopLeaveApi();
  }

  LeaveRequestStatusRepository get leaveReqStatusRepo {
    return LeaveRequestStatusApi();
  }

  LeaveRequestDetailRepository get leaveReqDetailRepo {
    return LeaveRequestDetailApi();
  }

  UserMasterAttendanceRepository get userMasterAttendRepo {
    return UserMasterAttendanceApi();
  }

  ClassListBySchoolRepository get classListBySchoolRepo {
    return ClassListBySchoolApi();
  }

  StudentListByClassRepository get studentListClassRepo {
    return StudentListClassApi();
  }

  StudentConditionsRepository get studentConditionsRepo {
    return StudentConditionsApi();
  }

  StudentPresentAbsentRepository get studentPresentAbsentRepo {
    return StudentPresentAbsentApi();
  }
}
