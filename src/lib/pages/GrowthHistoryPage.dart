import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:growthtracker/controller/GrowthDetailController.dart';
import '../controller/GrowthHistoryController.dart';
import '../controller/GrowthEditorController.dart';
import 'GrowthDetailPage.dart';
import 'GrowthEditorPage.dart';
import 'package:growthtracker/widget/AppPhoto.dart';

class GrowthHistoryPage extends StatefulWidget {
  String anak_id;
  String tinggi_badan_ibu;
  String tinggi_badan_ayah;
  GrowthHistoryPage(
      {Key? key,
      required this.anak_id,
      required this.tinggi_badan_ayah,
      required this.tinggi_badan_ibu})
      : super(key: key);

  @override
  State<GrowthHistoryPage> createState() => _GrowthHistoryPageState();
}

class _GrowthHistoryPageState extends State<GrowthHistoryPage> {
  bool isAscending = false;
  bool isDataInitialized = false;
  var riwayatPertumbuhanController = Get.put(GrowthHistoryController());
  var tambahPertumbuhanAnak = Get.put(GrowthEditorController());
  var detailRiwayatPertumbuhanController =
      Get.put(GrowthDetailController());

  List<Map<String, dynamic>> filteredList = [];

  Future<void> initializeData() async {
    await Future.delayed(Duration(seconds: 2)); // Wait for 2 seconds
    await riwayatPertumbuhanController.getPertumbuhanAnak(widget.anak_id);
    filteredList = riwayatPertumbuhanController.riwayatPertumbuhan.toList();
    setState(() {
      isDataInitialized =
          true; // Set the data initialization status to true
    });
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void filterData(bool ascending) {
    setState(() {
      isAscending = ascending;

      filteredList = riwayatPertumbuhanController.riwayatPertumbuhan.toList();

      filteredList.sort((a, b) {
        // Compare values by creation date (created_date)
        DateTime dateA = DateTime.parse(a['created_date']);
        DateTime dateB = DateTime.parse(b['created_date']);

        if (isAscending) {
          return dateA.compareTo(dateB); // Urutan ascending
        } else {
          return dateB.compareTo(dateA); // Urutan descending
        }
      });
    });
  }

  Future<void> _refreshData() async {
    // Simulate the data refresh process (e.g. fetching new data from the server)
    riwayatPertumbuhanController.getPertumbuhanAnak(widget.anak_id);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      filteredList = riwayatPertumbuhanController.riwayatPertumbuhan.toList();
    });
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('growth_history'.tr),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          riwayatPertumbuhanController.getPertumbuhanAnak(widget.anak_id);

          riwayatPertumbuhanController.riwayatPertumbuhan;

          Get.to(GrowthEditorPage(
              anakID: widget.anak_id,
              tinggiBadanAyah: widget.tinggi_badan_ayah,
              tinggiBadanIbu: widget.tinggi_badan_ibu))?.then(
            (_) => _refreshData(),
          );
        },
        child: Container(
            alignment: Alignment.center,
            width: width * 0.9,
            height: height * 0.07,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              shape: BoxShape.rectangle,
              color: Colors.blue,
            ),
            child: Text(
              "add_growth".tr,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownButtonHideUnderline(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(),
                    ),
                    child: DropdownButton<bool>(
                      value: isAscending,
                      onChanged: (bool? newValue) {
                        if (newValue != null) {
                          filterData(newValue);
                        }
                      },
                      items: [
                        DropdownMenuItem<bool>(
                          value: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'latest'.tr,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        DropdownMenuItem<bool>(
                          value: false,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'newest'.tr,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Container(
              width: width,
              height: height * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 20,
                    width: 20,
                  ),
                  Text(
                    "weight".tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("height".tr,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("head_circumference".tr,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    height: 20,
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: height * 0.6,
            width: width,
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: isDataInitialized == true
                  ? ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = filteredList[index];
                        DateFormat dateFormat = DateFormat('d MMM y');
                        String tglbuat = dateFormat
                            .format(DateTime.parse(data['created_date']));

                        // String formatSelisihTanggal(
                        //     DateTime startDate, DateTime endDate) {
                        //   Duration selisih = endDate.difference(startDate);
                        //   int tahun = selisih.inDays ~/ 365;
                        //   int bulan = (selisih.inDays % 365) ~/ 30;
                        //   int hari = selisih.inDays % 30;

                        //   String hasil = '';
                        //   if (tahun > 0) {
                        //     hasil += '$tahun tahun ';
                        //   }
                        //   if (bulan > 0) {
                        //     hasil += '$bulan bulan ';
                        //   }
                        //   if (hari > 0) {
                        //     hasil += '$hari hari';
                        //   }

                        //   return hasil.trim();
                        // }

                        // var selisih =
                        //     formatSelisihTanggal(data.tanggalLahir, data.createDate);

                        return Container(
                          width: width,
                          height: height * 0.18,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  width: width,
                                  height: height * 0.08,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          detailRiwayatPertumbuhanController
                                              .getDetailPertumbuhan(
                                                  data['pertumbuhan_anak_id'],
                                                  data['umur'])
                                              .then((_) => _refreshData());
                                        },
                                        child: data['photo'] != null
                                            ? Container(
                                                height: height * 0.03,
                                                width: width * 0.06,
                                                child: AppPhoto(
                                                  data['photo'],
                                                  fit: BoxFit.contain,
                                                ),
                                                // child: Icon(
                                                //   Icons.image,
                                                //   color: Colors.grey,
                                                // ),
                                              )
                                            : Container(
                                                height: height * 0.03,
                                                width: width * 0.06,
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                      ),
                                      Text("${data['berat_badan']} kg"),
                                      Text("${data['tinggi_badan']} cm"),
                                      Text("${data['lingkar_kepala']} cm"),
                                      GestureDetector(
                                        onTap: () {
                                          detailRiwayatPertumbuhanController
                                              .getDetailPertumbuhan(
                                                  data['pertumbuhan_anak_id'],
                                                  data['umur'])
                                              .then((_) => _refreshData());
                                        },
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 2,
                                  left: 16,
                                  right: 16,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20))),
                                  width: width,
                                  height: height * 0.08,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        tglbuat,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(data['umur'],
                                          style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
