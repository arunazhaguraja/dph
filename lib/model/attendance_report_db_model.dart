class AttendanceReportDbModel {
  String? empId;
  String? image;
  String? lattitude;
  String? longtitude;
  String? altitude;
  String? internetStatus;
  String? addressDate;
  String? inTime;
  String? attendType;
  String? outTime;
  String? inTimeStatus;
  String? outTimeStatus;
  String? workStatus;
  String? dayStatus;

  AttendanceReportDbModel(
      {this.empId,
      this.image,
      this.lattitude,
      this.longtitude,
      this.altitude,
      this.internetStatus,
      this.addressDate,
      this.inTime,
      this.attendType,
      this.outTime,
      this.inTimeStatus,
      this.outTimeStatus,
      this.workStatus,
      this.dayStatus});

  String get getEmpId => empId!;

  String get getImage => image!;

  String get getLattitude => lattitude!;

  String get getLongtitude => longtitude!;

  String get getAltitude => altitude!;

  String get getInternetStatus => internetStatus!;

  String get getAddressDate => addressDate!;

  String get getInTime => inTime!;

  String get getAttendType => attendType!;

  String get getOutTime => outTime!;

  String get getInTimeStatus => inTimeStatus!;

  String get getOutTimeStatus => outTimeStatus!;

  String get getWorkStatus => workStatus!;

  String get getDayStatus => dayStatus!;

  AttendanceReportDbModel.fromJson(Map<String, dynamic> json) {
    empId = json['EmpId'];
    image = json['Image'];
    lattitude = json['Lattitude'];
    longtitude = json['Longtitude'];
    altitude = json['Altitude'];
    internetStatus = json['InternetStatus'];
    addressDate = json['AddressDate'];
    inTime = json['InTime'];
    attendType = json['Type'];
    outTime = json['OutTime'];
    inTimeStatus = json['InTimeStatus'];
    outTimeStatus = json['OutTimeStatus'];
    workStatus = json['WorkStatus'];
    dayStatus = json['DayStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmpId'] = this.empId;
    data['Image'] = this.image;
    data['Lattitude'] = this.lattitude;
    data['Longtitude'] = this.longtitude;
    data['Altitude'] = this.altitude;
    data['InternetStatus'] = this.internetStatus;
    data['AddressDate'] = this.addressDate;
    data['InTime'] = this.inTime;
    data["Type"] = this.attendType;
    data["OutTime"] = this.outTime;
    data["InTimeStatus"] = this.inTimeStatus;
    data["OutTimeStatus"] = this.outTimeStatus;
    data["WorkStatus"] = this.workStatus;
    data["DayStatus"] = this.dayStatus;
    return data;
  }
}
