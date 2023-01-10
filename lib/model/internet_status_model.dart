class InternetStatusModel {
  String? internetStatus;
  String? date;
  String? inTimeStatus;
  String? outTimeStatus;

  InternetStatusModel(
      {this.internetStatus, this.date, this.inTimeStatus, this.outTimeStatus});

  String get getInternetStatus => internetStatus!;
  String get getID => date!;
  String get getInTimeStatus => inTimeStatus!;
  String get getOutTimeStatus => outTimeStatus!;

  InternetStatusModel.fromJson(Map<String, dynamic> json) {
    internetStatus = json['InternetStatus'];
    date = json['AddressDate'];
    inTimeStatus = json['InTimeStatus'];
    outTimeStatus = json['OutTimeStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['InternetStatus'] = this.internetStatus;
    data['AddressDate'] = this.date;
    data["InTimeStatus"] = this.inTimeStatus;
    data["OutTimeStatus"] = this.outTimeStatus;

    return data;
  }
}
