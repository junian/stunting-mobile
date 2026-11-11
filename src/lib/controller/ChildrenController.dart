import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:growthtracker/helper/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:growthtracker/models/ChildrenModel.dart';
import 'package:growthtracker/pages/HomePage2.dart';
import 'package:growthtracker/pages/SetProfilePage.dart';
import 'package:growthtracker/pages/VerificationPage.dart';
import 'package:growthtracker/widget/BottomNavbar.dart';

class Anak {
  final String anak_id;
  final int user_id;

  Anak({required this.anak_id, required this.user_id});
}

class ChildrenController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();

  RxList<dynamic> anakList =
      <dynamic>[].obs; // RxList variable to store child data

  final RxList<dynamic> dataAnak =
      RxList<dynamic>([]); // RxList variable to store child data

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
    File? photo,
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

      if (photo != null) {
        String fileName = photo.path.split('/').last;
        formData.files.add(MapEntry('photo',
            await dio.MultipartFile.fromFile(photo.path, filename: fileName)));
      }
      // print(nama_anak);
      final response = await _dio.post('$api/registerAnak', data: formData);
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
