class ClassListBySchoolModel {
  bool? success;
  String? message;
  int? statusCode;
  List<String>? errors;
  List<Data>? data;

  ClassListBySchoolModel(
      {this.success, this.message, this.statusCode, this.errors, this.data});

  ClassListBySchoolModel.fromJson(Map<String, dynamic> json) {
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
  int? schoolId;
  String? uDISECode;
  int? classId;
  String? classNm;
  String? section;
  String? lastScreenedDate;
  String? attendanceStatus;
  int? studentCount;

  Data(
      {this.schoolId,
      this.uDISECode,
      this.classId,
      this.classNm,
      this.section,
      this.lastScreenedDate,
      this.attendanceStatus,
      this.studentCount});

  Data.fromJson(Map<String, dynamic> json) {
    schoolId = json['SchoolId'];
    uDISECode = json['UDISECode'];
    classId = json['ClassId'];
    classNm = json['ClassNm'];
    section = json['Section'];
    lastScreenedDate = json['Last_Screened_Date'];
    attendanceStatus = json['Attendance_Status'];
    studentCount = json['Student_Count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SchoolId'] = this.schoolId;
    data['UDISECode'] = this.uDISECode;
    data['ClassId'] = this.classId;
    data['ClassNm'] = this.classNm;
    data['Section'] = this.section;
    data['Last_Screened_Date'] = this.lastScreenedDate;
    data['Attendance_Status'] = this.attendanceStatus;
    data['Student_Count'] = this.studentCount;
    return data;
  }
}
