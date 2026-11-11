// To parse this JSON data, do
//
//     final mGetArticleCategory = mGetArticleCategoryFromJson(jsonString);

import 'dart:convert';

MGetArticleCategory mGetArticleCategoryFromJson(String str) =>
    MGetArticleCategory.fromJson(json.decode(str));

String mGetArticleCategoryToJson(MGetArticleCategory data) =>
    json.encode(data.toJson());

class MGetArticleCategory {
  String artikelKategoriId;
  String namaKategori;
  String isActive;
  String createdBy;
  String createdDate;

  MGetArticleCategory({
    required this.artikelKategoriId,
    required this.namaKategori,
    required this.isActive,
    required this.createdBy,
    required this.createdDate,
  });

  factory MGetArticleCategory.fromJson(Map<String, dynamic> json) =>
      MGetArticleCategory(
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
