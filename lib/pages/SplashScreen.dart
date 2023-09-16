import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stantapp/pages/LoginPage.dart';
import 'package:stantapp/controller/AuthController.dart';
import 'package:stantapp/pages/WelcomePage.dart';
import 'package:stantapp/widget/BottomNavbar.dart';

import 'HomePage.dart';

class SplashScreen extends StatelessWidget {
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    authController.checkAuthentication();

    // Delay splash screen for 2 seconds
    Future.delayed(
      Duration(seconds: 2),
      () {
        if (authController.isAuthenticated.value) {
          Get.offAll((BottomNavbar()));
        } else {
          Get.offAll(WelcomePage());
        }
      },
    );

    return Scaffold(
        body: Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image(
                  image: AssetImage("images/logo.png"),
                  height: 200,
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 50),
              alignment: Alignment.bottomCenter,
              child: Text("Version 1.0.0"),
            ),
          ],
        ),
      ],
    ));
  }
}
