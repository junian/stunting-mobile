// To parse this JSON data, do
//
//     final mGetDistrict = mGetDistrictFromJson(jsonString);

import 'dart:convert';

MGetDistrict mGetDistrictFromJson(String str) =>
    MGetDistrict.fromJson(json.decode(str));

String mGetDistrictToJson(MGetDistrict data) => json.encode(data.toJson());

class MGetDistrict {
  String kecamatanId;
  String kecamatanName;
  String cityId;

  MGetDistrict({
    required this.kecamatanId,
    required this.kecamatanName,
    required this.cityId,
  });

  factory MGetDistrict.fromJson(Map<String, dynamic> json) => MGetDistrict(
        kecamatanId: json["kecamatan_id"],
        kecamatanName: json["kecamatan_name"],
        cityId: json["city_id"],
      );

  Map<String, dynamic> toJson() => {
        "kecamatan_id": kecamatanId,
        "kecamatan_name": kecamatanName,
        "city_id": cityId,
      };

  String toString() => kecamatanName;
  static fromJsonList(data) {}
}
