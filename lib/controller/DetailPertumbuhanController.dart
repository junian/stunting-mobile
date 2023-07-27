import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:stantapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:stantapp/helper/Constant.dart';
import 'package:stantapp/models/MGetArtikel.dart';
import 'package:stantapp/models/MGetArtikelKategori.dart';
import 'package:stantapp/pages/DetailPertumbuhan.dart';

import 'RiwayatPertumbuhanController.dart';

class DetailPertumbuhanController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();
  var riwayatPertumbuhanController = Get.put(RiwayatPertumbuhanController());

  Future getDetailPertumbuhan(String pertumbuhanAnakId, String umur) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'pertumbuhan_anak_id': pertumbuhanAnakId,
      });

      final response =
          await _dio.post('$api/getDetailPertumbuhanAnak', data: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        if (responseData.isNotEmpty) {
          print(responseData['lingkar_kepala']);
          Get.to(
            DetailPertumbuhanPage(
              pertumbuhanAnakId: responseData['pertumbuhan_anak_id'],
              anakId: responseData['anak_id'],
              beratBadan: responseData['berat_badan'],
              tinggiBadan: responseData['tinggi_badan'],
              lingkarKepala: responseData['lingkar_kepala'],
              createdDate: responseData['created_date'],
              statusPertumbuhanBerat: responseData['status_pertumbuhan_berat'],
              statusPertumbuhanTinggi:
                  responseData['status_pertumbuhan_tinggi'],
              statusPertumbuhanLingkarKepala:
                  responseData['status_pertumbuhan_lingkar_kepala'],
              umur: umur,
            ),
          );
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
