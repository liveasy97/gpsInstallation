class TraccarDataModel {
  num? id;
  Attributes? attributes;
  int? deviceId;
  double? latitude;
  double? longitude;

  TraccarDataModel({
    this.id,
    this.attributes,
    this.deviceId,
    this.latitude,
    this.longitude,
  });

  TraccarDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
    deviceId = json['deviceId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    data['deviceId'] = this.deviceId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Attributes {
  bool? ignition;

  Attributes({
    this.ignition,
  });

  Attributes.fromJson(Map<String, dynamic> json) {
    ignition = json['ignition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['ignition'] = this.ignition;

    return data;
  }
}
