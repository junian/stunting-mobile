import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:growthtracker/controller/GrowthEditorController.dart';

class GrowthDetailPage extends StatelessWidget {
  String pertumbuhanAnakId;
  String anakId;
  String beratBadan;
  String tinggiBadan;
  String lingkarKepala;
  String createdDate;
  String statusPertumbuhanBerat;
  String statusPertumbuhanTinggi;
  String statusPertumbuhanLingkarKepala;
  String umur;
  GrowthDetailPage(
      {super.key,
      required this.pertumbuhanAnakId,
      required this.anakId,
      required this.beratBadan,
      required this.tinggiBadan,
      required this.lingkarKepala,
      required this.createdDate,
      required this.statusPertumbuhanBerat,
      required this.statusPertumbuhanTinggi,
      required this.statusPertumbuhanLingkarKepala,
      required this.umur});

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('d MMM y');
    String tglbuat = dateFormat.format(DateTime.parse(createdDate));

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('growth_detail'.tr),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text('delete'.tr),
                  content: Text('delete_growth_message'.tr),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: Text('cancel'.tr),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: Text('delete'.tr),
                    ),
                  ],
                ),
              );

              if (confirmed != true) return;

              await GrowthEditorController()
                  .deletePertumbuhanAnak(pertumbuhanAnakId);
              Get.back();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "growth_date_label".tr,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(tglbuat,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text(
                  "child_age_label".tr,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(umur,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text(
                  "weight_label".tr,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text("${beratBadan.toString()} kg",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text(
                  "height_label".tr,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text("${tinggiBadan.toString()} cm",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text(
                  "head_label".tr,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text("${lingkarKepala.toString()} cm",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: width,
                height: height * 0.2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "growth_status_weight".tr,
                          style: TextStyle(
                            fontSize: 18,
                          )),
                      Text(statusPertumbuhanBerat,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: statusPertumbuhanBerat == "Normal"
                                  ? Colors.green
                                  : Colors.yellow)),
                      Text(
                          statusPertumbuhanBerat == "Normal"
                              ? "keep_healthy_note".tr
                              : "consult_note".tr,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: width,
                height: height * 0.2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "growth_status_height".tr,
                          style: TextStyle(
                            fontSize: 18,
                          )),
                      Text(statusPertumbuhanTinggi,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: statusPertumbuhanBerat == "Normal"
                                  ? Colors.green
                                  : Colors.yellow)),
                      Text(
                          statusPertumbuhanBerat == "Normal"
                              ? "keep_healthy_note".tr
                              : "consult_note".tr,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: width,
                height: height * 0.2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "growth_status_head".tr,
                          style: TextStyle(
                            fontSize: 18,
                          )),
                      Text(statusPertumbuhanLingkarKepala,
                          // isLebarKepalaNormal(lebarKepala)
                          //     ? "Normal"
                          //     : "Tidak Normal",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: statusPertumbuhanBerat == "Normal"
                                  ? Colors.green
                                  : Colors.yellow)),
                      Text(
                          statusPertumbuhanBerat == "Normal"
                              ? "keep_healthy_note".tr
                              : "consult_note".tr,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
