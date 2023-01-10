class CommonUserModel {
  bool? success;
  String? message;
  int? statusCode;
  List<String>? errors;
  bool? data;

  CommonUserModel(
      {this.success, this.message, this.statusCode, this.errors, this.data});

  CommonUserModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    statusCode = json['StatusCode'];
    errors = json['Errors'].cast<String>();
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = this.success;
    data['Message'] = this.message;
    data['StatusCode'] = this.statusCode;
    data['Errors'] = this.errors;
    data['data'] = this.data;
    return data;
  }
}
