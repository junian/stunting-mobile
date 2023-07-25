import 'dart:io';

import 'package:get/get.dart';
import 'package:stantapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:stantapp/helper/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stantapp/models/ChildernModel.dart';
import 'package:stantapp/pages/HomePage2.dart';
import 'package:stantapp/pages/SetProfilePage.dart';
import 'package:stantapp/pages/VerivicationPage.dart';
import 'package:stantapp/widget/BottomNavbar.dart';

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
