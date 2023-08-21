import 'package:get/get.dart';

class SessionController extends GetxController {
  RxString email = ''.obs;
  RxString user_id = ''.obs;
  RxString token = ''.obs;

  void setData(
    String value,
    String value2,
  ) {
    email.value = value;
    user_id.value = value2;
  }

  void setToken(String tokenFirebase) {
    token.value = tokenFirebase;
  }

  void logout() {
    email.value = '';
    user_id.value = '';
    token.value = '';
  }
}
