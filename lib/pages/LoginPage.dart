import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:stantapp/controller/AuthController.dart';
import 'package:stantapp/pages/RegisterPage.dart';
import 'package:stantapp/pages/SetProfilePage.dart';

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
            // Aksi ketika ikon kembali ditekan
            Get.back();
            // Anda dapat menambahkan Navigator.pop atau tindakan lain di sini
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
                  'Masuk Dengan Email',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Email',
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
                    // Aksi ketika tombol submit ditekan
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
                    // Anda dapat menambahkan logika atau tindakan lain di sini
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
                        'Masuk',
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
                      // Tindakan yang dijalankan ketika teks "Daftar" ditekan
                      Get.to(
                        RegisterPage(),
                      );
                      // Misalnya, pindah ke halaman pendaftaran
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Belum memiliki akun? ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Daftar',
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
                      'Butuh Bantuan ?',
                    ),
                    Text(
                      'WhatsApp 0817-7070-4114',
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
