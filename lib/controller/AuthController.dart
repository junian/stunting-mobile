import 'package:get/get.dart';
import 'package:stantapp/controller/RegionController.dart';
import 'package:stantapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:stantapp/helper/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stantapp/pages/HomePage.dart';
import 'package:stantapp/pages/SetProfilePage.dart';
import 'package:stantapp/pages/VerivicationPage.dart';
import 'package:stantapp/widget/BottomNavbar.dart';

class AuthController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();
  RxBool isAuthenticated = false.obs;
  final String loggedInKey = 'loggedIn';

  List<dynamic> isParent = [];

  // final sessionController = Get.put(SessionController());

  Future<void> reqAuthCode(String email, String phone_no) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'email': email,
      });

      final response = await _dio.post('$api/reqAuthCode', data: formData);
      print(response);

      if (response.data['success'] == true) {
        String authCode = response.data['message'].toString();
        Get.to(
          VerivicationPage(
            email: email,
            authCode: authCode,
            phone_no: phone_no,
          ),
        );
      } else {
        // Data tidak ditemukan
        // Fluttertoast.showToast(
        //   msg: 'User not found',
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.BOTTOM,
        //   backgroundColor: Colors.black38,
        //   textColor: Colors.white,
        // );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> login(
    String email,
    String isAuthCode,
  ) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'email': email,
        'auth_code': isAuthCode,
      });
      final response = await _dio.post('$api/login', data: formData);

      if (response.data['success'] == true) {
        // Set isAuthenticated to true
        isAuthenticated.value = true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(loggedInKey, true);

        // Data ditemukan
        // String employeeName = response.data['data']['employee_name'];
        // String employeeId = response.data['data']['employee_id'];
        // // sessionController.setData(employeeName, employeeId);
        // await prefs.setString('name', employeeName);
        // await prefs.setString('id', employeeId);

        //redirect
        //cek apakah ada orang tua atau tidak
        print(response.data);
        await getOrangTua(4.toString());
        // Set nilai variabel list dengan response data
        if (isParent.isEmpty) {
          var regionController = Get.put(RegionController());
          return Get.offAll(SetProfilePage(
            province: regionController.provinces as List<dynamic>,
          ));
        } else {
          Get.offAll(BottomNavbar());
        }
      } else {
        // Data tidak ditemukan
        Fluttertoast.showToast(
          msg: response.data['message'].toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> register(
    String email,
    String phone_no,
    String isAuthCode,
  ) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'email': email,
        'phone_no': phone_no,
        'auth_code': isAuthCode,
      });
      final response = await _dio.post('$api/register', data: formData);

      print(response);
      if (response.data['success'] == true) {
        // Set isAuthenticated to true
        isAuthenticated.value = true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(loggedInKey, true);

        // Data ditemukan
        String employeeName = response.data['data']['employee_name'];
        String employeeId = response.data['data']['employee_id'];
        // sessionController.setData(employeeName, employeeId);
        await prefs.setString('name', employeeName);
        await prefs.setString('id', employeeId);

        //redirect
        // return Get.offAll(SetProfilePage());
      } else {
        // Data tidak ditemukan
        Fluttertoast.showToast(
          msg: response.data['message'].toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getOrangTua(
    String user_id,
  ) async {
    try {
      print(user_id);
      dio.FormData formData = dio.FormData.fromMap({
        'user_id': user_id,
      });
      final response = await _dio.post('$api/getOrangTua', data: formData);
      isParent = response.data as List<dynamic>;
      // print(response);
      // if (response.data['success'] == true) {
      //   // Set isAuthenticated to true
      //   isAuthenticated.value = true;
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setBool(loggedInKey, true);

      //   // Data ditemukan
      //   // String employeeName = response.data['data']['employee_name'];
      //   // String employeeId = response.data['data']['employee_id'];
      //   // // sessionController.setData(employeeName, employeeId);
      //   // await prefs.setString('name', employeeName);
      //   // await prefs.setString('id', employeeId);

      //   //redirect
      //   var regionController = Get.put(RegionController());
      //   return Get.offAll(SetProfilePage(
      //     province: regionController.provinces as List<dynamic>,
      //   ));
      // } else {
      //   // Data tidak ditemukan
      //   Fluttertoast.showToast(
      //     msg: response.data['message'].toString(),
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.CENTER,
      //     backgroundColor: Colors.black38,
      //     textColor: Colors.white,
      //   );
      // }
    } catch (e) {
      print(e);
    }
  }

  // Future<void> logout() async {
  //   sessionController.logout();

  //   // Set isAuthenticated to false
  //   isAuthenticated.value = false;

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool(loggedInKey, false);

  //   // Navigate to Login Page
  //   Get.offAll(LoginPage());
  // }

  // Future<void> checkAuthentication() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isLoggedIn = prefs.getBool(loggedInKey) ?? false;
  //   isAuthenticated.value = isLoggedIn;
  //   String name = prefs.getString('name') ?? '';
  //   String id = prefs.getString('id') ?? '';
  //   sessionController.setData(name, id);
  // }
}
