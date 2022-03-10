class TruckDataModel {
  String? truckId;
  String? transporterId;
  String? truckNo;
  bool? truckApproved;
  String? imei;
  String? deviceId;
  int? passingWeight;
  String? driverId;
  int? tyres;
  String? truckLength;
  String? rcStatus;
  String? truckType;
  String? timestamp;

  TruckDataModel(
      {this.truckId,
      this.transporterId,
      this.truckNo,
      this.truckApproved,
      this.imei,
      this.deviceId,
      this.passingWeight,
      this.driverId,
      this.tyres,
      this.truckLength,
      this.rcStatus,
      this.truckType,
      this.timestamp});

  TruckDataModel.fromJson(Map<String, dynamic> json) {
    truckId = json['truckId'];
    transporterId = json['transporterId'];
    truckNo = json['truckNo'];
    truckApproved = json['truckApproved'];
    imei = json['imei'];
    deviceId = json['deviceId'];
    passingWeight = json['passingWeight'];
    driverId = json['driverId'];
    tyres = json['tyres'];
    truckLength = json['truckLength'];
    rcStatus = json['rcStatus'];
    truckType = json['truckType'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['truckId'] = this.truckId;
    data['transporterId'] = this.transporterId;
    data['truckNo'] = this.truckNo;
    data['truckApproved'] = this.truckApproved;
    data['imei'] = this.imei;
    data['deviceId'] = this.deviceId;
    data['passingWeight'] = this.passingWeight;
    data['driverId'] = this.driverId;
    data['tyres'] = this.tyres;
    data['truckLength'] = this.truckLength;
    data['rcStatus'] = this.rcStatus;
    data['truckType'] = this.truckType;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
