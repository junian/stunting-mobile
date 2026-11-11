import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthtracker/pages/LoginPage.dart';
import 'package:growthtracker/controller/AuthController.dart';
import 'package:growthtracker/widget/BottomNavbar.dart';

import 'HomePage.dart';

class SplashScreenPage extends StatelessWidget {
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    authController.checkAuthentication();

    // Delay splash screen for 2 seconds, then go straight to the main page:
    // an account is not required to use the app.
    Future.delayed(
      Duration(seconds: 2),
      () {
        Get.offAll(BottomNavbar());
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
              child: Text("version".tr),
            ),
          ],
        ),
      ],
    ));
  }
}
