import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:stantapp/controller/AuthController.dart';
import 'package:stantapp/controller/ChildernController.dart';
import 'package:stantapp/controller/SessionController.dart';
import 'package:stantapp/pages/AddAccountChildern.dart';
import 'package:get/get.dart';
import 'package:stantapp/pages/ArtikelPage.dart';
import 'package:stantapp/pages/ChildernDetail.dart';
import 'package:stantapp/pages/NotificationPage.dart';
import 'package:stantapp/pages/SetProfilePage.dart';
import 'package:stantapp/widget/BottomNavbar.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authController = Get.put(AuthController());
  final childernController = Get.put(ChildernController());
  final sessionController = Get.put(SessionController());

  @override
  void initState() {
    super.initState();
    childernController.getAnak(sessionController.user_id.value, null);
  }

  @override
  Widget build(BuildContext context) {
    int dataLength = 0; // Ganti dengan panjang data aktual Anda

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
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
                } else {
                  return MyContainer2.buildContainer(context);
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
                    padding:
                        const EdgeInsets.only(top: 10, left: 12, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rekomendasi Artikel',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  authController.bottomNavIndex = 1;
                                });
                                Future.delayed(Duration(milliseconds: 500), () {
                                  // Navigasi ke halaman BottomNavbar menggunakan Get.to()
                                  Get.to(BottomNavbar());
                                });
                              },
                              child: Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Container(
                          height: height * 0.3,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Container(
                                width: 200,
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 200,
                                        height: 110,
                                        child: Image.asset(
                                          'images/image_0.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 148, 184, 245),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Kategori',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Text(
                                          'Alat Masak yang Perlu di Siapkan Untuk MPASI',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Text(
                                          '21 Jun 2023',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 200,
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 200,
                                        height: 110,
                                        child: Image.asset(
                                          'images/image_1.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 148, 184, 245),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Kategori',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Text(
                                          'Alat Masak yang Perlu di Siapkan Untuk MPASI di kota Bekasi',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Text(
                                          '21 Jun 2023',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class MyContainer {
  static Widget buildContainer(BuildContext context) {
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
                  child: Expanded(
                    child: Text(
                      'Hai, Muhammad Haris',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                      child: Expanded(
                        child: Text(
                          'Hai, Muhammad Haris',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
                                  child: Image.asset(
                                    'images/image_0.png',
                                    width: width * 0.7,
                                    height: height * 0.05,
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
                                )
                              ],
                            ),
                            SizedBox(
                              width: width * 0.12,
                            ),
                            GestureDetector(
                              onTap: () {
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
