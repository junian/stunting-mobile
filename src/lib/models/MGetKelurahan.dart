// To parse this JSON data, do
//
//     final mGetKelurahan = mGetKelurahanFromJson(jsonString);

import 'dart:convert';

MGetKelurahan mGetKelurahanFromJson(String str) =>
    MGetKelurahan.fromJson(json.decode(str));

String mGetKelurahanToJson(MGetKelurahan data) => json.encode(data.toJson());

class MGetKelurahan {
  String kelurahanId;
  String kelurahanName;
  String kecamatanId;

  MGetKelurahan({
    required this.kelurahanId,
    required this.kelurahanName,
    required this.kecamatanId,
  });

  factory MGetKelurahan.fromJson(Map<String, dynamic> json) => MGetKelurahan(
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
