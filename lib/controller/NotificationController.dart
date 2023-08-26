import 'package:get/get.dart';
import 'package:stantapp/helper/Constant.dart';
import 'package:dio/dio.dart' as dio;

class NotificationController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();

  RxList<Map<String, dynamic>> notification = RxList<Map<String, dynamic>>([]);
  Future<void> getNotifikasi(String user_id) async {
    notification.clear();
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'user_id': user_id,
      });

      final response = await _dio.post('$api/getNotifikasi', data: formData);
      List allNotification = response.data;

      List<Map<String, dynamic>> convertedList =
          allNotification.map((item) => item as Map<String, dynamic>).toList();
      notification.value = convertedList;

      print(response.data);
    } catch (e) {}
  }
}
