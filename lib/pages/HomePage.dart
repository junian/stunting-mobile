import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stantapp/controller/ArtikelController.dart';
import 'package:stantapp/controller/AuthController.dart';
import 'package:stantapp/controller/ChildernController.dart';
import 'package:stantapp/controller/NotificationController.dart';
import 'package:stantapp/controller/RiwayatPertumbuhanController.dart';
import 'package:stantapp/controller/SessionController.dart';
import 'package:stantapp/pages/AddAccountChildern.dart';
import 'package:get/get.dart';
import 'package:stantapp/pages/ArtikelDetailPage.dart';
import 'package:stantapp/pages/ArtikelPage.dart';
import 'package:stantapp/pages/ChildernDetail.dart';
import 'package:stantapp/pages/NotificationPage.dart';
import 'package:stantapp/pages/SetProfilePage.dart';
import 'package:stantapp/widget/BottomNavbar.dart';
import '../firebase_api.dart';

import '../controller/FirebaseController.dart';
import '../models/MGetArtikel.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authController = Get.put(AuthController());
  final childernController = Get.put(ChildernController());
  final sessionController = Get.put(SessionController());
  final artikelController = Get.put(ArtikelController());
  final firebaseController = Get.put(FirebaseController());

  bool isDataInitialized = false;
  List<MGetArtikel> filteredList = [];

  String fireBaseToken = '';

  Future<void> initializeData() async {
    await Future.delayed(Duration(seconds: 2));
    await artikelController.getArtikel();
    await childernController.getAnak(sessionController.user_id.value, null);
    await authController.getOrangTua(sessionController.user_id.toString());
    await FirebaseApi().initNotifications();
    await firebaseController.updateFirebaseToken();

    filteredList = artikelController.artikel.toList();
    setState(() {
      isDataInitialized =
          true; // Mengubah status inisialisasi data menjadi true
    });
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    int dataLength = 0; // Ganti dengan panjang data aktual Anda

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: isDataInitialized == true
          ? Container(
              child: Stack(
                children: [
                  Container(
                    width: width,
                    height: height * 0.37,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Colors.blueAccent,
                    ),
                  ),
                  Obx(
                    () {
                      if (childernController.anakList.value == null ||
                          childernController.anakList.value.isEmpty) {
                        return MyContainer.buildContainer(context);
                      } else if (childernController.anakList.value != null) {
                        return MyContainer2.buildContainer(context);
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       top: 60, bottom: 50, left: 15, right: 15),
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Container(
                  //             width: width * 0.5,
                  //             child: Expanded(
                  //               child: Text(
                  //                 'Hai, Muhammad Haris',
                  //                 maxLines: 2,
                  //                 overflow: TextOverflow.ellipsis,
                  //                 style: TextStyle(
                  //                   fontSize: 18,
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           Row(
                  //             children: [
                  //               GestureDetector(
                  //                 onTap: () {
                  //                   // Aksi yang akan dijalankan ketika ikon lonceng notifikasi ditekan
                  //                   // Misalnya, tampilkan notifikasi atau navigasikan ke halaman notifikasi
                  //                 },
                  //                 child: CircleAvatar(
                  //                   radius: 20, // Radius lingkaran
                  //                   backgroundColor: Colors.white,
                  //                   child: Icon(
                  //                     Icons.notifications,
                  //                     size: 30,
                  //                     color: Colors.black,
                  //                   ),
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 width: 10,
                  //               ),
                  //               GestureDetector(
                  //                 onTap: () {
                  //                   // Aksi yang akan dijalankan ketika ikon lonceng notifikasi ditekan
                  //                   // Misalnya, tampilkan notifikasi atau navigasikan ke halaman notifikasi
                  //                 },
                  //                 child: CircleAvatar(
                  //                   radius: 20, // Radius lingkaran
                  //                   backgroundColor: Colors.white,
                  //                   child: Icon(
                  //                     Icons.person,
                  //                     size: 30,
                  //                     color: Colors.black,
                  //                   ),
                  //                 ),
                  //               )
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         height: height * 0.06,
                  //       ),
                  //       Container(
                  //         width: width * 0.8,
                  //         height: height * 0.25,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(40),
                  //           color: Colors.white,
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Colors.grey.withOpacity(0.5),
                  //               spreadRadius: 1,
                  //               blurRadius: 10,
                  //               offset: Offset(0, 2), // Menggeser bayangan ke bawah
                  //             ),
                  //           ],
                  //         ),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Image.asset(
                  //               'images/image_0.png',
                  //               width: width * 0.7,
                  //               height: height * 0.1,
                  //             ),
                  //             SizedBox(height: 16),
                  //             Text(
                  //               'Saat ini Anda belum Mempunyai Profil anak',
                  //               style: TextStyle(
                  //                 fontSize: 12,
                  //               ),
                  //             ),
                  //             SizedBox(height: 16),
                  //             GestureDetector(
                  //               onTap: () {
                  //                 // Aksi yang akan dijalankan ketika tombol ditekan
                  //                 Get.to(
                  //                   AddAccountChildernPage(),
                  //                 );
                  //               },
                  //               child: Container(
                  //                 padding: EdgeInsets.symmetric(
                  //                     vertical: 10, horizontal: 30),
                  //                 decoration: BoxDecoration(
                  //                   color: Colors.blue,
                  //                   borderRadius: BorderRadius.circular(20),
                  //                 ),
                  //                 child: Row(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     Icon(
                  //                       Icons.add,
                  //                       color: Colors.white,
                  //                     ),
                  //                     SizedBox(width: 8),
                  //                     Text(
                  //                       'Tambah',
                  //                       style: TextStyle(
                  //                         color: Colors.white,
                  //                         fontWeight: FontWeight.bold,
                  //                         fontSize: 16,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: width,
                        height: height * 0.37,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 187, 234, 240),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 12, right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rekomendasi Artikel',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     setState(() {
                                  //       authController.bottomNavIndex = 1;
                                  //     });
                                  //     Future.delayed(
                                  //         Duration(milliseconds: 500), () {
                                  //       // Navigasi ke halaman BottomNavbar menggunakan Get.to()
                                  //       Get.to(BottomNavbar());
                                  //     });
                                  //   },
                                  //   child: Text(
                                  //     'Lihat Semua',
                                  //     style: TextStyle(
                                  //       color: Colors.blue,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Container(
                                height: height * 0.3,
                                child: isDataInitialized == true
                                    ? ListView.builder(
                                        itemCount: filteredList.length > 5
                                            ? 5
                                            : filteredList.length,
                                        itemBuilder: (context, index) {
                                          MGetArtikel artikel =
                                              filteredList[index];
                                          DateFormat dateFormat =
                                              DateFormat('d MMM y');
                                          String tglbuat = dateFormat.format(
                                              DateTime.parse(
                                                  artikel.createdDate));
                                          return Container(
                                            width: width * 0.5,
                                            child: Card(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: width * 0.5,
                                                    height: height * 0.12,
                                                    child: artikel.thumbnail ==
                                                            null
                                                        ? Image.asset(
                                                            'images/logo.png',
                                                            fit: BoxFit.contain,
                                                          )
                                                        : Image.network(
                                                            "https://stantapp.alalanusantara.com/" +
                                                                artikel
                                                                    .thumbnail
                                                                    .toString(),
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 148, 184, 245),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            artikel
                                                                .namaKategori,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.to(
                                                        ArtikelDetailPage(
                                                          category: artikel
                                                              .namaKategori,
                                                          title: artikel.judul,
                                                          author:
                                                              artikel.fullname,
                                                          date: tglbuat,
                                                          description:
                                                              artikel.konten,
                                                          imageUrl:
                                                              "https://stantapp.alalanusantara.com" +
                                                                  artikel
                                                                      .thumbnail
                                                                      .toString(),
                                                        ),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8,
                                                              right: 8),
                                                      child: Text(
                                                        artikel.judul,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8, right: 8),
                                                    child: Text(
                                                      tglbuat,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        scrollDirection: Axis.horizontal,
                                        // children: [
                                        //   Container(
                                        //     width: 200,
                                        //     child: Card(
                                        //       child: Column(
                                        //         crossAxisAlignment:
                                        //             CrossAxisAlignment.start,
                                        //         children: [
                                        //           Container(
                                        //             width: 200,
                                        //             height: 110,
                                        //             child: Image.asset(
                                        //               'images/image_0.png',
                                        //               fit: BoxFit.cover,
                                        //             ),
                                        //           ),
                                        //           Padding(
                                        //             padding: const EdgeInsets.all(8.0),
                                        //             child: Container(
                                        //               padding: EdgeInsets.all(10),
                                        //               decoration: BoxDecoration(
                                        //                 color: const Color.fromARGB(
                                        //                     255, 148, 184, 245),
                                        //                 borderRadius:
                                        //                     BorderRadius.circular(8),
                                        //               ),
                                        //               child: Column(
                                        //                 crossAxisAlignment:
                                        //                     CrossAxisAlignment.start,
                                        //                 children: [
                                        //                   Text(
                                        //                     'Kategori',
                                        //                     style: TextStyle(
                                        //                       fontWeight: FontWeight.bold,
                                        //                       fontSize: 10,
                                        //                     ),
                                        //                   ),
                                        //                 ],
                                        //               ),
                                        //             ),
                                        //           ),
                                        //           SizedBox(height: 4),
                                        //           Padding(
                                        //             padding: const EdgeInsets.only(
                                        //                 left: 8, right: 8),
                                        //             child: Text(
                                        //               'Alat Masak yang Perlu di Siapkan Untuk MPASI',
                                        //               maxLines: 2,
                                        //               overflow: TextOverflow.ellipsis,
                                        //               style: TextStyle(
                                        //                 fontWeight: FontWeight.bold,
                                        //                 fontSize: 13,
                                        //               ),
                                        //             ),
                                        //           ),
                                        //           SizedBox(height: 4),
                                        //           Padding(
                                        //             padding: const EdgeInsets.only(
                                        //                 left: 8, right: 8),
                                        //             child: Text(
                                        //               '21 Jun 2023',
                                        //               style: TextStyle(
                                        //                 fontSize: 14,
                                        //                 color: Colors.grey,
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
                                        //   Container(
                                        //     width: 200,
                                        //     child: Card(
                                        //       child: Column(
                                        //         crossAxisAlignment:
                                        //             CrossAxisAlignment.start,
                                        //         children: [
                                        //           Container(
                                        //             width: 200,
                                        //             height: 110,
                                        //             child: Image.asset(
                                        //               'images/image_1.png',
                                        //               fit: BoxFit.cover,
                                        //             ),
                                        //           ),
                                        //           Padding(
                                        //             padding: const EdgeInsets.all(8.0),
                                        //             child: Container(
                                        //               padding: EdgeInsets.all(10),
                                        //               decoration: BoxDecoration(
                                        //                 color: const Color.fromARGB(
                                        //                     255, 148, 184, 245),
                                        //                 borderRadius:
                                        //                     BorderRadius.circular(8),
                                        //               ),
                                        //               child: Column(
                                        //                 crossAxisAlignment:
                                        //                     CrossAxisAlignment.start,
                                        //                 children: [
                                        //                   Text(
                                        //                     'Kategori',
                                        //                     style: TextStyle(
                                        //                       fontWeight: FontWeight.bold,
                                        //                       fontSize: 10,
                                        //                     ),
                                        //                   ),
                                        //                 ],
                                        //               ),
                                        //             ),
                                        //           ),
                                        //           SizedBox(height: 4),
                                        //           Padding(
                                        //             padding: const EdgeInsets.only(
                                        //                 left: 8, right: 8),
                                        //             child: Text(
                                        //               'Alat Masak yang Perlu di Siapkan Untuk MPASI di kota Bekasi',
                                        //               maxLines: 2,
                                        //               overflow: TextOverflow.ellipsis,
                                        //               style: TextStyle(
                                        //                 fontWeight: FontWeight.bold,
                                        //                 fontSize: 13,
                                        //               ),
                                        //             ),
                                        //           ),
                                        //           SizedBox(height: 4),
                                        //           Padding(
                                        //             padding: const EdgeInsets.only(
                                        //                 left: 8, right: 8),
                                        //             child: Text(
                                        //               '21 Jun 2023',
                                        //               style: TextStyle(
                                        //                 fontSize: 14,
                                        //                 color: Colors.grey,
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ],
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class MyContainer {
  static Widget buildContainer(BuildContext context) {
    var authController = Get.put(AuthController());
    var sessionController = Get.put(SessionController());
    var notificationController = Get.put(NotificationController());
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 60, bottom: 50, left: 15, right: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 0.5,
                  child: Text(
                    'Hai, ${authController.isParent[0]["nama_orang_tua"]}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        notificationController.getNotifikasi(sessionController.user_id.toString());
                        Get.to(NotificationPage());
                      },
                      child: CircleAvatar(
                        radius: 20, // Radius lingkaran
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.notifications,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(SetProfilePage());
                      },
                      child: CircleAvatar(
                        radius: 20, // Radius lingkaran
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height * 0.06,
            ),
            Container(
              width: width * 0.8,
              height: height * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 2), // Menggeser bayangan ke bawah
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/image_0.png',
                    width: width * 0.7,
                    height: height * 0.1,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Saat ini Anda belum Mempunyai Profil anak',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      // Aksi yang akan dijalankan ketika tombol ditekan
                      Get.to(
                        AddAccountChildernPage(
                          anak_id: null,
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Tambah',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyContainer2 {
  static Widget buildContainer(BuildContext context) {
    final childernController = Get.put(ChildernController());
    final sessionController = Get.put(SessionController());
    final authController = Get.put(AuthController());
    final riwayatPertumbuhanController = Get.put(RiwayatPertumbuhanController());
    final notificationController = Get.put(NotificationController());
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Tanggal saat ini
    DateTime currentDate = DateTime.now();
// Tanggal kelahiran
    DateTime birthDate =
        DateTime.parse(childernController.anakList[0]['tanggal_lahir']);
// Hitung selisih antara tanggal saat ini dan tanggal kelahiran
    Duration ageDifference = currentDate.difference(birthDate);

// Hitung tahun, bulan, dan hari dari selisih yang dihitung
    int years = ageDifference.inDays ~/ 365;
    int remainingMonths = (ageDifference.inDays % 365) ~/ 30;
    int remainingDays = ageDifference.inDays % 30;

// Format hasil
    String formattedAge = '';
    if (years > 0) {
      formattedAge += '${years} tahun ';
    }
    if (remainingMonths > 0) {
      formattedAge += '${remainingMonths} bulan ';
    }
    if (remainingDays > 0) {
      formattedAge += '${remainingDays} hari';
    }

    return Container(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 60, bottom: 50, left: 15, right: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width * 0.5,
                      child: Text(
                        'Hai, ${authController.isParent[0]["nama_orang_tua"]}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: Row(
                          children: [
                            Text(
                              'Naikan Level Membership ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        notificationController.getNotifikasi(sessionController.user_id.toString());
                        Get.to(NotificationPage());
                      },
                      child: CircleAvatar(
                        radius: 20, // Radius lingkaran
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.notifications,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        authController.getOrangTua(
                          sessionController.user_id.toString(),
                        );
                        Get.to(SetProfilePage());
                      },
                      child: CircleAvatar(
                        radius: 20, // Radius lingkaran
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height * 0.06,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profil Anak',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width * 0.56,
                      height: height * 0.22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color.fromARGB(255, 170, 204, 232)
                                .withOpacity(1.0),
                            const Color.fromARGB(255, 170, 204, 232)
                                .withOpacity(1.0),
                            Colors.white.withOpacity(1.0),
                            Colors.white.withOpacity(1.0),
                          ],
                          stops: [0.0, 0.3, 0.3, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 2), // Menggeser bayangan ke bawah
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  child: childernController.anakList[0]
                                              ['photo'] !=
                                          null
                                      ? ClipOval(
                                          child: Image.network(
                                            "https://stantapp.alalanusantara.com/" +
                                                childernController.anakList[0]
                                                    ['photo'],
                                            width: 70,
                                            height: 70,
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
                                  width: width * 0.30,
                                  child: Text(
                                    childernController.anakList[0]['nama_anak'],
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width * 0.30,
                                  child: Text(
                                    formattedAge,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: width * 0.12,
                            ),
                            GestureDetector(
                              onTap: () {
                                riwayatPertumbuhanController.getPertumbuhanAnak(childernController.anakList[0]['anak_id']);
                                childernController.getAnakById(
                                    sessionController.user_id.value,
                                    childernController.anakList[0]['anak_id']);
                                Get.to(
                                  ChildernPage(),
                                );
                              },
                              child: Center(
                                child: Container(
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: const Color.fromARGB(
                                        255, 210, 208, 208),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: width * 0.3,
                      height: height * 0.22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 2), // Menggeser bayangan ke bawah
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(AddAccountChildernPage(anak_id: null));
                            },
                            child: DottedBorder(
                              borderType: BorderType.Circle,
                              strokeWidth: 10,
                              color: const Color.fromARGB(255, 134, 172, 237),
                              padding: EdgeInsets.all(2),
                              child: CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 20,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Tambah Profil Anak',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
