class OutTimeModel {
  String? outTime;
  String? date;
  String? attendType;
  String? internetStatus;
  String? outTimeStatus;

  OutTimeModel(
      {this.outTime,
      this.date,
      this.attendType,
      this.internetStatus,
      this.outTimeStatus});

  String get getOutTime => outTime!;
  String get getID => date!;
  String get getAttendType => attendType!;
  String get getInternetStatus => internetStatus!;
  String get getOutTimeStatus => outTimeStatus!;

  OutTimeModel.fromJson(Map<String, dynamic> json) {
    outTime = json['OutTime'];
    date = json['AddressDate'];
    attendType = json['Type'];
    internetStatus = json['InternetStatus'];
    outTimeStatus = json['OutTimeStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['OutTime'] = this.outTime;
    data['AddressDate'] = this.date;
    data['Type'] = this.attendType;
    data['InternetStatus'] = this.internetStatus;
    data["OutTimeStatus"] = this.outTimeStatus;

    return data;
  }
}
