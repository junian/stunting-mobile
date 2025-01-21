import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stantapp/controller/AuthController.dart';
import 'package:stantapp/pages/SnkPage.dart';
import 'package:stantapp/pages/VerivicationPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController phone_noController = TextEditingController();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daftar Akun',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Nomor HP',
                    style: TextStyle(),
                  ),
                  Text(
                    '*',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: phone_noController,
                decoration: InputDecoration(
                  hintText: 'Masukkan Nomor HP Anda',
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
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Email',
                    style: TextStyle(),
                  ),
                  Text(
                    '*',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Masukkan alamat email Anda',
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
              SizedBox(height: height * 0.13),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        agreeToTerms = value ?? false;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        // Tindakan yang dijalankan ketika tautan teks "Syarat dan Ketentuan" ditekan
                        // Misalnya, tampilkan dialog dengan informasi syarat dan ketentuan
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Saya telah membaca dan menyetujui ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Syarat & Ketentuan',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Tindakan yang dijalankan ketika tautan teks "Syarat dan Ketentuan" ditekan
                                  Get.to(
                                    SnkPage(),
                                  );
                                  // Misalnya, tampilkan dialog dengan informasi syarat dan ketentuan
                                },
                            ),
                            TextSpan(text: ' dari Tim STANTAPP.'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 80),
              GestureDetector(
                onTap: () {
                  // Aksi ketika tombol submit ditekan
                  if (emailController.text.isNotEmpty &&
                      phone_noController.text.isNotEmpty &&
                      agreeToTerms == true) {
                    authController.reqAuthCode(
                        emailController.text, phone_noController.text);
                  } else {
                    Get.snackbar("Warning",
                        "Cek Kembali field yang kosong atau anda belum menerima syarat dan ketentuan");
                  }
                  // Anda dapat menambahkan logika atau tindakan lain di sini
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: agreeToTerms == true
                        ? Colors.blueAccent
                        : Color.fromARGB(255, 226, 226, 226),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Daftar',
                      style: TextStyle(
                        color: agreeToTerms == true
                            ? Colors.white
                            : const Color.fromARGB(255, 45, 45, 45),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
