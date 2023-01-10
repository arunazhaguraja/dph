class DistricModel {
  int? empId;
  int? staffTypeId;
  var staffTypeName;
  var empInternalId;
  var empIdType;
  var employeeTypeName;
  var empName;
  var empMobileNo;
  var empAddress;
  var empPassword;
  var empPhoto;
  var empAge;
  var empGender;
  var empRoleId;
  var empUserAccessId;
  var empInstitutionTyp;
  var empInstitutionId;
  var empType;
  bool? empIsActive;
  int? stateId;
  int? districtId;
  int? hUDId;
  int? blockId;
  int? pHCId;
  int? hSCId;
  var stateName;
  String? districtName;
  var hUDName;
  var blockName;
  var pHCName;
  var hSCName;
  var roleName;
  var institutionName;
  var userAccessName;
  bool? isActive;
  var empTypeName;
  var empGenderName;
  var dOB;

  DistricModel(
      {this.empId,
      this.staffTypeId,
      this.staffTypeName,
      this.empInternalId,
      this.empIdType,
      this.employeeTypeName,
      this.empName,
      this.empMobileNo,
      this.empAddress,
      this.empPassword,
      this.empPhoto,
      this.empAge,
      this.empGender,
      this.empRoleId,
      this.empUserAccessId,
      this.empInstitutionTyp,
      this.empInstitutionId,
      this.empType,
      this.empIsActive,
      this.stateId,
      this.districtId,
      this.hUDId,
      this.blockId,
      this.pHCId,
      this.hSCId,
      this.stateName,
      this.districtName,
      this.hUDName,
      this.blockName,
      this.pHCName,
      this.hSCName,
      this.roleName,
      this.institutionName,
      this.userAccessName,
      this.isActive,
      this.empTypeName,
      this.empGenderName,
      this.dOB});

  DistricModel.fromJson(Map<String, dynamic> json) {
    empId = json['EmpId'];
    staffTypeId = json['Staff_Type_Id'];
    staffTypeName = json['Staff_Type_Name'];
    empInternalId = json['EmpInternalId'];
    empIdType = json['EmpIdType'];
    employeeTypeName = json['EmployeeTypeName'];
    empName = json['EmpName'];
    empMobileNo = json['EmpMobileNo'];
    empAddress = json['EmpAddress'];
    empPassword = json['EmpPassword'];
    empPhoto = json['EmpPhoto'];
    empAge = json['EmpAge'];
    empGender = json['EmpGender'];
    empRoleId = json['EmpRoleId'];
    empUserAccessId = json['EmpUserAccessId'];
    empInstitutionTyp = json['EmpInstitutionTyp'];
    empInstitutionId = json['EmpInstitutionId'];
    empType = json['EmpType'];
    empIsActive = json['EmpIsActive'];
    stateId = json['State_Id'];
    districtId = json['District_Id'];
    hUDId = json['HUD_Id'];
    blockId = json['Block_Id'];
    pHCId = json['PHC_Id'];
    hSCId = json['HSC_Id'];
    stateName = json['State_Name'];
    districtName = json['District_Name'];
    hUDName = json['HUD_Name'];
    blockName = json['Block_Name'];
    pHCName = json['PHC_Name'];
    hSCName = json['HSC_Name'];
    roleName = json['RoleName'];
    institutionName = json['Institution_Name'];
    userAccessName = json['UserAccessName'];
    isActive = json['IsActive'];
    empTypeName = json['EmpType_Name'];
    empGenderName = json['EmpGender_Name'];
    dOB = json['DOB'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmpId'] = this.empId;
    data['Staff_Type_Id'] = this.staffTypeId;
    data['Staff_Type_Name'] = this.staffTypeName;
    data['EmpInternalId'] = this.empInternalId;
    data['EmpIdType'] = this.empIdType;
    data['EmployeeTypeName'] = this.employeeTypeName;
    data['EmpName'] = this.empName;
    data['EmpMobileNo'] = this.empMobileNo;
    data['EmpAddress'] = this.empAddress;
    data['EmpPassword'] = this.empPassword;
    data['EmpPhoto'] = this.empPhoto;
    data['EmpAge'] = this.empAge;
    data['EmpGender'] = this.empGender;
    data['EmpRoleId'] = this.empRoleId;
    data['EmpUserAccessId'] = this.empUserAccessId;
    data['EmpInstitutionTyp'] = this.empInstitutionTyp;
    data['EmpInstitutionId'] = this.empInstitutionId;
    data['EmpType'] = this.empType;
    data['EmpIsActive'] = this.empIsActive;
    data['State_Id'] = this.stateId;
    data['District_Id'] = this.districtId;
    data['HUD_Id'] = this.hUDId;
    data['Block_Id'] = this.blockId;
    data['PHC_Id'] = this.pHCId;
    data['HSC_Id'] = this.hSCId;
    data['State_Name'] = this.stateName;
    data['District_Name'] = this.districtName;
    data['HUD_Name'] = this.hUDName;
    data['Block_Name'] = this.blockName;
    data['PHC_Name'] = this.pHCName;
    data['HSC_Name'] = this.hSCName;
    data['RoleName'] = this.roleName;
    data['Institution_Name'] = this.institutionName;
    data['UserAccessName'] = this.userAccessName;
    data['IsActive'] = this.isActive;
    data['EmpType_Name'] = this.empTypeName;
    data['EmpGender_Name'] = this.empGenderName;
    data['DOB'] = this.dOB;
    return data;
  }
}
