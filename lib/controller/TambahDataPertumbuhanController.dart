import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:stantapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:stantapp/helper/Constant.dart';
import 'package:stantapp/models/MGetArtikel.dart';
import 'package:stantapp/models/MGetArtikelKategori.dart';
// import 'package:stantapp/models/MGetJadwalVaksinasi.dart';
import 'package:stantapp/models/MGetRiwayatPertumbuhan.dart';

class TambahDataPertumbuhanController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();
  File? pickedImage;
  TextEditingController beratBadan = TextEditingController();
  TextEditingController tinggiBadan = TextEditingController();
  TextEditingController lingkarKepala = TextEditingController();

  Future<void> addPertumbuhanAnak({
    required String anakID,
    required DateTime selectedDate,
    required File pickedImage,
    required double beratBadan,
    required double tinggiBadan,
    required double lingkarKepala,
    required String tinggiBadanIbu,
    required String tinggiBadanAyah,
  }) async {
    try {
      String formattedDate = selectedDate.toIso8601String();

      dio.FormData formData = dio.FormData.fromMap({
        'anak_id': anakID,
        'tgl_pertumbuhan': formattedDate,
        'berat_badan': beratBadan,
        'tinggi_badan': tinggiBadan,
        'lingkar_kepala': lingkarKepala,
        'tinggi_badan_ibu': tinggiBadanIbu,
        'tinggi_badan_ayah': tinggiBadanAyah
      });

      if (pickedImage != null) {
        String fileName = pickedImage.path.split('/').last;
        formData.files.add(MapEntry(
            'photo',
            await dio.MultipartFile.fromFile(pickedImage.path,
                filename: fileName)));
      }

      final response =
          await _dio.post('$api/addPertumbuhanAnak', data: formData);

      if (response.statusCode == 200) {
        // Data berhasil terkirim
        print('Data berhasil terkirim');
      } else {
        // Gagal mengirim data
        print('Gagal mengirim data');
      }
    } catch (e) {
      // Error ketika mengirim data
      print('Error: $e');
    }
  }

  Future editPertumbuhanAnak(String pertumbuhanAnakId) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'pertumbuhan_anak_id': pertumbuhanAnakId,
      });

      final response =
          await _dio.post('$api/getDetailPertumbuhanAnak', data: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        if (responseData.isNotEmpty) {
          print(responseData);
        }
        return response.data;
      } else {
        print("erorr");
      }
    } catch (e) {
      print(e);
    }
  }
}
