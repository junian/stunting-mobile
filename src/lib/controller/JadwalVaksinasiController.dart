import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:stantapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:stantapp/helper/Constant.dart';

class JadwalVaksinasiController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();

  File? pickedImage;

  RxList<Map<String, dynamic>> jadwalVaksinasi =
      RxList<Map<String, dynamic>>([]);

  Future<String> getJadwalVaksin(String anakID) async {
    jadwalVaksinasi.clear();

    try {
      dio.FormData formData = dio.FormData.fromMap({
        'anak_id': anakID,
      });

      final response = await _dio.post('$api/getJadwalVaksin', data: formData);

      if (response.statusCode == 200) {
        List allJadwal = response.data;

        List<Map<String, dynamic>> convertedList =
            allJadwal.map((item) => item as Map<String, dynamic>).toList();
        jadwalVaksinasi.value = convertedList;
        return response.data;
      } else {
        print("erorr");
      }
    } catch (e) {
      print(e);
    }

    return "sukses";
  }

  Future<String> addVaksinAnak(String anak_id, String tanggal_vaksin,
      String nama_dokter, String tempat, String no_batch, File? photo) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'anak_id': anak_id,
        'tanggal_vaksin': tanggal_vaksin,
        'nama_dokter': nama_dokter,
        'tempat': tempat,
        'no_batch': no_batch,
      });

      print('${tanggal_vaksin}, ${nama_dokter}, ${tempat}, ${anak_id}');

      if (photo != null) {
        String fileName = photo.path.split('/').last;
        formData.files.add(MapEntry('photo',
            await dio.MultipartFile.fromFile(photo.path, filename: fileName)));
      }

      // final response = await _dio.post('$api/addVaksinAnak', data: formData);

      //   print(response);
      // if (response.statusCode == 200) {
      // } else {
      //   print("erorr");
      // }
    } catch (e) {
      print(e);
    }

    return "sukses";
  }
}
