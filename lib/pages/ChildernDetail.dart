import 'package:flutter/material.dart';
import 'package:stantapp/controller/ChildernController.dart';
import 'package:get/get.dart';

class ChildernPage extends StatefulWidget {
  ChildernPage({super.key});

  @override
  State<ChildernPage> createState() => _ChildernPageState();
}

class _ChildernPageState extends State<ChildernPage> {
  var childernController = Get.put(ChildernController());

  @override
  void initState() {
    super.initState();
    childernController.getAnak(5.toString(), 5.toString());
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

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

    print(childernController.dataAnak);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 20,
                  child: Image.asset(
                    'images/image_1.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  width: width * 0.5,
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Obx(
                              () => Container(
                                width: width * 0.4,
                                child: Text(
                                  childernController.anakList[0]['nama_anak'],
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
                          ),
                          Container(
                            child: Transform.rotate(
                              angle: 270 * 3.1415926535 / 180,
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        child: Text(
                          formattedAge,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 211, 209, 209),
                    child: Icon(Icons.edit),
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
        ),
      ),
      body: Column(
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
            color: Color.fromARGB(255, 225, 223, 223),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: height * 0.025),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        height: height * 0.12,
                        width: width * 0.90,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Image.asset(
                                fit: BoxFit.contain,
                                height: height * 0.15,
                                width: width * 0.15,
                                'images/image_3.png',
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      'Panduan Kesehatan Anak',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '0 - 3 Bulan',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: CircleAvatar(
                                radius: 15,
                                child: Transform.rotate(
                                  angle: 270 * 3.1415926535 / 180,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 16,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.05),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hasil Pertumbuhan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Lihat Semua',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue,
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
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: height * 0.2,
                                      width: width * 0.25,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 201, 242, 229),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: width * 0.25,
                                            height: height * 0.060,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                              color: Colors.greenAccent,
                                            ),
                                            child: Container(
                                              child: Icon(Icons.access_alarm),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Berat',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '35 ',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Kg',
                                                      style: TextStyle(
                                                        fontSize: 12,
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
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            Color.fromARGB(255, 240, 176, 176),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: width * 0.25,
                                            height: height * 0.060,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                              color: Color.fromARGB(
                                                  255, 236, 122, 122),
                                            ),
                                            child: Container(
                                              child: Icon(Icons.access_alarm),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Tinggi',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '40 ',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Cm',
                                                      style: TextStyle(
                                                        fontSize: 12,
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
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            Color.fromARGB(255, 240, 176, 176),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: width * 0.25,
                                            height: height * 0.060,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                              color: Color.fromARGB(
                                                  255, 236, 122, 122),
                                            ),
                                            child: Container(
                                              child: Icon(Icons.access_alarm),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'L.Kepala',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '40 ',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Cm',
                                                      style: TextStyle(
                                                        fontSize: 12,
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
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Terakhir Update',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '20 Juni 2023 - 20:46',
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
                              color: Color.fromARGB(255, 178, 180, 181),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                        'Muhammad Haris Kumala',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width * 0.25,
                                  height: height * 0.055,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
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
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
