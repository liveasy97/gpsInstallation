class InstallerTaskModel {
  String? installerTaskId;
  String? timestamp;
  String? vehicleNo;
  String? vehicleOwnerName;
  String? vehicleOwnerPhoneNo;
  String? driverName;
  String? driverPhoneNo;
  String? installationDate;
  String? installationCompleteDate;
  String? installationLocation;
  String? gpsInstallerId;

  InstallerTaskModel(
      {this.installerTaskId,
      this.timestamp,
      this.vehicleNo,
      this.vehicleOwnerName,
      this.vehicleOwnerPhoneNo,
      this.driverName,
      this.driverPhoneNo,
      this.installationDate,
      this.installationCompleteDate,
      this.installationLocation,
      this.gpsInstallerId});

  InstallerTaskModel.fromJson(Map<String, dynamic> json) {
    installerTaskId = json['installerTaskId'];
    timestamp = json['timestamp'];
    vehicleNo = json['vehicleNo'];
    vehicleOwnerName = json['vehicleOwnerName'];
    vehicleOwnerPhoneNo = json['vehicleOwnerPhoneNo'];
    driverName = json['driverName'];
    driverPhoneNo = json['driverPhoneNo'];
    installationDate = json['installationDate'];
    installationCompleteDate = json['installationCompleteDate'];
    installationLocation = json['installationLocation'];
    gpsInstallerId = json['gpsInstallerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['installerTaskId'] = this.installerTaskId;
    data['timestamp'] = this.timestamp;
    data['vehicleNo'] = this.vehicleNo;
    data['vehicleOwnerName'] = this.vehicleOwnerName;
    data['vehicleOwnerPhoneNo'] = this.vehicleOwnerPhoneNo;
    data['driverName'] = this.driverName;
    data['driverPhoneNo'] = this.driverPhoneNo;
    data['installationDate'] = this.installationDate;
    data['installationCompleteDate'] = this.installationCompleteDate;
    data['installationLocation'] = this.installationLocation;
    data['gpsInstallerId'] = this.gpsInstallerId;
    return data;
  }
}
