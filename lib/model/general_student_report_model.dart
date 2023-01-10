class GeneralStudentReportModel {
  String? message;

  GeneralStudentReportModel({this.message});

  GeneralStudentReportModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    return data;
  }
}
