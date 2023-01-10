class HudModel {
  String? hUDName;
  int? hUDId;

  HudModel({this.hUDName, this.hUDId});

  HudModel.fromJson(Map<String, dynamic> json) {
    hUDName = json['HUD_Name'];
    hUDId = json['HUD_Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HUD_Name'] = this.hUDName;
    data['HUD_Id'] = this.hUDId;
    return data;
  }
}
