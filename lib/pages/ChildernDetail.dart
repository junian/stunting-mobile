import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stantapp/controller/AuthController.dart';
import 'package:stantapp/controller/ChildernController.dart';
import 'package:get/get.dart';
import 'package:stantapp/controller/SessionController.dart';
import 'package:stantapp/models/ChildernModel.dart';
import 'package:stantapp/pages/AddAccountChildern.dart';
import 'package:stantapp/pages/JadwalVaksinasiPage.dart';
import 'package:stantapp/pages/RiwayatPertumbuhan.dart';
import 'package:stantapp/pages/TambahPertumbuhanPage.dart';

class ChildernPage extends StatefulWidget {
  ChildernPage({super.key});

  @override
  State<ChildernPage> createState() => _ChildernPageState();
}

class _ChildernPageState extends State<ChildernPage> {
  var childernController = Get.put(ChildernController());
  var sessionController = Get.put(SessionController());
  bool isDataInitialized = false;
  String selectedAnak = ''; // Nilai anak yang dipilih

  List<dynamic> isChildern = [];

  Future<void> initializeData() async {
    await Future.delayed(Duration(seconds: 2)); // Menunggu selama 2 detik
    // await childernController.getAnakById(5.toString(), 5.toString());
    isChildern = jsonDecode(childernController.dataAnak.toString());

    setState(() {
      isDataInitialized =
          true; // Mengubah status inisialisasi data menjadi true
    });
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;

        return Container(
          padding: EdgeInsets.all(15.0),
          width: width,
          height: height * 0.4,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )),
          // child: DropdownButton<String>(
          //   isExpanded: true, // Mengatasi masalah overflow
          //   value: selectedAnak,
          //   items: childernController.anakList.map((anak) {
          //     return DropdownMenuItem<String>(
          //       value: anak['anak_id'],
          //       child: Text(anak['nama_anak']),
          //     );
          //   }).toList(),
          //   onChanged: (value) {
          //     setState(() {
          //       selectedAnak = value ?? '';
          //     });
          //   },
          // ),
          child: ListView.builder(
            itemCount: childernController.anakList.length,
            itemBuilder: (context, index) {
              var data = childernController.anakList[index];
              return ListTile(
                subtitle: Text(data['tanggal_lahir']),
                title: Text(data['nama_anak']),
                trailing: GestureDetector(
                  onTap: () {
                    if (selectedAnak.isNotEmpty) {
                      childernController.getAnakById(
                          sessionController.user_id.value, data['anak_id']);
                    }
                    Get.back(); // Menutup bottom sheet setelah aksi selesai
                    isDataInitialized = false;
                    initializeData();
                    selectedAnak = data['anak_id'];
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    decoration: BoxDecoration(
                      color: selectedAnak == data['anak_id']
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Choose',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    initializeData();
    super.initState();
    if (childernController.anakList.isNotEmpty) {
      selectedAnak = childernController.anakList[0]['anak_id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    // if (isDataInitialized) {
    // if (isChildern.isNotEmpty) {
    // print(isChildern[0]['nama_anak']);
    // }
    // }

    // Tanggal saat ini
    DateTime currentDate = DateTime.now();
    // Tanggal kelahiran
    DateTime birthDate =
        DateTime.parse(childernController.anakList[0]['tanggal_lahir']);
    // Hitung selisih bulan
    int diffMonths = (currentDate.year - birthDate.year) * 12 +
        currentDate.month -
        birthDate.month;
    // Hitung selisih tahun
    int diffYears = diffMonths ~/ 12;
    // Format hasil
    String formattedAge;
    if (diffYears > 0) {
      int remainingMonths = diffMonths % 12;
      formattedAge = '${diffYears} tahun ${remainingMonths} bulan';
    } else {
      formattedAge = '${diffMonths} bulan';
    }

    return isDataInitialized == true
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 100,
              title: isDataInitialized
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width:
                                  40, // Sesuaikan dengan radius pada CircleAvatar
                              height:
                                  40, // Sesuaikan dengan radius pada CircleAvatar
                              decoration: BoxDecoration(
                                shape: BoxShape
                                    .circle, // Membuat container berbentuk bulat
                                color: Colors
                                    .blue, // Ganti dengan warna latar belakang yang Anda inginkan
                              ),
                              child: isChildern[0]['photo'] != null
                                  ? ClipOval(
                                      child: Image.network(
                                        "https://stantapp.alalanusantara.com/" +
                                            isChildern[0]['photo'],
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                            ),
                            Container(
                              width: width * 0.5,
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: width * 0.4,
                                          child: Text(
                                            isChildern.isNotEmpty
                                                ? isChildern[0]['nama_anak']
                                                : '',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _showModalBottomSheet(context);
                                        },
                                        child: Container(
                                          child: Transform.rotate(
                                            angle: 270 * 3.1415926535 / 180,
                                            child: Icon(
                                              Icons.arrow_back_ios,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    child: Text(
                                      isChildern.isNotEmpty
                                          ? isChildern[0]['umur']
                                          : '',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                childernController.getAnakById(
                                    sessionController.user_id.value,
                                    isChildern[0]['anak_id']);
                                Get.to(
                                  AddAccountChildernPage(
                                    anak_id: isChildern[0]['anak_id'],
                                  ),
                                );
                              },
                              child: Container(
                                child: CircleAvatar(
                                  backgroundColor:
                                      const Color.fromARGB(255, 211, 209, 209),
                                  child: Icon(Icons.edit),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: width * 0.5,
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            'Buku Anak',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    )
                  : CircularProgressIndicator(),
            ),
            body: isDataInitialized
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                        ),
                        Container(
                          // color: Color.fromARGB(255, 255, 255, 255),
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(),
                              child: Center(
                                child: Column(
                                  children: [
                                    // Container(
                                    //   margin:
                                    //       EdgeInsets.only(top: height * 0.025),
                                    //   padding: EdgeInsets.symmetric(
                                    //       vertical: 5, horizontal: 12),
                                    //   height: height * 0.12,
                                    //   width: width * 0.90,
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.blueAccent,
                                    //     borderRadius: BorderRadius.circular(30),
                                    //   ),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       Container(
                                    //         child: Image.asset(
                                    //           fit: BoxFit.contain,
                                    //           height: height * 0.15,
                                    //           width: width * 0.15,
                                    //           'images/image_3.png',
                                    //         ),
                                    //       ),
                                    //       Container(
                                    //         child: Column(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.center,
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.start,
                                    //           children: [
                                    //             Container(
                                    //               child: Text(
                                    //                 'Panduan Kesehatan Anak',
                                    //                 style: TextStyle(
                                    //                   fontSize: 16,
                                    //                   fontWeight:
                                    //                       FontWeight.bold,
                                    //                   color: Colors.white,
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             Container(
                                    //               child: Text(
                                    //                 '0 - 3 Bulan',
                                    //                 style: TextStyle(
                                    //                   fontSize: 12,
                                    //                   color: Colors.white,
                                    //                 ),
                                    //               ),
                                    //             )
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       Container(
                                    //         child: CircleAvatar(
                                    //           radius: 15,
                                    //           child: Transform.rotate(
                                    //             angle: 270 * 3.1415926535 / 180,
                                    //             child: Icon(
                                    //               Icons.arrow_back_ios,
                                    //               size: 16,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: height * 0.01),
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Hasil Pertumbuhan',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(
                                                RiwayatpertumbuhanPage(
                                                  anak_id: isChildern[0]
                                                          ['anak_id']
                                                      .toString(),
                                                  tinggi_badan_ayah: isChildern[
                                                              0]
                                                          ['tinggi_badan_ayah']
                                                      .toString(),
                                                  tinggi_badan_ibu: isChildern[
                                                          0]['tinggi_badan_ibu']
                                                      .toString(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Lihat Semua',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height: height * 0.3,
                                          width: width * 0.9,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 238, 236, 236),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: height * 0.2,
                                                    width: width * 0.25,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 201, 242, 229),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: width * 0.25,
                                                          height:
                                                              height * 0.060,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(15),
                                                              topRight: Radius
                                                                  .circular(15),
                                                            ),
                                                            color: Colors
                                                                .greenAccent,
                                                          ),
                                                          child: Container(
                                                            child: Icon(
                                                              Icons
                                                                  .monitor_weight_outlined,
                                                              size: 35,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'Berat',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    '${isChildern[0]["berat_badan"]} ',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Kg',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: height * 0.2,
                                                    width: width * 0.25,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Color.fromARGB(
                                                          255, 240, 176, 176),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: width * 0.25,
                                                          height:
                                                              height * 0.060,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(15),
                                                              topRight: Radius
                                                                  .circular(15),
                                                            ),
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    236,
                                                                    122,
                                                                    122),
                                                          ),
                                                          child: Container(
                                                            child: Icon(
                                                              Icons
                                                                  .co_present_outlined,
                                                              size: 35,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'Tinggi',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    '${isChildern[0]["tinggi_badan"]} ',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Cm',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: height * 0.2,
                                                    width: width * 0.25,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Color.fromARGB(
                                                          255, 240, 176, 176),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: width * 0.25,
                                                          height:
                                                              height * 0.060,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(15),
                                                              topRight: Radius
                                                                  .circular(15),
                                                            ),
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    236,
                                                                    122,
                                                                    122),
                                                          ),
                                                          child: Container(
                                                            child: Icon(
                                                              Icons
                                                                  .child_care_outlined,
                                                              size: 35,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'L.Kepala',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    '${isChildern[0]["lingkar_kepala"]} ',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    'Cm',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Terakhir Update',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Text(
                                                    isChildern[0]
                                                        ['created_date'],
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: width * 0.9,
                                          height: height * 0.1,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 178, 180, 181),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: width * 0.50,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Update Pertumbuhan',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Text(
                                                      isChildern[0]
                                                          ['nama_anak'],
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(TambahPertummbuhanPage(anakID: isChildern[0]
                                                          ['anak_id']
                                                      .toString(), tinggiBadanAyah: isChildern[
                                                              0]
                                                          ['tinggi_badan_ayah']
                                                      .toString(), tinggiBadanIbu: isChildern[
                                                          0]['tinggi_badan_ibu']
                                                      .toString()));
                                                },
                                                child: Container(
                                                  width: width * 0.25,
                                                  height: height * 0.055,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                    border: Border.all(
                                                      color: Colors.blue,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Update',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: height * 0.02),
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Vaksinasi',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            'Lihat Detil',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.blue,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 12),
                                      height: height * 0.12,
                                      width: width * 0.90,
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Icon(
                                              Icons.medication_liquid_rounded,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    'Jadwal Vaksinasi',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                // Container(
                                                //   child: Text(
                                                //     '0 - 3 Bulan',
                                                //     style: TextStyle(
                                                //       fontSize: 12,
                                                //       color: Colors.white,
                                                //     ),
                                                //   ),
                                                // )
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(
                                                JadwalVaksinasiPage(
                                                  anak_id: childernController
                                                      .anakList[0]['anak_id'],
                                                ),
                                              );
                                            },
                                            child: Container(
                                              child: CircleAvatar(
                                                radius: 15,
                                                child: Transform.rotate(
                                                  angle:
                                                      270 * 3.1415926535 / 90,
                                                  child: Icon(
                                                    Icons.arrow_back_ios,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: height * 0.02),
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Riwayat Pertumbuhan',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            'Lihat Detil',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.blue,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 12),
                                      height: height * 0.12,
                                      width: width * 0.90,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Icon(
                                              Icons.history_edu_outlined,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    'Riwayat Pertumbuhan Anak',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                // Container(
                                                //   child: Text(
                                                //     '0 - 3 Bulan',
                                                //     style: TextStyle(
                                                //       fontSize: 12,
                                                //       color: Colors.white,
                                                //     ),
                                                //   ),
                                                // )
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              print(isChildern[0]);
                                              Get.to(
                                                RiwayatpertumbuhanPage(
                                                  anak_id: isChildern[0]
                                                          ['anak_id']
                                                      .toString(),
                                                  tinggi_badan_ayah: isChildern[
                                                              0]
                                                          ['tinggi_badan_ayah']
                                                      .toString(),
                                                  tinggi_badan_ibu: isChildern[
                                                          0]['tinggi_badan_ibu']
                                                      .toString(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              child: CircleAvatar(
                                                radius: 15,
                                                child: Transform.rotate(
                                                  angle:
                                                      270 * 3.1415926535 / 90,
                                                  child: Icon(
                                                    Icons.arrow_back_ios,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.05,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
