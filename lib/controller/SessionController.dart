import 'package:get/get.dart';

class SessionController extends GetxController {
  RxString email = ''.obs;
  RxString user_id = ''.obs;

  void setData(String value, String value2) {
    email.value = value;
    user_id.value = value2;
  }

  void logout() {
    email.value = '';
    user_id.value = '';
  }
}
