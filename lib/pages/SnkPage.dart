import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stantapp/controller/ParameterController.dart';

class SnkPage extends StatefulWidget {
  const SnkPage({super.key});

  @override
  State<SnkPage> createState() => _SnkPageState();
}

class _SnkPageState extends State<SnkPage> {
  var parameterController = Get.put(ParameterController());

  bool isDataInitialized = false;
  String isParams = "";

  Future<void> initializeData() async {
    await Future.delayed(Duration(seconds: 2)); // Menunggu selama 2 detik
    await parameterController.getParameter("1");
    isParams = parameterController.parameterValue.toString();

    setState(() {
      isDataInitialized =
          true; // Mengubah status inisialisasi data menjadi true
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Syarat dan Ketentuan penggunaan primaku'.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Perbaruan Terakhir : 1/12/2022',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              isDataInitialized == true
                  ? Text(
                      isParams,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
