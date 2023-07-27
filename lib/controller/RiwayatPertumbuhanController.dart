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

class RiwayatPertumbuhanController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();
  RxList<Map<String, dynamic>> riwayatPertumbuhan =
      RxList<Map<String, dynamic>>([]);

  Future<String> getPertumbuhanAnak(String anakID) async {
    riwayatPertumbuhan.clear();
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'anak_id': anakID,
      });

      final response =
          await _dio.post('$api/getPertumbuhanAnak', data: formData);

      if (response.statusCode == 200) {
        List riwayatAnak = response.data;

        List<Map<String, dynamic>> convertedList =
            riwayatAnak.map((item) => item as Map<String, dynamic>).toList();
        riwayatPertumbuhan.value = convertedList;
      } else {
        print("erorr");
      }
    } catch (e) {
      print(e);
    }

    return "sukses";
  }
}
