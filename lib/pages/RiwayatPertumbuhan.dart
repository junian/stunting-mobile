import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stantapp/controller/DetailPertumbuhanController.dart';
import '../controller/RiwayatPertumbuhanController.dart';
import '../controller/TambahDataPertumbuhanController.dart';
import 'DetailPertumbuhan.dart';
import 'TambahPertumbuhanPage.dart';

class RiwayatpertumbuhanPage extends StatefulWidget {
  String anak_id;
  String tinggi_badan_ibu;
  String tinggi_badan_ayah;
  RiwayatpertumbuhanPage(
      {Key? key,
      required this.anak_id,
      required this.tinggi_badan_ayah,
      required this.tinggi_badan_ibu})
      : super(key: key);

  @override
  State<RiwayatpertumbuhanPage> createState() => _RiwayatpertumbuhanPageState();
}

class _RiwayatpertumbuhanPageState extends State<RiwayatpertumbuhanPage> {
  bool isAscending = false;
  bool isDataInitialized = false;
  var riwayatPertumbuhanController = Get.put(RiwayatPertumbuhanController());
  var tambahPertumbuhanAnak = Get.put(TambahDataPertumbuhanController());
  var detailRiwayatPertumbuhanController =
      Get.put(DetailPertumbuhanController());

  List<Map<String, dynamic>> filteredList = [];

  Future<void> initializeData() async {
    await Future.delayed(Duration(seconds: 2)); // Menunggu selama 2 detik
    await riwayatPertumbuhanController.getPertumbuhanAnak(widget.anak_id);
    filteredList = riwayatPertumbuhanController.riwayatPertumbuhan.toList();
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

  void filterData(bool ascending) {
    setState(() {
      isAscending = ascending;

      filteredList = riwayatPertumbuhanController.riwayatPertumbuhan.toList();

      filteredList.sort((a, b) {
        // Membandingkan nilai berdasarkan tanggal pembuatan (created_date)
        DateTime dateA = DateTime.parse(a['created_date']);
        DateTime dateB = DateTime.parse(b['created_date']);

        if (isAscending) {
          return dateA.compareTo(dateB); // Urutan ascending
        } else {
          return dateB.compareTo(dateA); // Urutan descending
        }
      });
    });
  }

  Future<void> _refreshData() async {
    // Simulasikan proses pembaruan data (misalnya: pengambilan data baru dari server)
    riwayatPertumbuhanController.getPertumbuhanAnak(widget.anak_id);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      filteredList = riwayatPertumbuhanController.riwayatPertumbuhan.toList();
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
          riwayatPertumbuhanController.getPertumbuhanAnak(widget.anak_id);

          riwayatPertumbuhanController.riwayatPertumbuhan;

          Get.to(TambahPertummbuhanPage(
              anakID: widget.anak_id,
              tinggiBadanAyah: widget.tinggi_badan_ayah,
              tinggiBadanIbu: widget.tinggi_badan_ibu));
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
              child: isDataInitialized == true
                  ? ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = filteredList[index];
                        DateFormat dateFormat = DateFormat('d MMM y');
                        String tglbuat = dateFormat
                            .format(DateTime.parse(data['created_date']));

                        // String formatSelisihTanggal(
                        //     DateTime startDate, DateTime endDate) {
                        //   Duration selisih = endDate.difference(startDate);
                        //   int tahun = selisih.inDays ~/ 365;
                        //   int bulan = (selisih.inDays % 365) ~/ 30;
                        //   int hari = selisih.inDays % 30;

                        //   String hasil = '';
                        //   if (tahun > 0) {
                        //     hasil += '$tahun tahun ';
                        //   }
                        //   if (bulan > 0) {
                        //     hasil += '$bulan bulan ';
                        //   }
                        //   if (hari > 0) {
                        //     hasil += '$hari hari';
                        //   }

                        //   return hasil.trim();
                        // }

                        // var selisih =
                        //     formatSelisihTanggal(data.tanggalLahir, data.createDate);

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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            detailRiwayatPertumbuhanController
                                                .getDetailPertumbuhan(
                                                    data['pertumbuhan_anak_id'],
                                                    data['umur']);
                                          },
                                          child: Container(
                                            height: height * 0.03,
                                            width: width * 0.06,
                                            child: Image.network(
                                              "https://stantapp.alalanusantara.com/" +
                                                  data['photo'],
                                              fit: BoxFit.contain,
                                            ),
                                            // child: Icon(
                                            //   Icons.image,
                                            //   color: Colors.grey,
                                            // ),
                                          )),
                                      Text("${data['berat_badan']} kg"),
                                      Text("${data['tinggi_badan']} cm"),
                                      Text("${data['lingkar_kepala']} cm"),
                                      GestureDetector(
                                        onTap: () {
                                          detailRiwayatPertumbuhanController
                                              .getDetailPertumbuhan(
                                                  data['pertumbuhan_anak_id'],
                                                  data['umur']);
                                        },
                                        child: Icon(
                                          Icons.arrow_forward_ios,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        tglbuat,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(data['umur'],
                                          style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
