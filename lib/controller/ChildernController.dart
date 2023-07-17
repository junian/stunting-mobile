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
import 'package:stantapp/widget/BottomNavbar.dart';

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
      RxList<dynamic>([]); // Variabel RxList untuk menyimpan data anak

  Future<void> registerAnak(
    String user_id,
    String? anak_id,
    String nama_anak,
    String tanggal_lahir,
    String jenis_kelamin,
    String berat_badan,
    String tinggi_badan,
    String lingkar_kepala,
    String tinggi_badan_ibu,
    String tinggi_badan_ayah,
    String gol_darah,
    String alergi,
    String prematur,
  ) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'user_id': user_id,
        'anak_id': anak_id,
        'nama_anak': nama_anak,
        'tanggal_lahir': tanggal_lahir,
        'jenis_kelamin': jenis_kelamin,
        'berat_badan': berat_badan,
        'tinggi_badan': tinggi_badan,
        'lingkar_kepala': lingkar_kepala,
        'tinggi_badan_ibu': tinggi_badan_ibu,
        'tinggi_badan_ayah': tinggi_badan_ayah,
        'gol_darah': gol_darah,
        'alergi': alergi,
        'prematur': prematur,
      });
      // print(nama_anak);
      final response = await _dio.post('$api/registerAnak', data: formData);
      print(response.data);
      var data = response.data;
      if (data['success'] == true) {
        Get.off(BottomNavbar());
      } else {}
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

  // Future<List<dynamic>> getAnak(String user_id, String? anak_id) async {
  //   try {
  //     dio.FormData formData;
  //     if (anak_id != null) {
  //       formData = dio.FormData.fromMap({
  //         'user_id': user_id,
  //         'anak_id': anak_id,
  //       });
  //     } else {
  //       formData = dio.FormData.fromMap({
  //         'user_id': user_id,
  //       });
  //     }

  //     final response = await _dio.post('$api/getAnak', data: formData);
  //     List<dynamic> anakList = response.data as List<dynamic>;
  //     return anakList;
  //   } catch (e) {
  //     // Handle error here
  //     return []; // Return empty list on error
  //   }
  // }

  Future<void> getAnakById(String user_id, String? anak_id) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'user_id': user_id,
        'anak_id': anak_id,
      });

      final response = await _dio.post('$api/getAnak', data: formData);
      List<dynamic> nyoba = [];
      nyoba.add(response);
      if (nyoba.isNotEmpty) {
        dataAnak.value = nyoba;
      }
      return response.data;
    } catch (e) {}
  }
}
