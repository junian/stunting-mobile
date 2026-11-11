// To parse this JSON data, do
//
//     final mGetArticle = mGetArticleFromJson(jsonString);

import 'dart:convert';

MGetArticle mGetArticleFromJson(String str) =>
    MGetArticle.fromJson(json.decode(str));

String mGetArticleToJson(MGetArticle data) => json.encode(data.toJson());

class MGetArticle {
  String? thumbnail;
  String artikelId;
  String artikelKategoriId;
  String judul;
  String konten;

  String createdBy;
  String createdDate;
  String namaKategori;
  String fullname;

  MGetArticle({
    this.thumbnail,
    required this.artikelId,
    required this.artikelKategoriId,
    required this.judul,
    required this.konten,
    required this.createdBy,
    required this.createdDate,
    required this.namaKategori,
    required this.fullname,
  });

  factory MGetArticle.fromJson(Map<String, dynamic> json) => MGetArticle(
        thumbnail: json["thumbnail"],
        artikelId: json["artikel_id"],
        artikelKategoriId: json["artikel_kategori_id"],
        judul: json["judul"],
        konten: json["konten"],
        createdBy: json["created_by"],
        createdDate: json["created_date"],
        namaKategori: json["nama_kategori"],
        fullname: json["fullname"],
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail,
        "artikel_id": artikelId,
        "artikel_kategori_id": artikelKategoriId,
        "judul": judul,
        "konten": konten,
        "created_by": createdBy,
        "created_date": createdDate,
        "nama_kategori": namaKategori,
        "fullname": fullname,
      };
}
