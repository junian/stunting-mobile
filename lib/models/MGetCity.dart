// To parse this JSON data, do
//
//     final mGetCity = mGetCityFromJson(jsonString);

import 'dart:convert';

MGetCity mGetCityFromJson(String str) => MGetCity.fromJson(json.decode(str));

String mGetCityToJson(MGetCity data) => json.encode(data.toJson());

class MGetCity {
  String cityId;
  String cityName;
  String provinceId;

  MGetCity({
    required this.cityId,
    required this.cityName,
    required this.provinceId,
  });

  factory MGetCity.fromJson(Map<String, dynamic> json) => MGetCity(
        cityId: json["city_id"],
        cityName: json["city_name"],
        provinceId: json["province_id"],
      );

  Map<String, dynamic> toJson() => {
        "city_id": cityId,
        "city_name": cityName,
        "province_id": provinceId,
      };
  @override
  String toString() => cityName;
  static fromJsonList(data) {}
}
