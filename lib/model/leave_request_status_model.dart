class LeaveRequestStatusModel {
  bool? success;
  String? message;
  int? statusCode;
  List<Data>? data;

  LeaveRequestStatusModel(
      {this.success, this.message, this.statusCode, this.data});

  LeaveRequestStatusModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    statusCode = json['StatusCode'];
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? fromDate;
  String ?toDate;
  int ?leaveRequestMasterId;
  String? empName;

  Data({this.fromDate, this.toDate, this.leaveRequestMasterId, this.empName});

  Data.fromJson(Map<String, dynamic> json) {
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    leaveRequestMasterId = json['LeaveRequestMaster_id'];
    empName = json['EmpName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FromDate'] = this.fromDate;
    data['ToDate'] = this.toDate;
    data['LeaveRequestMaster_id'] = this.leaveRequestMasterId;
    data['EmpName'] = this.empName;
    return data;
  }
}
