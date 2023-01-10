class UserDetailsModel {
  bool? success;
  String? message;
  int? statusCode;
  List<String>? errors;
  Data? data;

  UserDetailsModel(
      {this.success, this.message, this.statusCode, this.errors, this.data});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    statusCode = json['StatusCode'];
    errors = json['Errors'].cast<String>();
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = this.success;
    data['Message'] = this.message;
    data['StatusCode'] = this.statusCode;
    data['Errors'] = this.errors;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? employeeId;
  String? name;
  String? mobileNo;
  String? role;
  String? instType;
  String? empIdType;
  String? gender;

  Data(
      {this.id,
      this.employeeId,
      this.name,
      this.mobileNo,
      this.role,
      this.instType,
      this.empIdType,
      this.gender});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    employeeId = json['EmployeeId'];
    name = json['Name'];
    mobileNo = json['MobileNo'];
    role = json['Role'];
    instType = json['InstType'];
    empIdType = json['EmpIdType'];
    gender = json['Gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['EmployeeId'] = this.employeeId;
    data['Name'] = this.name;
    data['MobileNo'] = this.mobileNo;
    data['Role'] = this.role;
    data['InstType'] = this.instType;
    data['EmpIdType'] = this.empIdType;
    data['Gender'] = this.gender;
    return data;
  }
}