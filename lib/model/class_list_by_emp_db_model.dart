class ClassListByEmpDbModel {
  int? schoolId;
  String? uDISECode;
  int? classId;
  String? classNm;
  String? section;
  String? lastScreenedDate;
  String? attendanceStatus;
  int? studentCount;

  ClassListByEmpDbModel(
      {this.schoolId,
      this.uDISECode,
      this.classId,
      this.classNm,
      this.section,
      this.lastScreenedDate,
      this.attendanceStatus,
      this.studentCount});

  get getSchoolId => this.schoolId;

  get getUDISECode => this.uDISECode;

  get getClassId => this.classId;

  get getClassNm => this.classNm;

  get getSection => this.section;

  get getLastScreenedDate => this.lastScreenedDate;

  get getAttendanceStatus => this.attendanceStatus;

  get getStudentCount => this.studentCount;

  ClassListByEmpDbModel.fromJson(Map<String, dynamic> json) {
    schoolId = json['clsSchoolId'];
    uDISECode = json['classUDISECode'];
    classId = json['classId'];
    classNm = json['className'];
    section = json['classSection'];
    lastScreenedDate = json['classLastScreenDate'];
    attendanceStatus = json['classAttendanceStatus'];
    studentCount = json['classStudentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clsSchoolId'] = this.schoolId;
    data['classUDISECode'] = this.uDISECode;
    data['classId'] = this.classId;
    data['className'] = this.classNm;
    data['classSection'] = this.section;
    data['classLastScreenDate'] = this.lastScreenedDate;
    data['classAttendanceStatus'] = this.attendanceStatus;
    data['classStudentCount'] = this.studentCount;
    return data;
  }
}
