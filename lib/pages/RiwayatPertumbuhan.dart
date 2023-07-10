import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'DetailPertumbuhan.dart';
import 'TambahPertumbuhanPage.dart';

class Data {
  double berat;
  double tinggi;
  double lebarKepala;
  DateTime createDate;
  DateTime tanggalLahir;
  String imageUrl;

  Data({
    required this.berat,
    required this.tinggi,
    required this.lebarKepala,
    required this.createDate,
    required this.tanggalLahir,
    required this.imageUrl,
  });
}

List<Data> dataList = [
  Data(
    berat: 3.5,
    tinggi: 50.0,
    lebarKepala: 35.0,
    createDate: DateTime(2023, 1, 1),
    tanggalLahir: DateTime(2022, 12, 15),
    imageUrl: 'https://example.com/image1.jpg',
  ),
  Data(
    berat: 3.2,
    tinggi: 48.0,
    lebarKepala: 33.0,
    createDate: DateTime(2023, 1, 2),
    tanggalLahir: DateTime(2022, 11, 30),
    imageUrl: 'https://example.com/image2.jpg',
  ),
  Data(
    berat: 3.8,
    tinggi: 52.0,
    lebarKepala: 36.0,
    createDate: DateTime(2023, 1, 3),
    tanggalLahir: DateTime(1997, 10, 20),
    imageUrl: 'https://example.com/image3.jpg',
  ),
  Data(
    berat: 3.5,
    tinggi: 50.0,
    lebarKepala: 35.0,
    createDate: DateTime(2023, 1, 1),
    tanggalLahir: DateTime(2022, 12, 15),
    imageUrl: 'https://example.com/image1.jpg',
  ),
  Data(
    berat: 3.2,
    tinggi: 48.0,
    lebarKepala: 33.0,
    createDate: DateTime(2023, 1, 2),
    tanggalLahir: DateTime(2022, 11, 30),
    imageUrl: 'https://example.com/image2.jpg',
  ),
  Data(
    berat: 20.8,
    tinggi: 52.0,
    lebarKepala: 36.0,
    createDate: DateTime(2023, 1, 3),
    tanggalLahir: DateTime(1997, 10, 20),
    imageUrl: 'https://example.com/image3.jpg',
  ),
];

class RiwayatpertumbuhanPage extends StatefulWidget {
  const RiwayatpertumbuhanPage({Key? key}) : super(key: key);

  @override
  State<RiwayatpertumbuhanPage> createState() => _RiwayatpertumbuhanPageState();
}

class _RiwayatpertumbuhanPageState extends State<RiwayatpertumbuhanPage> {
  bool isAscending = false;

  List<Data> filteredList = [];

  @override
  void initState() {
    super.initState();
    // Mengatur filteredList dengan data asli saat inisialisasi
    filteredList = List.from(dataList);
  }

  void filterData(bool ascending) {
    setState(() {
      isAscending = ascending;

      filteredList = List.from(dataList);

      filteredList.sort((a, b) => ascending
          ? a.createDate.compareTo(b.createDate)
          : b.createDate.compareTo(a.createDate));
    });
  }

  Future<void> _refreshData() async {
    // Simulasikan proses pembaruan data (misalnya: pengambilan data baru dari server)
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      // Perbarui data Anda di sini
      filteredList = List.from(dataList);
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
        title: Text('Riwayat Pertumbuahan'),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TambahPertummbuhanPage()));
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
              "Tambah Pertumbuhan",
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
                              'Terakhir',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        DropdownMenuItem<bool>(
                          value: false,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'Terbaru',
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
                    "Berat",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Tinggi", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("L.Kepala",
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
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  Data data = filteredList[index];
                  DateFormat dateFormat = DateFormat('d MMM y');
                  String tglbuat = dateFormat.format(data.createDate);

                  String formatSelisihTanggal(
                      DateTime startDate, DateTime endDate) {
                    Duration selisih = endDate.difference(startDate);
                    int tahun = selisih.inDays ~/ 365;
                    int bulan = (selisih.inDays % 365) ~/ 30;
                    int hari = selisih.inDays % 30;

                    String hasil = '';
                    if (tahun > 0) {
                      hasil += '$tahun tahun ';
                    }
                    if (bulan > 0) {
                      hasil += '$bulan bulan ';
                    }
                    if (hari > 0) {
                      hasil += '$hari hari';
                    }

                    return hasil.trim();
                  }

                  var selisih =
                      formatSelisihTanggal(data.tanggalLahir, data.createDate);

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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailPertumbuhanPage(
                                                      berat: data.berat,
                                                      tinggi: data.tinggi,
                                                      lebarKepala:
                                                          data.lebarKepala,
                                                      createDate: tglbuat,
                                                      usia: selisih)));
                                    },
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                    )),
                                Text("${data.berat.toString()} kg"),
                                Text("${data.tinggi.toString()} cm"),
                                Text("${data.lebarKepala.toString()} cm"),
                                GestureDetector(
                                  onTap: () {
                                    //function edit
                                  },
                                  child: Icon(
                                    Icons.edit,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  tglbuat,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(selisih,
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
