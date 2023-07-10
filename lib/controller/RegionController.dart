import 'dart:convert';

import 'package:get/get.dart';
import 'package:stantapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:stantapp/helper/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stantapp/pages/SetProfilePage.dart';
import 'package:stantapp/pages/VerivicationPage.dart';

class RegionController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();

  final RxList<dynamic> provinces = <dynamic>[].obs;
  final RxList<dynamic> city = <dynamic>[].obs;

  void getProvince() async {
    try {
      // provinces.clear();
      final response = await _dio.get('$api/getProvince');
      provinces.value = response.data as List<dynamic>;
      return;
    } catch (e) {}
  }

  void getCity(String province_id) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'province_id': province_id,
      });
      // provinces.clear();
      final response = await _dio.post('$api/getCity', data: formData);
      city.value = jsonDecode(response.data) as List<dynamic>;
      // provinces.value = response.data as List<dynamic>;
    } catch (e) {}
  }
}
