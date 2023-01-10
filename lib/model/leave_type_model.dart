class LeaveTypeModel {
  String? success;
  String? message;
  String? statusCode;
  List<Data> ?data;

  LeaveTypeModel({this.success, this.message, this.statusCode, this.data});

  LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    statusCode = json['StatusCode'];
    if (json['Data'] != null) {
      data = <Data>[];
      json['Data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = this.success;
    data['Message'] = this.message;
    data['StatusCode'] = this.statusCode;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? leaveTypeId;
  String? leaveType;

  Data({this.leaveTypeId, this.leaveType});

  Data.fromJson(Map<String, dynamic> json) {
    leaveTypeId = json['LeaveType_id'];
    leaveType = json['LeaveType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LeaveType_id'] = this.leaveTypeId;
    data['LeaveType'] = this.leaveType;
    return data;
  }
}
