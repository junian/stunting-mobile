import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:growthtracker/controller/AuthController.dart';
import 'package:growthtracker/helper/Branding.dart';
import 'package:growthtracker/pages/RegisterPage.dart';
import 'package:growthtracker/pages/SetProfilePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  var authController = Get.put(AuthController());

  bool agreeToTerms = false;
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Action when the back icon is pressed
            Get.back();
            // You can add Navigator.pop or another action here
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'login_with_email'.tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'email'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    // hintText: 'Masukkan alamat email Anda',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isClicked
                            ? const Color.fromARGB(255, 188, 180, 179)
                            : Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      isClicked = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      isClicked = false;
                    });
                  },
                ),
                SizedBox(height: height / 24),
                GestureDetector(
                  onTap: () {
                    // Action when the submit button is pressed
                    if (emailController.text.isEmpty) {
                      // Fluttertoast.showToast(
                      //   msg: 'Field Cant null',
                      //   toastLength: Toast.LENGTH_LONG,
                      //   gravity: ToastGravity.BOTTOM,
                      //   backgroundColor: Colors.black38,
                      //   textColor: Colors.white,
                      // );
                      print('Kosong');
                    } else {
                      authController.reqAuthCode(emailController.text, '');
                    }
                    // Get.to(
                    //   SetProfilePage(),
                    // );
                    // You can add logic or another action here
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 82, 163, 230),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'login'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 40,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Action performed when the "Register" text is pressed
                      Get.to(
                        RegisterPage(),
                      );
                      // For example, navigate to the registration page
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'no_account'.tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'register'.tr,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'need_help'.tr,
                    ),
                    Text(
                      kSupportEmail,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 82, 163, 230),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
