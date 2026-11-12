import 'package:flutter/material.dart';
import 'package:growthtracker/controller/AuthController.dart';
import 'package:growthtracker/controller/LanguageController.dart';
import 'package:growthtracker/controller/ParameterController.dart';
import 'package:growthtracker/pages/TermsOfServicePage.dart';
import 'package:growthtracker/pages/AboutPage.dart';
import 'package:get/get.dart';

class SettingUserPage extends StatefulWidget {
  const SettingUserPage({super.key});

  @override
  State<SettingUserPage> createState() => _SettingUserPageState();
}

class _SettingUserPageState extends State<SettingUserPage> {
  var parameterController = Get.put(ParameterController());
  var authController = Get.put(AuthController());
  var languageController = Get.find<LanguageController>();

  @override
  void initState() {
    super.initState();
    authController.isParent;
  }

  void _showLanguageSheet() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'language'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LanguageController.system,
                    LanguageController.english,
                    LanguageController.indonesian,
                  ]
                      .map(
                        (code) => ListTile(
                          title: Text(languageController.labelFor(code)),
                          trailing: languageController.preference.value == code
                              ? Icon(Icons.check, color: Colors.blue)
                              : null,
                          onTap: () {
                            languageController.setLanguage(code);
                            Get.back();
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var hight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Container(
          width: width,
          height: hight,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Card(
                    child: Container(
                      width: width,
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'language'.tr,
                              style: TextStyle(fontSize: 18),
                            ),
                            Row(
                              children: [
                                Obx(
                                  () => Text(
                                    languageController.currentLabel,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  onPressed: _showLanguageSheet,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: hight * 0.07,
                ),
                Card(
                  child: Container(
                    width: width,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'terms_conditions'.tr,
                                style: TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () {
                                  Get.to(TermsOfServicePage());
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'about_app'.tr,
                                style: TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () {
                                  parameterController.getParameter("1");
                                  Get.to(AboutPage());
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: hight * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    width: width,
                    child: Text(
                      'version'.tr,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
