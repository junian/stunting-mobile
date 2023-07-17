// To parse this JSON data, do
//
//     final mGetKecamatan = mGetKecamatanFromJson(jsonString);

import 'dart:convert';

MGetKecamatan mGetKecamatanFromJson(String str) =>
    MGetKecamatan.fromJson(json.decode(str));

String mGetKecamatanToJson(MGetKecamatan data) => json.encode(data.toJson());

class MGetKecamatan {
  String kecamatanId;
  String kecamatanName;
  String cityId;

  MGetKecamatan({
    required this.kecamatanId,
    required this.kecamatanName,
    required this.cityId,
  });

  factory MGetKecamatan.fromJson(Map<String, dynamic> json) => MGetKecamatan(
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
