// To parse this JSON data, do
//
//     final mGetProvince = mGetProvinceFromJson(jsonString);

import 'dart:convert';

MGetProvince mGetProvinceFromJson(String str) =>
    MGetProvince.fromJson(json.decode(str));

String mGetProvinceToJson(MGetProvince data) => json.encode(data.toJson());

class MGetProvince {
  String provinceId;
  String provinceName;
  String locationid;
  String status;

  MGetProvince({
    required this.provinceId,
    required this.provinceName,
    required this.locationid,
    required this.status,
  });

  factory MGetProvince.fromJson(Map<String, dynamic> json) => MGetProvince(
        provinceId: json["province_id"],
        provinceName: json["province_name"],
        locationid: json["locationid"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "province_id": provinceId,
        "province_name": provinceName,
        "locationid": locationid,
        "status": status,
      };

  @override
  String toString() => provinceName;
  static fromJsonList(data) {}
}
