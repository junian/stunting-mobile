import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stantapp/controller/ParameterController.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({super.key});

  @override
  State<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  var parameterController = Get.put(ParameterController());

  bool isDataInitialized = false;
  String isParams = "";

  Future<void> initializeData() async {
    await Future.delayed(Duration(seconds: 2)); // Wait for 2 seconds
    await parameterController.getParameter("1");
    isParams = parameterController.parameterValue.toString();
    setState(() {
      isDataInitialized =
          true; // Set the data initialization status to true
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
            // Action when the back icon is pressed
            Get.back();
            // You can add Navigator.pop or another action here
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
                'terms_full_title'.tr.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'terms_last_updated'.tr,
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
