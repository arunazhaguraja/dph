class SchoolListDbModel {
  String ?schoolId;
  String ?schoolName;
  String ?attendance;
  String ?attendanceStatus;
  String ?lastScreenDate;

  SchoolListDbModel(
      {this.schoolId,
      this.schoolName,
      this.attendance,
      this.attendanceStatus,
      this.lastScreenDate});

  get getSchoolId => this.schoolId;

  get getSchoolName => this.schoolName;

  get getAttendance => this.attendance;

  get getAttendanceStatus => this.attendanceStatus;

  get getLastScreenDate => this.lastScreenDate;

  SchoolListDbModel.fromJson(Map<String, dynamic> json) {
    schoolId = json['schoolId'];
    schoolName = json['schoolName'];
    attendance = json['schoolAttendance'];
    attendanceStatus = json['schoolAttendanceStatus'];
    lastScreenDate = json['schoolLastScreenDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schoolId'] = this.schoolId;
    data['schoolName'] = this.schoolName;
    data['schoolAttendance'] = this.attendance;
    data['schoolAttendanceStatus'] = this.attendanceStatus;
    data['schoolLastScreenDate'] = this.lastScreenDate;

    return data;
  }
}
