import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPertumbuhanPage extends StatelessWidget {
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
  DetailPertumbuhanPage(
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
        title: Text('Detail Pertumbuhan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Tanggal Pertumbuhan : ",
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
                  "Usia Anak : ",
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
                  "Berat : ",
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
                  "Tinggi : ",
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
                  "Lingkar Kepala : ",
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
                          "Status Pertumbuhan Berat Badan berdasarkan standard WHO : ",
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
                              ? "Ket. Tetap jaga kesehatan Anak Anda"
                              : "Ket. Silahkan konsultasi dengan petugas setempat",
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
                          "Status Pertumbuhan Tinggi Badan berdasarkan standard WHO : ",
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
                              ? "Ket. Tetap jaga kesehatan Anak Anda"
                              : "Ket. Silahkan konsultasi dengan petugas setempat",
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
                          "Status Pertumbuhan Lebar Kepala berdasarkan standard WHO : ",
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
                              ? "Ket. Tetap jaga kesehatan Anak Anda"
                              : "Ket. Silahkan konsultasi dengan petugas setempat",
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
