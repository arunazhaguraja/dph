class GeneralLeaveModel {
  String? success;
  String? message;
  String? statusCode;

  GeneralLeaveModel({this.success, this.message, this.statusCode});

  GeneralLeaveModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    statusCode = json['StatusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = this.success;
    data['Message'] = this.message;
    data['StatusCode'] = this.statusCode;
    return data;
  }
}
