class LeaveCommonModel {
  bool? success;
  String? message;
  int? statusCode;
  int? data;

  LeaveCommonModel({this.success, this.message, this.statusCode, this.data});

  LeaveCommonModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    statusCode = json['StatusCode'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = this.success;
    data['Message'] = this.message;
    data['StatusCode'] = this.statusCode;
    data['data'] = this.data;
    return data;
  }
}
