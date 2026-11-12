import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:growthtracker/controller/AuthController.dart';
import 'package:growthtracker/controller/ChildrenController.dart';
import 'package:growthtracker/controller/NotificationController.dart';
import 'package:growthtracker/controller/GrowthHistoryController.dart';
import 'package:growthtracker/controller/SessionController.dart';
import 'package:growthtracker/pages/ChildrenEditorPage.dart';
import 'package:get/get.dart';
import 'package:growthtracker/pages/ChildrenDetailPage.dart';
import 'package:growthtracker/pages/NotificationPage.dart';
import 'package:growthtracker/pages/SetProfilePage.dart';
import 'package:growthtracker/widget/AppPhoto.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authController = Get.put(AuthController());
  final childernController = Get.put(ChildrenController());
  final sessionController = Get.put(SessionController());

  bool isDataInitialized = false;

  Future<void> initializeData() async {
    await Future.delayed(Duration(seconds: 2));
    // Children live on the device, so they load for guests as well.
    await childernController.getAnak(sessionController.user_id.value, null);
    if (sessionController.user_id.value.isNotEmpty) {
      await authController.getOrangTua(sessionController.user_id.value);
    }

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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;


    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       _controller.value.isPlaying
      //           ? _controller.pause()
      //           : _controller.play();
      //     });
      //   },
      //   child: Icon(
      //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
      //   ),
      // ),
      body: isDataInitialized == true
          ? Container(
              child: Stack(
                children: [
                  Container(
                    height: height * 0.57,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width,
                          height: height * 0.34,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
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
                  //                   // Action to run when the notification bell icon is pressed
                  //                   // For example, show a notification or navigate to the notification page
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
                  //                   // Action to run when the notification bell icon is pressed
                  //                   // For example, show a notification or navigate to the notification page
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
                  //               offset: Offset(0, 2), // Shift the shadow downward
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
                  //                 // Action to run when the button is pressed
                  //                 Get.to(
                  //                   ChildrenEditorPage(),
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
                    authController.isParent.isNotEmpty
                        ? 'Hai, ${authController.isParent[0]["nama_orang_tua"]}'
                        : 'Hai',
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
                        notificationController.getNotifikasi(
                            sessionController.user_id.toString());
                        Get.to(NotifikasiPage());
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
                    offset: Offset(0, 2), // Shift the shadow downward
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
                    'no_child_profile'.tr,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      // Action to run when the button is pressed
                      Get.to(
                        ChildrenEditorPage(
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
                            'add'.tr,
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
    final childernController = Get.put(ChildrenController());
    final sessionController = Get.put(SessionController());
    final authController = Get.put(AuthController());
    final riwayatPertumbuhanController =
        Get.put(GrowthHistoryController());
    final notificationController = Get.put(NotificationController());
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Current date
    DateTime currentDate = DateTime.now();
// Birth date
    DateTime birthDate =
        DateTime.parse(childernController.anakList[0]['tanggal_lahir']);
// Calculate the difference between the current date and the birth date
    Duration ageDifference = currentDate.difference(birthDate);

// Calculate years, months, and days from the computed difference
    int years = ageDifference.inDays ~/ 365;
    int remainingMonths = (ageDifference.inDays % 365) ~/ 30;
    int remainingDays = ageDifference.inDays % 30;

// Format the result
    String formattedAge = '';
    if (years > 0) {
      formattedAge += 'age_years'.trParams({'count': '$years'});
    }
    if (remainingMonths > 0) {
      formattedAge +=
          'age_months'.trParams({'count': '$remainingMonths'});
    }
    if (remainingDays > 0) {
      formattedAge += 'age_days'.trParams({'count': '$remainingDays'});
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
                        'greeting'.trParams({
                          'name':
                              authController.isParent.isNotEmpty
                                  ? '${authController.isParent[0]["nama_orang_tua"]}'
                                  : 'Hai'
                        }),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Container(
                    //     child: Row(
                    //       children: [
                    //         Text(
                    //           'Naikan Level Membership ',
                    //           style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 12,
                    //             fontWeight: FontWeight.w300,
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           width: width * 0.01,
                    //         ),
                    //         Icon(
                    //           Icons.arrow_forward_ios_rounded,
                    //           color: Colors.white,
                    //           size: 10,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        notificationController.getNotifikasi(
                            sessionController.user_id.toString());
                        Get.to(NotifikasiPage());
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
              height: height * 0.03,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'child_profile'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // GestureDetector(
                    //   child: Text(
                    //     'Lihat Semua',
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
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
                            offset: Offset(0, 2), // Shift the shadow downward
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
                                          child: AppPhoto(
                                            childernController.anakList[0]
                                                ['photo'],
                                            width: 70,
                                            height: 70,
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
                                riwayatPertumbuhanController.getPertumbuhanAnak(
                                    childernController.anakList[0]['anak_id']);
                                childernController.getAnakById(
                                    sessionController.user_id.value,
                                    childernController.anakList[0]['anak_id']);
                                Get.to(
                                  ChildrenDetailPage(),
                                );
                              },
                              child: Center(
                                child: Container(
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor:
                                        Color.fromARGB(255, 210, 208, 208),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
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
                            offset: Offset(0, 2), // Shift the shadow downward
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(ChildrenEditorPage(anak_id: null));
                            },
                            child: DottedBorder(
                              options: CircularDottedBorderOptions(
                                strokeWidth: 10,
                                color: const Color.fromARGB(255, 134, 172, 237),
                                padding: EdgeInsets.all(2),
                              ),
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
                            'add_child_profile'.tr,
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
