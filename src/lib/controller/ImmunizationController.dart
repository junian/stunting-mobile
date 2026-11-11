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

class ImmunizationController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();

  RxList<dynamic> jadwalVaksin =
      <dynamic>[].obs; // RxList variable to store child data

  Future<void> getJadwalVaksin(String anak_id) async {
    try {
      dio.FormData formData;
      formData = dio.FormData.fromMap({
        'anak_id': anak_id,
      });

      final response = await _dio.post('$api/getJadwalVaksin', data: formData);
      // print(response.data);
      jadwalVaksin.value = response.data as List<dynamic>;
    } catch (e) {}
  }
}
