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

import 'package:stantapp/models/MGetRiwayatPertumbuhan.dart';
import 'package:stantapp/pages/VaksinasiAdd.dart';

class VaksinasiController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();
  File? pickedImage;
  TextEditingController nama_dokter = TextEditingController();
  TextEditingController tempat = TextEditingController();
  TextEditingController no_batch = TextEditingController();
  TextEditingController dateinput = TextEditingController();

  Future<void> addVaksinAnak({
    String? vaksin_anak_id,
    required anak_id,
    required vaksin_id,
    required String tanggal_vaksin,
    required String name_dokter,
    required String tempat,
    required String no_batch,
    required File? pickedImage,
  }) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'anak_id': anak_id,
        'vaksin_id': vaksin_id,
        'tanggal_vaksin': tanggal_vaksin,
        'nama_dokter': name_dokter,
        'tempat': tempat,
        'no_batch': Null,
        'vaksin_anak_id': vaksin_anak_id,
      });

      if (pickedImage != null) {
        String fileName = pickedImage.path.split('/').last;
        formData.files.add(MapEntry(
            'photo',
            await dio.MultipartFile.fromFile(pickedImage.path,
                filename: fileName)));
      }

      final response = await _dio.post('$api/addVaksinAnak', data: formData);

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

  Future<void> getVaksinAnak({
    required String anak_id,
    required String vaksin_id,
  }) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'anak_id': anak_id,
        'vaksin_id': vaksin_id,
      });

      final response = await _dio.post('$api/getVaksinAnak', data: formData);

      if (response.statusCode == 200) {
        dateinput.text = response.data[0]['tanggal_vaksin'];
        nama_dokter.text = response.data[0]['nama_dokter'];
        tempat.text = response.data[0]['tempat'];
        no_batch.text = response.data[0]['no_batch'];

        Get.to(() => VaksinasiAddPage(
              anak_id: anak_id,
              vaksin_id: vaksin_id,
              vaksin_anak_id: response.data[0]['vaksin_anak_id'],
            ));
      } else {
        print('gk ada  data ');
      }
    } catch (e) {
      // Error ketika mengirim data
      print('Error: $e');
    }
  }
}
