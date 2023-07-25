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
}
