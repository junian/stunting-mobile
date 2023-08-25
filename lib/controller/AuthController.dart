import 'dart:io';

import 'package:get/get.dart';
import 'package:stantapp/controller/RegionController.dart';
import 'package:stantapp/controller/SessionController.dart';
import 'package:stantapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:stantapp/helper/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stantapp/pages/HomePage.dart';
import 'package:stantapp/pages/LoginPage.dart';
import 'package:stantapp/pages/SetProfilePage.dart';
import 'package:stantapp/pages/VerivicationPage.dart';
import 'package:stantapp/pages/WelcomePage.dart';
import 'package:stantapp/widget/BottomNavbar.dart';

import '../firebase_api.dart';

class AuthController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();
  RxBool isAuthenticated = false.obs;
  final String loggedInKey = 'loggedIn';
  final sessionController = Get.put(SessionController());

  var bottomNavIndex = 0; //default index of a first screen
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
        String email = response.data['user']['email'];
        String user_id = response.data['user']['user_id'];
        sessionController.setData(email, user_id);
        await prefs.setString('email', email);
        await prefs.setString('user_id', user_id);

        //cek apakah ada orang tua atau tidak
        await getOrangTua(user_id);
        // Set nilai variabel list dengan response data
        if (isParent.isEmpty) {
          var regionController = Get.put(RegionController());
          return Get.offAll(SetProfilePage(
              // province: regionController.provinces as List<dynamic>,
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

      if (response.data['success'] == true) {
        // Set isAuthenticated to true
        isAuthenticated.value = true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(loggedInKey, true);

        // Data ditemukan
        String email = response.data['user']['email'];
        String user_id = response.data['user']['user_id'];
        sessionController.setData(email, user_id);
        await prefs.setString('email', email);
        await prefs.setString('user_id', user_id);

        //cek apakah ada orang tua atau tidak
        await getOrangTua(user_id);
        // Set nilai variabel list dengan response data
        if (isParent.isEmpty) {
          var regionController = Get.put(RegionController());
          return Get.offAll(SetProfilePage(
              // province: regionController.provinces as List<dynamic>,
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

  Future<void> getOrangTua(
    String user_id,
  ) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'user_id': user_id,
      });
      final response = await _dio.post('$api/getOrangTua', data: formData);
      return isParent = response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<void> registerOrangtua(
    String? orang_tua_id,
    String user_id,
    String nama_orang_tua,
    String jenis_kelamin,
    String? kecamatan_id,
    String? kelurahan_id,
    String alamat,
    String pendidikan,
    String pekerjaan,
    String pendapatan,
    File? photo,
  ) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'user_id': user_id,
        'nama_orang_tua': nama_orang_tua,
        'jenis_kelamin': jenis_kelamin,
        'kecamatan_id': kecamatan_id,
        'kelurahan_id': kelurahan_id,
        'alamat': alamat,
        'pendidikan': pendidikan,
        'pekerjaan': pekerjaan,
        'pendapatan': pendapatan,
      });

      if (orang_tua_id != null) {
        formData.fields.add(MapEntry('orang_tua_id', orang_tua_id));
      }

      if (photo != null) {
        String fileName = photo.path.split('/').last;
        formData.files.add(MapEntry('photo',
            await dio.MultipartFile.fromFile(photo.path, filename: fileName)));
      }
      final response = await _dio.post('$api/registerOrangtua', data: formData);
      if (response.data['success'] == true) {
        Get.offAll(BottomNavbar());
      } else {
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

  Future<void> logout() async {
    sessionController.logout();

    // Set isAuthenticated to false
    isAuthenticated.value = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(loggedInKey, false);

    // Navigate to Login Page
    Get.offAll(WelcomePage());
  }

  Future<void> checkAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(loggedInKey) ?? false;
    isAuthenticated.value = isLoggedIn;
    String email = prefs.getString('email') ?? '';
    String user_id = prefs.getString('user_id') ?? '';
    sessionController.setData(email, user_id);
  }
}
