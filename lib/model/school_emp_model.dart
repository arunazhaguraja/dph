class SchoolEmpModel {
  bool? success;
  String? message;
  int? statusCode;
  Data? data;

  SchoolEmpModel({this.success, this.message, this.statusCode, this.data});

  SchoolEmpModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    statusCode = json['StatusCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = this.success;
    data['Message'] = this.message;
    data['StatusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Report? report;
  List<SchoolList>? schoolList;

  Data({this.report, this.schoolList});

  Data.fromJson(Map<String, dynamic> json) {
    report =
        json['Report'] != null ? new Report.fromJson(json['Report']) : null;
    if (json['School_List'] != null) {
      schoolList = <SchoolList>[];
      json['School_List'].forEach((v) {
        schoolList!.add(new SchoolList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.report != null) {
      data['Report'] = this.report!.toJson();
    }
    if (this.schoolList != null) {
      data['School_List'] = this.schoolList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Report {
  String? totalSchool;
  String? totalStudent;
  String? totalCondition;
  int? districtCount;
  int? hUDCount;
  int? blockCount;
  int? pHCCount;
  int? hSCCount;

  Report(
      {this.totalSchool,
      this.totalStudent,
      this.totalCondition,
      this.districtCount,
      this.hUDCount,
      this.blockCount,
      this.pHCCount,
      this.hSCCount});

  Report.fromJson(Map<String, dynamic> json) {
    totalSchool = json['Total_School'];
    totalStudent = json['Total_Student'];
    totalCondition = json['Total_Condition'];
    districtCount = json['District_Count'];
    hUDCount = json['HUD_Count'];
    blockCount = json['Block_Count'];
    pHCCount = json['PHC_Count'];
    hSCCount = json['HSC_Count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Total_School'] = this.totalSchool;
    data['Total_Student'] = this.totalStudent;
    data['Total_Condition'] = this.totalCondition;
    data['District_Count'] = this.districtCount;
    data['HUD_Count'] = this.hUDCount;
    data['Block_Count'] = this.blockCount;
    data['PHC_Count'] = this.pHCCount;
    data['HSC_Count'] = this.hSCCount;
    return data;
  }
}

class SchoolList {
  var mappingFlag;
  var districtId;
  String? schoolId;
  String? schoolName;
  int? employeeId;
  var empId;
  bool? checked;
  var screeningId;
  var studentId;
  var classId;
  var studentFirstName;
  var condition;
  var screeningDate;
  String? lastScreenedDate;
  bool? attendace;
  var conditionList;

  int? screenedCount;
  int ?totalStudent;

  String ?attendanceStatus;

  SchoolList(
      {this.mappingFlag,
      this.districtId,
      this.schoolId,
      this.schoolName,
      this.employeeId,
      this.empId,
      this.checked,
      this.screeningId,
      this.studentId,
      this.classId,
      this.studentFirstName,
      this.condition,
      this.screeningDate,
      this.lastScreenedDate,
      this.attendace,
      this.conditionList,
      this.screenedCount,
      this.totalStudent,
      this.attendanceStatus});

  SchoolList.fromJson(Map<String, dynamic> json) {
    mappingFlag = json['Mapping_Flag'];
    districtId = json['District_Id'];
    schoolId = json['School_Id'];
    schoolName = json['School_Name'];
    employeeId = json['Employee_Id'];
    empId = json['EmpId'];
    checked = json['Checked'];
    screeningId = json['Screening_Id'];
    studentId = json['Student_Id'];
    classId = json['Class_Id'];
    studentFirstName = json['Student_First_Name'];
    condition = json['Condition'];
    screeningDate = json['Screening_Date'];
    lastScreenedDate = json['Last_Screened_Date'];
    attendace = json['Attendance'];
    conditionList = json['Condition_List'];

    screenedCount = json['Screened_Count'];
    totalStudent = json['Total_Student'];

    attendanceStatus = json['Attendance_Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Mapping_Flag'] = this.mappingFlag;
    data['District_Id'] = this.districtId;
    data['School_Id'] = this.schoolId;
    data['School_Name'] = this.schoolName;
    data['Employee_Id'] = this.employeeId;
    data['EmpId'] = this.empId;
    data['Checked'] = this.checked;
    data['Screening_Id'] = this.screeningId;
    data['Student_Id'] = this.studentId;
    data['Class_Id'] = this.classId;
    data['Student_First_Name'] = this.studentFirstName;
    data['Condition'] = this.condition;
    data['Screening_Date'] = this.screeningDate;
    data['Last_Screened_Date'] = this.lastScreenedDate;
    data['Attendance'] = this.attendace;
    data['Condition_List'] = this.conditionList;

    data['Screened_Count'] = this.screenedCount;
    data['Total_Student'] = this.totalStudent;

    data['Attendance_Status'] = this.attendanceStatus;
    return data;
  }
}
