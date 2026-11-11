import 'dart:convert';

List<MGrowthRecord> mGrowthRecordFromJsonList(String str) =>
    List<MGrowthRecord>.from(
        json.decode(str).map((x) => MGrowthRecord.fromJson(x)));

String mGrowthRecordListToJson(List<MGrowthRecord> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MGrowthRecord {
  int pertumbuhanAnakId;
  int anakId;
  double beratBadan;
  double tinggiBadan;
  double lingkarKepala;
  String? photo;
  int isActive;
  int createdBy;
  DateTime createdDate;
  int? updatedBy;
  DateTime? updatedDate;

  MGrowthRecord({
    required this.pertumbuhanAnakId,
    required this.anakId,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.lingkarKepala,
    this.photo,
    required this.isActive,
    required this.createdBy,
    required this.createdDate,
    this.updatedBy,
    this.updatedDate,
  });

  factory MGrowthRecord.fromJson(Map<String, dynamic> json) =>
      MGrowthRecord(
        pertumbuhanAnakId: json["pertumbuhan_anak_id"],
        anakId: json["anak_id"],
        beratBadan: json["berat_badan"].toDouble(),
        tinggiBadan: json["tinggi_badan"].toDouble(),
        lingkarKepala: json["lingkar_kepala"].toDouble(),
        photo: json["photo"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"] != null
            ? DateTime.parse(json["updated_date"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "pertumbuhan_anak_id": pertumbuhanAnakId,
        "anak_id": anakId,
        "berat_badan": beratBadan,
        "tinggi_badan": tinggiBadan,
        "lingkar_kepala": lingkarKepala,
        "photo": photo,
        "is_active": isActive,
        "created_by": createdBy,
        "created_date": createdDate.toIso8601String(),
        "updated_by": updatedBy,
        "updated_date":
            updatedDate != null ? updatedDate!.toIso8601String() : null,
      };
}
