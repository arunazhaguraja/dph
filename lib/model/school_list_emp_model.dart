class SchoolListEmpModel {
  bool? success;
  String? message;
  int ?statusCode;
  List<String> ?errors;
  List<Data> ?data;

  SchoolListEmpModel(
      {this.success, this.message, this.statusCode, this.errors, this.data});

  SchoolListEmpModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    statusCode = json['StatusCode'];
    errors = json['Errors'].cast<String>();
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = this.success;
    data['Message'] = this.message;
    data['StatusCode'] = this.statusCode;
    data['Errors'] = this.errors;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? schoolId;
  String ?uDISECode;
  String ?schoolName;
  String ?instType;
  String ?schoolType;
  String ?schoolTypeAPI;

  Data(
      {this.schoolId,
      this.uDISECode,
      this.schoolName,
      this.instType,
      this.schoolType,
      this.schoolTypeAPI});

  Data.fromJson(Map<String, dynamic> json) {
    schoolId = json['SchoolId'];
    uDISECode = json['UDISECode'];
    schoolName = json['SchoolName'];
    instType = json['InstType'];
    schoolType = json['SchoolType'];
    schoolTypeAPI = json['SchoolTypeAPI'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SchoolId'] = this.schoolId;
    data['UDISECode'] = this.uDISECode;
    data['SchoolName'] = this.schoolName;
    data['InstType'] = this.instType;
    data['SchoolType'] = this.schoolType;
    data['SchoolTypeAPI'] = this.schoolTypeAPI;
    return data;
  }
}