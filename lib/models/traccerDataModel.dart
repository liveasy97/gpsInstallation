class TraccarDataModel {
  num? id;
  Attributes? attributes;

  TraccarDataModel({
    this.id,
    this.attributes,
  });

  TraccarDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    return data;
  }
}

class Attributes {
  bool? ignition;

  Attributes({this.ignition});

  Attributes.fromJson(Map<String, dynamic> json) {
    ignition = json['ignition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ignition'] = this.ignition;
    return data;
  }
}
