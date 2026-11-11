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

class ParameterController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();

  String parameterValue = "";

  Future<void> getParameter(String parameter_id) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'parameter_id': parameter_id,
      });

      final response = await _dio.post('$api/getParameter', data: formData);
      var data = response.data;
      return parameterValue = data['parameter_value'];
    } catch (e) {}
  }
}
