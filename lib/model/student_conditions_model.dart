class StudentConditionsModel {
  bool? success;
  String? message;
  int? statusCode;
  List<String>? errors;
  List<Data> ?data;

  StudentConditionsModel(
      {this.success, this.message, this.statusCode, this.errors, this.data});

  StudentConditionsModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? code;
  String? name;
  List<Child>? child;

  Data({this.id, this.code, this.name, this.child});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    code = json['Code'];
    name = json['Name'];
    if (json['Child'] != null) {
      child = <Child>[];
      json['Child'].forEach((v) {
        child!.add(new Child.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Code'] = this.code;
    data['Name'] = this.name;
    if (this.child != null) {
      data['Child'] = this.child!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Child {
  int? id;
  String? code;
  String? name;

  Child({this.id, this.code, this.name});

  Child.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    code = json['Code'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Code'] = this.code;
    data['Name'] = this.name;
    return data;
  }
}
