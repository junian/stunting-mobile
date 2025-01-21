import 'package:get/get.dart';
import 'package:stantapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:stantapp/helper/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stantapp/models/ChildernModel.dart';
import 'package:stantapp/pages/HomePage2.dart';
import 'package:stantapp/pages/SetProfilePage.dart';
import 'package:stantapp/pages/VerivicationPage.dart';

class ImunisasiController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();

  RxList<dynamic> jadwalVaksin =
      <dynamic>[].obs; // Variabel RxList untuk menyimpan data anak

  Future<void> getJadwalVaksin(String anak_id) async {
    try {
      dio.FormData formData;
      formData = dio.FormData.fromMap({
        'anak_id': anak_id,
      });

      final response = await _dio.post('$api/getJadwalVaksin', data: formData);
      // print(response.data);
      jadwalVaksin.value = response.data as List<dynamic>;
    } catch (e) {}
  }
}
