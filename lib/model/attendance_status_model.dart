class AttendanceStatusModel {
  bool? success;
  String? message;
  int? statusCode;
  List<String>? errors;
  List<Data>? data;

  AttendanceStatusModel(
      {this.success, this.message, this.statusCode, this.errors, this.data});

  AttendanceStatusModel.fromJson(Map<String, dynamic> json) {
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
  int? attendanceId;
  int? empId;
  String? image;
  String? lattitude;
  String? longtitude;
  String? altitude;
  String? internetStatus;
  String ?addressDate;
  String ?inTime;
  String ?outTime;
  String ?attendanceDateString;
  String ?attendanceTimeString;
  String ?attendanceOutDateString;
  String ?attendanceOutTimeString;

  Data(
      {this.attendanceId,
      this.empId,
      this.image,
      this.lattitude,
      this.longtitude,
      this.altitude,
      this.internetStatus,
      this.addressDate,
      this.inTime,
      this.outTime,
      this.attendanceDateString,
      this.attendanceTimeString,
      this.attendanceOutDateString,
      this.attendanceOutTimeString});

  Data.fromJson(Map<String, dynamic> json) {
    attendanceId = json['Attendance_Id'];
    empId = json['EmpId'];
    image = json['Image'];
    lattitude = json['Lattitude'];
    longtitude = json['Longtitude'];
    altitude = json['Altitude'];
    internetStatus = json['InternetStatus'];
    addressDate = json['AddressDate'];
    inTime = json['InTime'];
    outTime = json['OutTime'];
    attendanceDateString = json['Attendance_Date_String'];
    attendanceTimeString = json['Attendance_Time_String'];
    attendanceOutDateString = json['Attendance_Out_Date_String'];
    attendanceOutTimeString = json['Attendance_Out_Time_String'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Attendance_Id'] = this.attendanceId;
    data['EmpId'] = this.empId;
    data['Image'] = this.image;
    data['Lattitude'] = this.lattitude;
    data['Longtitude'] = this.longtitude;
    data['Altitude'] = this.altitude;
    data['InternetStatus'] = this.internetStatus;
    data['AddressDate'] = this.addressDate;
    data['InTime'] = this.inTime;
    data['OutTime'] = this.outTime;
    data['Attendance_Date_String'] = this.attendanceDateString;
    data['Attendance_Time_String'] = this.attendanceTimeString;
    data['Attendance_Out_Date_String'] = this.attendanceOutDateString;
    data['Attendance_Out_Time_String'] = this.attendanceOutTimeString;
    return data;
  }
}
