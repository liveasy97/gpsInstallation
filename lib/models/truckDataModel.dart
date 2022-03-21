class TruckDataModel {
  int? id;
  String? uniqueId;
  int? positionId;
  String? phone;
  bool? disabled;

  TruckDataModel(
      {this.id, this.uniqueId, this.positionId, this.phone, this.disabled});

  TruckDataModel.fromJson(List<dynamic> jsonL) {
    Map<String, dynamic> json = jsonL[0];
    id = json['id'];
    uniqueId = json['uniqueId'];
    positionId = json['positionId'];
    phone = json['phone'];
    disabled = json['disabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uniqueId'] = this.uniqueId;
    data['positionId'] = this.positionId;
    data['phone'] = this.phone;
    data['disabled'] = this.disabled;
    return data;
  }
}
