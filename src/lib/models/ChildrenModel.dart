// To parse this JSON data, do
//
//     final childrenModel = childrenModelFromJson(jsonString);

import 'dart:convert';

ChildrenModel childrenModelFromJson(String str) =>
    ChildrenModel.fromJson(json.decode(str));

String childrenModelToJson(ChildrenModel data) => json.encode(data.toJson());

class ChildrenModel {
  String anakId;
  String userId;
  String namaAnak;
  DateTime tanggalLahir;
  String jenisKelamin;
  dynamic photo;
  String beratBadan;
  String tinggiBadan;
  String lingkarKepala;
  String tinggiBadanIbu;
  String tinggiBadanAyah;
  dynamic golDarah;
  dynamic alergi;
  dynamic prematur;
  String isActive;
  String createdBy;
  DateTime createdDate;
  dynamic updatedBy;
  dynamic updatedDate;
  String umur;

  ChildrenModel({
    required this.anakId,
    required this.userId,
    required this.namaAnak,
    required this.tanggalLahir,
    required this.jenisKelamin,
    this.photo,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.lingkarKepala,
    required this.tinggiBadanIbu,
    required this.tinggiBadanAyah,
    this.golDarah,
    this.alergi,
    this.prematur,
    required this.isActive,
    required this.createdBy,
    required this.createdDate,
    this.updatedBy,
    this.updatedDate,
    required this.umur,
  });

  factory ChildrenModel.fromJson(Map<String, dynamic> json) => ChildrenModel(
        anakId: json["anak_id"],
        userId: json["user_id"],
        namaAnak: json["nama_anak"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        jenisKelamin: json["jenis_kelamin"],
        photo: json["photo"],
        beratBadan: json["berat_badan"],
        tinggiBadan: json["tinggi_badan"],
        lingkarKepala: json["lingkar_kepala"],
        tinggiBadanIbu: json["tinggi_badan_ibu"],
        tinggiBadanAyah: json["tinggi_badan_ayah"],
        golDarah: json["gol_darah"],
        alergi: json["alergi"],
        prematur: json["prematur"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"],
        umur: json["umur"],
      );

  Map<String, dynamic> toJson() => {
        "anak_id": anakId,
        "user_id": userId,
        "nama_anak": namaAnak,
        "tanggal_lahir":
            "${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}",
        "jenis_kelamin": jenisKelamin,
        "photo": photo,
        "berat_badan": beratBadan,
        "tinggi_badan": tinggiBadan,
        "lingkar_kepala": lingkarKepala,
        "tinggi_badan_ibu": tinggiBadanIbu,
        "tinggi_badan_ayah": tinggiBadanAyah,
        "gol_darah": golDarah,
        "alergi": alergi,
        "prematur": prematur,
        "is_active": isActive,
        "created_by": createdBy,
        "created_date": createdDate.toIso8601String(),
        "updated_by": updatedBy,
        "updated_date": updatedDate,
        "umur": umur,
      };
}
