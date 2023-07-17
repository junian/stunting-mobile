import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:stantapp/controller/ImunisasiController.dart';
import 'package:stantapp/pages/VaksinasiDetailPage.dart';
import 'package:get/get.dart';

class ImunisasiPage extends StatefulWidget {
  const ImunisasiPage({super.key});

  @override
  State<ImunisasiPage> createState() => _ImunisasiPageState();
}

class _ImunisasiPageState extends State<ImunisasiPage> {
  var imunisasiController = Get.put(ImunisasiController());

  List<dynamic> jadwalVaksin = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imunisasiController.getJadwalVaksin("2");
    jadwalVaksin = imunisasiController.jadwalVaksin;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Imunisasi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Muhammad Haris Kumala',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Text(
                  '0 Tahun 0 Bulan',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Container(
                  child: Transform.rotate(
                    angle: 270 * 3.1415926535 / 180,
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 13,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 233, 231, 231),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jadwal Vaksinasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.all(15),
              width: width * 0.9,
              height: height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                itemCount: jadwalVaksin.length,
                itemBuilder: (context, index) {
                  final periode = jadwalVaksin[index];

                  return Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        DottedBorder(
                          borderType: BorderType.RRect,
                          padding: EdgeInsets.all(0),
                          strokeWidth: 2,
                          radius: Radius.circular(10),
                          child: Container(
                            width: width * 0.8,
                            height: height * 0.055,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 153, 188, 248),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Di Rekomendasikan di',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '05 Jun 2023',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // margin: EdgeInsets.only(top: 15),
                          // padding: EdgeInsets.all(10),
                          // decoration: BoxDecoration(
                          //   border: Border(
                          //     bottom: BorderSide(
                          //       color: Color.fromARGB(255, 196, 53, 53),
                          //       width: 1,
                          //     ),
                          //   ),
                          // ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: periode['vaksin'].length,
                            itemBuilder: (context, index) {
                              final vaksin = periode['vaksin'][index];
                              return Container(
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromARGB(255, 207, 205, 205),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: width * 0.5,
                                      child: Text(
                                        vaksin['nama_vaksin'],
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.25,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 3,
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: vaksin['status'] == "Belum"
                                                  ? Color.fromARGB(
                                                      255, 248, 189, 189)
                                                  : Color.fromARGB(
                                                      255, 189, 248, 195),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                vaksin['status'],
                                                style: TextStyle(
                                                  color: vaksin['status'] ==
                                                          "Belum"
                                                      ? Color.fromARGB(
                                                          255,
                                                          247,
                                                          111,
                                                          101,
                                                        )
                                                      : Color.fromARGB(
                                                          255, 0, 168, 17),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              vaksin['vaksin_id'];
                                              Get.to(VaksinasiDetailPage());
                                            },
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                255,
                                                208,
                                                208,
                                                208,
                                              ),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // child: Column(
              //   children: [
              //     DottedBorder(
              //       borderType: BorderType.RRect,
              //       padding: EdgeInsets.all(0),
              //       strokeWidth: 2,
              //       radius: Radius.circular(10),
              //       child: Container(
              //         width: width * 0.8,
              //         height: height * 0.055,
              //         decoration: BoxDecoration(
              //           color: const Color.fromARGB(255, 153, 188, 248),
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: Center(
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Text(
              //                 'Di Rekomendasikan di',
              //                 style: TextStyle(
              //                   fontSize: 12,
              //                 ),
              //               ),
              //               SizedBox(
              //                 width: 2,
              //               ),
              //               Text(
              //                 '05 Jun 2023',
              //                 style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 12,
              //                 ),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //     Container(
              //       margin: EdgeInsets.only(top: 15),
              //       padding: EdgeInsets.all(10),
              //       decoration: BoxDecoration(
              //         border: Border(
              //           bottom: BorderSide(
              //             color: Color.fromARGB(255, 216, 214, 214),
              //             width: 1,
              //           ),
              //         ),
              //       ),
              //       child: Row(
              //         children: [
              //           Container(
              //             // color: Colors.blue,
              //             width: width * 0.5,
              //             child: Text(
              //               'Hepatitis B 1',
              //               style: TextStyle(
              //                 fontSize: 16,
              //               ),
              //               overflow: TextOverflow.ellipsis,
              //               maxLines: 1,
              //             ),
              //           ),
              //           Container(
              //             width: width * 0.25,
              //             // color: Colors.grey,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Container(
              //                   padding: EdgeInsets.symmetric(
              //                       vertical: 3, horizontal: 8),
              //                   decoration: BoxDecoration(
              //                     color: Color.fromARGB(255, 248, 189, 189),
              //                     borderRadius: BorderRadius.circular(10),
              //                   ),
              //                   child: Center(
              //                     child: Text(
              //                       'Belum',
              //                       style: TextStyle(
              //                         color: const Color.fromARGB(
              //                             255, 247, 111, 101),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //                 GestureDetector(
              //                   onTap: () {
              //                     Get.to(
              //                       VaksinasiDetailPage(),
              //                     );
              //                   },
              //                   child: CircleAvatar(
              //                     radius: 15,
              //                     backgroundColor: const Color.fromARGB(
              //                         255, 208, 208, 208),
              //                     child: Icon(
              //                       Icons.arrow_forward_ios,
              //                       size: 14,
              //                     ),
              //                   ),
              //                 )
              //               ],
              //             ),
              //           )
              //         ],
              //       ),
              //     )
              //   ],
              // ),
            )
          ],
        ),
      ),
    );
  }
}
