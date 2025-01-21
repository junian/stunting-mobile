// To parse this JSON data, do
//
//     final mGetArtikelKategori = mGetArtikelKategoriFromJson(jsonString);

import 'dart:convert';

MGetArtikelKategori mGetArtikelKategoriFromJson(String str) =>
    MGetArtikelKategori.fromJson(json.decode(str));

String mGetArtikelKategoriToJson(MGetArtikelKategori data) =>
    json.encode(data.toJson());

class MGetArtikelKategori {
  String artikelKategoriId;
  String namaKategori;
  String isActive;
  String createdBy;
  String createdDate;

  MGetArtikelKategori({
    required this.artikelKategoriId,
    required this.namaKategori,
    required this.isActive,
    required this.createdBy,
    required this.createdDate,
  });

  factory MGetArtikelKategori.fromJson(Map<String, dynamic> json) =>
      MGetArtikelKategori(
        artikelKategoriId: json["artikel_kategori_id"],
        namaKategori: json["nama_kategori"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        createdDate: json["created_date"],
      );

  Map<String, dynamic> toJson() => {
        "artikel_kategori_id": artikelKategoriId,
        "nama_kategori": namaKategori,
        "is_active": isActive,
        "created_by": createdBy,
        "created_date": createdDate,
      };
}
