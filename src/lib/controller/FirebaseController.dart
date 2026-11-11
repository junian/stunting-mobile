import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:growthtracker/controller/SessionController.dart';
import 'package:growthtracker/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:growthtracker/helper/Constant.dart';
import 'package:growthtracker/models/MGetArticle.dart';
import 'package:growthtracker/models/MGetArticleCategory.dart';

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
