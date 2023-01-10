class BlockModel {
  int ?blockId;
  String? blockGId;
  String? blockCode;
  String? blockName;
  int ?districtId;
  var districtName;
  int? hUDId;
  int? hUDGid;
  var hUDCode;
  var hUDName;
  bool? isActive;

  BlockModel(
      {this.blockId,
      this.blockGId,
      this.blockCode,
      this.blockName,
      this.districtId,
      this.districtName,
      this.hUDId,
      this.hUDGid,
      this.hUDCode,
      this.hUDName,
      this.isActive});

  BlockModel.fromJson(Map<String, dynamic> json) {
    blockId = json['Block_Id'];
    blockGId = json['Block_GId'];
    blockCode = json['Block_Code'];
    blockName = json['Block_Name'];
    districtId = json['District_Id'];
    districtName = json['District_Name'];
    hUDId = json['HUD_Id'];
    hUDGid = json['HUD_Gid'];
    hUDCode = json['HUD_Code'];
    hUDName = json['HUD_Name'];
    isActive = json['IsActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Block_Id'] = this.blockId;
    data['Block_GId'] = this.blockGId;
    data['Block_Code'] = this.blockCode;
    data['Block_Name'] = this.blockName;
    data['District_Id'] = this.districtId;
    data['District_Name'] = this.districtName;
    data['HUD_Id'] = this.hUDId;
    data['HUD_Gid'] = this.hUDGid;
    data['HUD_Code'] = this.hUDCode;
    data['HUD_Name'] = this.hUDName;
    data['IsActive'] = this.isActive;
    return data;
  }
}
