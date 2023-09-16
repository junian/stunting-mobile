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

class VideoController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();

  List<String> parameterData = [];

  Future<void> getParameterSplitted({
    required String parameter_id,
  }) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'parameter_id': parameter_id,
      });

      final response =
          await _dio.post('$api/getParameterSplitted', data: formData);

      if (response.statusCode == 200) {
        var responseData = response.data as List<dynamic>;
        parameterData = responseData.map((item) => item.toString()).toList();
      } else {
        print('gk ada  data ');
      }
    } catch (e) {
      // Error ketika mengirim data
      print('Error: $e');
    }
  }
}
