import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:stantapp/controller/SessionController.dart';
import 'package:stantapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:stantapp/helper/Constant.dart';
import 'package:stantapp/models/MGetArtikel.dart';
import 'package:stantapp/models/MGetArtikelKategori.dart';

class FirebaseController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();
  final sessionController = Get.put(SessionController());

  Future<String> updateFirebaseToken() async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'user_id': sessionController.user_id,
        'firebase_token': sessionController.token,
      });

      print('ini user : ${sessionController.user_id} , token : ${sessionController.token}');

      final response =
          await _dio.post('$api/updateFirebaseToken', data: formData);
      if (response.data['success'] == true) {
        print(response.data);
        return response.data;
      } else {
        print("erorr");
      }
    } catch (e) {
      print(e);
    }
    return 'Data yang diperoleh dari sumber eksternal';
  }
}
