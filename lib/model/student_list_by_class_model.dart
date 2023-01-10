class StudentListByClassModel {
  bool? success;
  String? message;
  int? statusCode;
  List<String>? errors;
  List<Data>? data;

  StudentListByClassModel(
      {this.success, this.message, this.statusCode, this.errors, this.data});

  StudentListByClassModel.fromJson(Map<String, dynamic> json) {
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
  int? classId;
  String? uDISECode;
  int? studentId;
  String? studentUniqueId;
  String? firstName;
  String? dOB;
  String? mobileNo;
  String? bldGrp;
  int? screeningId;
  bool? attendance;

  Data(
      {this.schoolId,
      this.classId,
      this.uDISECode,
      this.studentId,
      this.studentUniqueId,
      this.firstName,
      this.dOB,
      this.mobileNo,
      this.bldGrp,
      this.screeningId,
      this.attendance});

  Data.fromJson(Map<String, dynamic> json) {
    schoolId = json['SchoolId'];
    classId = json['ClassId'];
    uDISECode = json['UDISECode'];
    studentId = json['StudentId'];
    studentUniqueId = json['StudentUniqueId'];
    firstName = json['FirstName'];
    dOB = json['DOB'];
    mobileNo = json['MobileNo'];
    bldGrp = json['BldGrp'];
    screeningId = json['Screening_Id'];
    attendance = json['Attendance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SchoolId'] = this.schoolId;
    data['ClassId'] = this.classId;
    data['UDISECode'] = this.uDISECode;
    data['StudentId'] = this.studentId;
    data['StudentUniqueId'] = this.studentUniqueId;
    data['FirstName'] = this.firstName;
    data['DOB'] = this.dOB;
    data['MobileNo'] = this.mobileNo;
    data['BldGrp'] = this.bldGrp;
    data['Screening_Id'] = this.screeningId;
    data['Attendance'] = this.attendance;
    return data;
  }
}
