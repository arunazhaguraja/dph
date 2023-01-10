class AttendanceReportModel {
  String? success;
  String? message;
  String? statusCode;
  int? total;
  int? present;
  int? abssent;
  List<Data>? data;

  AttendanceReportModel(
      {this.success,
      this.message,
      this.statusCode,
      this.total,
      this.present,
      this.abssent,
      this.data});

  AttendanceReportModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    statusCode = json['StatusCode'];
    total = json['Total'];
    present = json['Present'];
    abssent = json['Abssent'];
    if (json['Data'] != null) {
      data = <Data>[];
      json['Data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = this.success;
    data['Message'] = this.message;
    data['StatusCode'] = this.statusCode;
    data['Total'] = this.total;
    data['Present'] = this.present;
    data['Abssent'] = this.abssent;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? date;
  String? empName;
  String? attendanceDate;
  String? attendanceInTime;
  String? attendanceOutTime;
  bool? isWorking;
  String? holidayFlag;
  String? attendanceStatus;

  Data(
      {this.date,
      this.empName,
      this.attendanceDate,
      this.attendanceInTime,
      this.attendanceOutTime,
      this.isWorking,
      this.holidayFlag,
      this.attendanceStatus});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    empName = json['EmpName'];
    attendanceDate = json['AttendanceDate'];
    if (json['Attendance_In_Time'] != null) {
      attendanceInTime = json['Attendance_In_Time'];
    }
    if (json['Attendance_Out_Time'] != null) {
      attendanceOutTime = json['Attendance_Out_Time'];
    }

    isWorking = json['IsWorking'];
    holidayFlag = json['Holiday_Flag'];
    attendanceStatus = json['Attenance_Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['EmpName'] = this.empName;
    data['AttendanceDate'] = this.attendanceDate;
    if (data['Attendance_In_Time'] != null) {
      data['Attendance_In_Time'] = this.attendanceInTime;
    }
    if (data['Attendance_Out_Time'] != null) {
      data['Attendance_Out_Time'] = this.attendanceOutTime;
    }
    // data['Attendance_In_Time'] = this.attendanceInTime;
    // data['Attendance_Out_Time'] = this.attendanceOutTime;
    data['IsWorking'] = this.isWorking;
    data['Holiday_Flag'] = this.holidayFlag;
    data['Attenance_Status'] = this.attendanceStatus;
    return data;
  }
}
