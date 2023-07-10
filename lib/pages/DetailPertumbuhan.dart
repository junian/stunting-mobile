import 'package:flutter/material.dart';

class DetailPertumbuhanPage extends StatelessWidget {
  double berat;
  double tinggi;
  double lebarKepala;
  String createDate;
  String usia;

  DetailPertumbuhanPage({
    super.key,
    required this.berat,
    required this.tinggi,
    required this.lebarKepala,
    required this.createDate,
    required this.usia,
  });

  @override
  Widget build(BuildContext context) {
    bool isBeratNormal(double berat) {
      // Logika pengecekan berat badan normal berdasarkan standar WHO
      // Anda dapat mengubah logika ini sesuai dengan preferensi Anda
      if (berat >= 2.5 && berat <= 4.0) {
        return true;
      } else {
        return false;
      }
    }

    bool isTinggiNormal(double tinggi) {
      // Logika pengecekan tinggi badan normal berdasarkan standar WHO
      // Anda dapat mengubah logika ini sesuai dengan preferensi Anda
      if (tinggi >= 45.0 && tinggi <= 55.0) {
        return true;
      } else {
        return false;
      }
    }

    bool isLebarKepalaNormal(double lebarKepala) {
      // Logika pengecekan lebar kepala normal berdasarkan standar WHO
      // Anda dapat mengubah logika ini sesuai dengan preferensi Anda
      if (lebarKepala >= 30.0 && lebarKepala <= 40.0) {
        return true;
      } else {
        return false;
      }
    }

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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(createDate,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text(
                  "Usia Anak : ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(usia,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text(
                  "Berat : ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("${berat.toString()} kg",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text(
                  "Tinggi : ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("${tinggi.toString()} cm",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text(
                  "Lingkar Kepala : ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("${lebarKepala.toString()} cm",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      Text(isBeratNormal(berat) ? "Normal" : "Tidak Normal",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isBeratNormal(berat)
                                  ? Colors.green
                                  : Colors.yellow)),
                      Text(
                          isBeratNormal(berat)
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
                      Text(isTinggiNormal(tinggi) ? "Normal" : "Tidak Normal",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isTinggiNormal(tinggi)
                                  ? Colors.green
                                  : Colors.yellow)),
                      Text(
                          isTinggiNormal(tinggi)
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
                      Text(
                          isLebarKepalaNormal(lebarKepala)
                              ? "Normal"
                              : "Tidak Normal",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isLebarKepalaNormal(lebarKepala)
                                  ? Colors.green
                                  : Colors.yellow)),
                      Text(
                          isLebarKepalaNormal(lebarKepala)
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
