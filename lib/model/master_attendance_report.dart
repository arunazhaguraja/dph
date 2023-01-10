class MasterAttendanceReportModel {
  bool? success;
  String? message;
  int? statusCode;
  List<String>? errors;
  List<Data>? data;

  MasterAttendanceReportModel(
      {this.success, this.message, this.statusCode, this.errors, this.data});

  MasterAttendanceReportModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    statusCode = json['StatusCode'];
    errors = json['Errors'].cast<String>();
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = this.success;
    data['Message'] = this.message;
    data['StatusCode'] = this.statusCode;
    data['Errors'] = this.errors;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? rowNum;
  var date;
  int? empId;
  var empName;
  var empMobileNo;
  String? attendanceDate;
  String? attendanceInTime;
  String? attendanceOutTime;
  String? attenanceStatus;
  bool? isWorking;
  String? holidayFlag;
  var districtName;
  var hUDName;
  var blockName;
  var pHCName;
  var hSCName;
  var roleName;
  int? fullCount;
  int? presentCount;
  int? absentCount;
  int? leaveRequestId;

  Data(
      {this.rowNum,
      this.date,
      this.empId,
      this.empName,
      this.empMobileNo,
      this.attendanceDate,
      this.attendanceInTime,
      this.attendanceOutTime,
      this.attenanceStatus,
      this.isWorking,
      this.holidayFlag,
      this.districtName,
      this.hUDName,
      this.blockName,
      this.pHCName,
      this.hSCName,
      this.roleName,
      this.fullCount,
      this.presentCount,
      this.absentCount,
      this.leaveRequestId});

  Data.fromJson(Map<String, dynamic> json) {
    rowNum = json['row_num'];
    date = json['Date'];
    empId = json['EmpId'];
    empName = json['EmpName'];
    empMobileNo = json['EmpMobileNo'];
    attendanceDate = json['AttendanceDate'];
    attendanceInTime = json['Attendance_In_Time'];
    attendanceOutTime = json['Attendance_Out_Time'];
    attenanceStatus = json['Attenance_Status'];
    isWorking = json['IsWorking'];
    holidayFlag = json['Holiday_Flag'];
    districtName = json['District_Name'];
    hUDName = json['HUD_Name'];
    blockName = json['Block_Name'];
    pHCName = json['PHC_Name'];
    hSCName = json['HSC_Name'];
    roleName = json['RoleName'];
    fullCount = json['Full_Count'];
    presentCount = json['Present_Count'];
    absentCount = json['Absent_Count'];
    leaveRequestId = json['LeaveRequest_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_num'] = this.rowNum;
    data['Date'] = this.date;
    data['EmpId'] = this.empId;
    data['EmpName'] = this.empName;
    data['EmpMobileNo'] = this.empMobileNo;
    data['AttendanceDate'] = this.attendanceDate;
    data['Attendance_In_Time'] = this.attendanceInTime;
    data['Attendance_Out_Time'] = this.attendanceOutTime;
    data['Attenance_Status'] = this.attenanceStatus;
    data['IsWorking'] = this.isWorking;
    data['Holiday_Flag'] = this.holidayFlag;
    data['District_Name'] = this.districtName;
    data['HUD_Name'] = this.hUDName;
    data['Block_Name'] = this.blockName;
    data['PHC_Name'] = this.pHCName;
    data['HSC_Name'] = this.hSCName;
    data['RoleName'] = this.roleName;
    data['Full_Count'] = this.fullCount;
    data['Present_Count'] = this.presentCount;
    data['Absent_Count'] = this.absentCount;
    data['LeaveRequest_id'] = this.leaveRequestId;
    return data;
  }
}
