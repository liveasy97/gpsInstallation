class HardwareDataModel {
  String? hardwareDataId;
  String? timestamp;
  String? imei;
  String? simNumber;
  String? phoneNo;

  HardwareDataModel(
      {this.hardwareDataId,
      this.timestamp,
      this.imei,
      this.simNumber,
      this.phoneNo});

  HardwareDataModel.fromJson(List<dynamic> jsonL) {
    Map<String, dynamic> json = jsonL[0];
    hardwareDataId = json['hardwareDataId'];
    timestamp = json['timestamp'];
    imei = json['imei'];
    simNumber = json['simNumber'];
    phoneNo = json['phoneNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hardwareDataId'] = this.hardwareDataId;
    data['timestamp'] = this.timestamp;
    data['imei'] = this.imei;
    data['simNumber'] = this.simNumber;
    data['phoneNo'] = this.phoneNo;
    return data;
  }
}
