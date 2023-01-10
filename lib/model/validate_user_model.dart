class ValidateUserModel {
  bool? success;
  String? message;
  int ?statusCode;
  List<String> ?errors;
  Data ?data;

  ValidateUserModel(
      {this.success, this.message, this.statusCode, this.errors, this.data});

  ValidateUserModel.fromJson(Map<String, dynamic> json) {
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
  String? userNm;
  int? id;
  String? internalId;
  String? name;
  String? employeeFullName;
  String? mobileNo;
  int? roleId;
  int? userAccessId;
  String? empType;
  String? token;
  int ?empInstitutionTyp;
  int ?districtId;
  int ?hUDId;
  int ?blockId;
  int ?pHCId;
  int ?hSCId;
  String ?roleName;
  String ?employeeTypeName;
  int ?screenFlag;

  Data(
      {this.userNm,
      this.id,
      this.internalId,
      this.name,
      this.employeeFullName,
      this.mobileNo,
      this.roleId,
      this.userAccessId,
      this.empType,
      this.token,
      this.empInstitutionTyp,
      this.districtId,
      this.hUDId,
      this.blockId,
      this.pHCId,
      this.hSCId,
      this.roleName,
      this.employeeTypeName,
      this.screenFlag});

  Data.fromJson(Map<String, dynamic> json) {
    userNm = json['UserNm'];
    id = json['Id'];
    internalId = json['InternalId'];
    name = json['Name'];
    employeeFullName = json['EmployeeFullName'];
    mobileNo = json['MobileNo'];
    roleId = json['RoleId'];
    userAccessId = json['UserAccessId'];
    empType = json['EmpType'];
    token = json['Token'];
    empInstitutionTyp = json['EmpInstitutionTyp'];
    districtId = json['District_Id'];
    hUDId = json['HUD_Id'];
    blockId = json['Block_Id'];
    pHCId = json['PHC_Id'];
    hSCId = json['HSC_Id'];
    roleName = json['RoleName'];
    employeeTypeName = json['EmployeeTypeName'];
    screenFlag = json['ScreeningFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserNm'] = this.userNm;
    data['Id'] = this.id;
    data['InternalId'] = this.internalId;
    data['Name'] = this.name;
    data['EmployeeFullName'] = this.employeeFullName;
    data['MobileNo'] = this.mobileNo;
    data['RoleId'] = this.roleId;
    data['UserAccessId'] = this.userAccessId;
    data['EmpType'] = this.empType;
    data['Token'] = this.token;
    data['EmpInstitutionTyp'] = this.empInstitutionTyp;
    data['District_Id'] = this.districtId;
    data['HUD_Id'] = this.hUDId;
    data['Block_Id'] = this.blockId;
    data['PHC_Id'] = this.pHCId;
    data['HSC_Id'] = this.hSCId;
    data['RoleName'] = this.roleName;
    data['EmployeeTypeName'] = this.employeeTypeName;
    data['ScreeningFlag'] = this.screenFlag;
    return data;
  }
}
