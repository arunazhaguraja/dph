class LeaveRequestDetailModel {
  bool? success;
  String? message;
  int? statusCode;
  List<Data>? data;

  LeaveRequestDetailModel(
      {this.success, this.message, this.statusCode, this.data});

  LeaveRequestDetailModel.fromJson(Map<String, dynamic> json) {
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
  int? leaveTypeId;
  String? date;
  String? dayType;
  String? reason;
  int? leaveRequestId;
  String? leaveType;
  String? approvalStatus;
  String? empName;
  String ?empName2;
  bool? checkStatus;

  Data(
      {this.leaveTypeId,
      this.date,
      this.dayType,
      this.reason,
      this.leaveRequestId,
      this.leaveType,
      this.approvalStatus,
      this.empName,
      this.empName2,
      this.checkStatus});

  Data.fromJson(Map<String, dynamic> json) {
    leaveTypeId = json['LeaveType_id'];
    date = json['Date'];
    dayType = json['DayType'];
    reason = json['Reason'];
    leaveRequestId = json['LeaveRequest_id'];
    leaveType = json['LeaveType'];
    approvalStatus = json['Approval_Status'];
    empName = json['EmpName'];
    empName2 = json['EmpName2'];
    checkStatus = json['CheckStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LeaveType_id'] = this.leaveTypeId;
    data['Date'] = this.date;
    data['DayType'] = this.dayType;
    data['Reason'] = this.reason;
    data['LeaveRequest_id'] = this.leaveRequestId;
    data['LeaveType'] = this.leaveType;
    data['Approval_Status'] = this.approvalStatus;
    data['EmpName'] = this.empName;
    data['EmpName2'] = this.empName2;
    data['CheckStatus'] = this.checkStatus;
    return data;
  }
}
