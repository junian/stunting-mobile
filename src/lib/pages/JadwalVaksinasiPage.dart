import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stantapp/controller/JadwalVaksinasiController.dart';
import 'package:stantapp/controller/JadwalVaksinasiIDAIController.dart';
import 'package:stantapp/controller/VaksinasiController.dart';
import 'package:stantapp/pages/JadwalImunisasiIDAI.dart';
import 'package:stantapp/pages/VaksinasiDetailPage.dart';

class JadwalVaksinasiPage extends StatefulWidget {
  String anak_id;
  JadwalVaksinasiPage({super.key, required this.anak_id});

  @override
  State<JadwalVaksinasiPage> createState() => _JadwalVaksinasiPageState();
}

class _JadwalVaksinasiPageState extends State<JadwalVaksinasiPage> {
  var jadwalVaksinasiController = Get.put(JadwalVaksinasiController());
  var jadwalVaksinasiIDAIController = Get.put(JadwalVaksinasiIDAIController());
  var vaksinasiController = Get.put(VaksinasiController());
  int selectedMonth = 0;
  int selected = 0;

  bool isDataInitialized = false;
  String landscapePathPdf = "";

  Future<void> initializeData() async {
    await Future.delayed(Duration(seconds: 3));
    await jadwalVaksinasiController.getJadwalVaksin(widget.anak_id);
    await jadwalVaksinasiIDAIController.createFileOfPdfUrl();

    setState(() {
      isDataInitialized = true;
    });
    jadwalVaksinasiIDAIController.createFileOfPdfUrl().then((f) {
      setState(() {
        landscapePathPdf = f.path;
      });
    });
  }

  Future<void> _refreshData() async {
    // Simulasikan proses pembaruan data (misalnya: pengambilan data baru dari server)
    await jadwalVaksinasiController.getJadwalVaksin(widget.anak_id);
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  void initState() {
    initializeData();

    super.initState();
  }

  Widget build(BuildContext context) {
    List<Map<String, dynamic>> vaccinationData =
        jadwalVaksinasiController.jadwalVaksinasi.toList();
//
    List<Map<String, dynamic>> filteredData = vaccinationData
        .where((vaccination) =>
            vaccination['vaksin'][0]['bulan_ke'] == selectedMonth.toString())
        .toList();

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Jadwal Vaksinasi'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                width: width,
                height: height * 0.1,
                child: Row(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        width: width * 0.4,
                        height: height * 0.1,
                        child: Text(
                          "Jenis Tampilan",
                          style: TextStyle(fontSize: 20),
                        )),
                    Container(
                        width: width * 0.5,
                        height: height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.to(
                                    JadwalImunisaiIDAI(path: landscapePathPdf));
                              },
                              icon: Icon(Icons.table_chart_outlined),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  selected = 0;
                                  selectedMonth = 0;
                                });
                              },
                              icon: Icon(Icons.filter_alt_outlined),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: vaccinationData.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> item = vaccinationData[index];
      
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          String text = item['periode'];
                          RegExp regex = RegExp(r'\d+');
                          RegExpMatch? match = regex.firstMatch(text);
                          if (match != null) {
                            String? valueString = match.group(0);
                            int? value = int.tryParse(valueString!);
                            if (value != null) {
                              selectedMonth = value;
                              selected = index + 1;
                            }
                          }
                        });
                      },
                      child: Chip(
                        side: BorderSide.none,
                        label: Text(
                          item['periode'],
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: selected == index + 1
                            ? Colors.blue[200]
                            : Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
            isDataInitialized
                ? Expanded(
                    child: ListView.builder(
                      itemCount: selectedMonth == 0
                          ? vaccinationData.length
                          : filteredData.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> item = selectedMonth == 0
                            ? vaccinationData[index]
                            : filteredData[index];
      
                        return ExpansionTile(
                          title: Text(
                            item['periode'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 2, right: 16, left: 16),
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                color: Colors.blue,
                                radius: Radius.circular(20),
                                padding: EdgeInsets.all(3),
                                child: Container(
                                  width: width * 0.9,
                                  height: height * 0.07,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 18),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Dirokemendasikan di ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        item['rekomendasi'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                width: width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: item['vaksin'].length,
                                  itemBuilder:
                                      (BuildContext context, int subIndex) {
                                    Map<String, dynamic> subItem =
                                        item['vaksin'][subIndex];
                                    return ListTile(
                                        title: Text(
                                          subItem['nama_vaksin'],
                                          style: TextStyle(color: Colors.black54),
                                        ),
                                        trailing: Container(
                                          width: width * 0.5,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Chip(
                                                side: BorderSide.none,
                                                label: Text(
                                                  subItem['status'],
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: subItem['status'] ==
                                                              "Sudah"
                                                          ? Colors.green
                                                          : Colors.red),
                                                ),
                                                backgroundColor:
                                                    subItem['status'] == "Sudah"
                                                        ? Colors.green[100]
                                                        : Colors.red[100],
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Get.to(
                                                      VaksinasiDetailPage(
                                                        anak_id: widget.anak_id,
                                                        vaksin_id:
                                                            subItem['vaksin_id']
                                                                .toString(),
                                                        tgl_rekomendasi:
                                                            item['rekomendasi']
                                                                .toString(),
                                                        nama_vaksinasi:
                                                            subItem['nama_vaksin']
                                                                .toString(),
                                                        status: subItem['status'],
                                                      ),
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 15,
                                                  ))
                                            ],
                                          ),
                                        ));
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
