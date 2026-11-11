// To parse this JSON data, do
//
//     final mGetSubdistrict = mGetSubdistrictFromJson(jsonString);

import 'dart:convert';

MGetSubdistrict mGetSubdistrictFromJson(String str) =>
    MGetSubdistrict.fromJson(json.decode(str));

String mGetSubdistrictToJson(MGetSubdistrict data) =>
    json.encode(data.toJson());

class MGetSubdistrict {
  String kelurahanId;
  String kelurahanName;
  String kecamatanId;

  MGetSubdistrict({
    required this.kelurahanId,
    required this.kelurahanName,
    required this.kecamatanId,
  });

  factory MGetSubdistrict.fromJson(Map<String, dynamic> json) =>
      MGetSubdistrict(
        kelurahanId: json["kelurahan_id"],
        kelurahanName: json["kelurahan_name"],
        kecamatanId: json["kecamatan_id"],
      );

  Map<String, dynamic> toJson() => {
        "kelurahan_id": kelurahanId,
        "kelurahan_name": kelurahanName,
        "kecamatan_id": kecamatanId,
      };

  String toString() => kelurahanName;
  static fromJsonList(data) {}
}
