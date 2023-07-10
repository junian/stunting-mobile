import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:get/get.dart';
import 'package:stantapp/controller/AuthController.dart';
import 'package:stantapp/controller/ChildernController.dart';
import 'package:stantapp/controller/RegionController.dart';
import 'package:stantapp/helper/CountdownTimer.dart';
import 'package:stantapp/pages/SetProfilePage.dart';

class VerivicationPage extends StatefulWidget {
  String email;
  String phone_no;
  String authCode;
  VerivicationPage({
    super.key,
    required this.email,
    required this.phone_no,
    required this.authCode,
  });

  @override
  State<VerivicationPage> createState() => _VerivicationPageState();
}

class _VerivicationPageState extends State<VerivicationPage> {
  var authController = Get.put(AuthController());
  var regionController = Get.put(RegionController());
  var childernController = Get.put(ChildernController());

  bool _onEditing = true;
  String? _code;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    print(widget.email);

    return Scaffold(
      appBar: AppBar(
        title: Text('Verifikasi'),
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
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: [
                Text(
                  'Masukkan Code Verifikasi yang telah dikirim Ke Email Anda. Silahkan cek!',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kode Verifikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: height / 80,
                    ),
                    VerificationCode(
                      fullBorder: true,
                      textStyle: TextStyle(
                          fontSize: 20.0, color: Color.fromARGB(255, 0, 0, 0)),
                      keyboardType: TextInputType.number,
                      underlineColor: Colors.blueAccent,
                      length: 6,
                      cursorColor: Colors
                          .blue, // If this is null it will default to the ambient
                      // clearAll is NOT required, you can delete it
                      // takes any widget, so you can implement your design
                      // clearAll: Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(
                      //     'clear all',
                      //     style: TextStyle(
                      //         fontSize: 14.0,
                      //         decoration: TextDecoration.underline,
                      //         color: Colors.blue[700]),
                      //   ),
                      // ),
                      onCompleted: (String value) {
                        setState(() {
                          _code = value;
                        });
                      },
                      onEditing: (bool value) {
                        setState(() {
                          _onEditing = value;
                        });
                        if (!_onEditing) FocusScope.of(context).unfocus();
                      },
                    ),
                    SizedBox(
                      height: height / 80,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Tidak Menerima Kode Verifikasi? ',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        CountdownTimer(
                          email: widget.email,
                          phone_no: widget.phone_no,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          // Tindakan yang dijalankan ketika GestureDetector ditekan
          regionController.getProvince();
          if (widget.phone_no.isNotEmpty) {
            authController.register(
                widget.email, widget.phone_no, _code.toString());
          } else {
            childernController.getAnak(5.toString(), null);
            authController.login(widget.email, _code.toString());
          }
          // Get.to(SetProfilePage());
        },
        child: Container(
            alignment: Alignment.center,
            width: width * 0.9,
            height: height / 18,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 219, 215, 215),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Verifikasi",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
