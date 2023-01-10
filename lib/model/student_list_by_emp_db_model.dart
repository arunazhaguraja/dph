class StudentListByEmpDbModel {
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

  get getSchoolId => this.schoolId;

  get getClassId => this.classId;

  get getUDISECode => this.uDISECode;

  get getStudentId => this.studentId;

  get getStudentUniqueId => this.studentUniqueId;

  get getFirstName => this.firstName;

  get getDOB => this.dOB;

  get getMobileNo => this.mobileNo;

  get getBldGrp => this.bldGrp;

  get getScreeningId => this.screeningId;

  get getAttendance => this.attendance;

  StudentListByEmpDbModel(
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

  StudentListByEmpDbModel.fromJson(Map<String, dynamic> json) {
    schoolId = json['stuSchoolId'];
    classId = json['stuClassId'];
    uDISECode = json['stuUDISECode'];
    studentId = json['stuStudentId'];
    studentUniqueId = json['stuUniqueId'];
    firstName = json['stuFirstName'];
    dOB = json['stuDob'];
    mobileNo = json['stuMobileNumber'];
    bldGrp = json['stuBloodGroup'];
    screeningId = json['stuScreeningId'];
    attendance = json['stuAttendace'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stuSchoolId'] = this.schoolId;
    data['stuClassId'] = this.classId;
    data['stuUDISECode'] = this.uDISECode;
    data['stuStudentId'] = this.studentId;
    data['stuUniqueId'] = this.studentUniqueId;
    data['stuFirstName'] = this.firstName;
    data['stuDob'] = this.dOB;
    data['stuMobileNumber'] = this.mobileNo;
    data['stuBloodGroup'] = this.bldGrp;
    data['stuScreeningId'] = this.screeningId;
    data['stuAttendace'] = this.attendance;
    return data;
  }
}
