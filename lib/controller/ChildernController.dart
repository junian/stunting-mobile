import 'package:get/get.dart';
import 'package:stantapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:stantapp/helper/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stantapp/pages/HomePage2.dart';
import 'package:stantapp/pages/SetProfilePage.dart';
import 'package:stantapp/pages/VerivicationPage.dart';

class Anak {
  final String anak_id;
  final int user_id;

  Anak({required this.anak_id, required this.user_id});
}

class ChildernController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();

  RxList<dynamic> anakList =
      <dynamic>[].obs; // Variabel RxList untuk menyimpan data anak

  final RxList<dynamic> dataAnak =
      <dynamic>[].obs; // Variabel RxList untuk menyimpan data anak

  Future<void> registerAnak(
    String user_id,
    String nama_anak,
    String tanggal_lahir,
    String jenis_kelamin,
    String berat_badan,
    String tinggi_badan,
    String lingkar_kepala,
    String tinggi_badan_ibu,
    String tinggi_badan_ayah,
  ) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'user_id': user_id,
        'nama_anak': nama_anak,
        'tanggal_lahir': tanggal_lahir,
        'jenis_kelamin': jenis_kelamin,
        'berat_badan': berat_badan,
        'tinggi_badan': tinggi_badan,
        'lingkar_kepala': lingkar_kepala,
        'tinggi_badan_ibu': tinggi_badan_ibu,
        'tinggi_badan_ayah': tinggi_badan_ayah,
      });
      // print(nama_anak);
      final response = await _dio.post('$api/registerAnak', data: formData);
    } catch (e) {}
  }

  Future<void> getAnak(String user_id, String? anak_id) async {
    try {
      dio.FormData formData;
      if (anak_id != null) {
        formData = dio.FormData.fromMap({
          'user_id': user_id,
          'anak_id': anak_id,
        });
      } else {
        formData = dio.FormData.fromMap({
          'user_id': user_id,
        });
      }

      final response = await _dio.post('$api/getAnak', data: formData);
      // print(response);
      // Get.to(HomePage2(anak: response.data as List<dynamic>));
      anakList.value = response.data as List<dynamic>;
    } catch (e) {}
  }

  Future<void> getDataChildern(String user_id, String? anak_id) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'user_id': user_id,
        'anak_id': anak_id,
      });

      final response = await _dio.post('$api/getAnak', data: formData);
      print(response);
      // Get.to(HomePage2(anak: response.data as List<dynamic>));
      dataAnak.value = response.data as List<dynamic>;
    } catch (e) {}
  }
}
