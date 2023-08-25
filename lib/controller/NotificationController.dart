import 'package:get/get.dart';
import 'package:stantapp/helper/Constant.dart';
import 'package:dio/dio.dart' as dio;

class NotificationController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();

  RxList<dynamic> notification =
      <dynamic>[].obs;

      Future<void> getNotifikasi(String user_id) async{
        try {
          dio.FormData formData = dio.FormData.fromMap({
            'user_id': user_id,
          });

          final response = await _dio.post('$api/getNotifikasi', data: formData);

          if(response.statusCode == 200){
                notification.value = response.data as List<dynamic>;
          }

        } catch (e) {
          
        }
      }
}