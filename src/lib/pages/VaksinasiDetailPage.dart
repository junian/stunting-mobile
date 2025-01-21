import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stantapp/controller/JadwalVaksinasiController.dart';
import 'package:get/get.dart';
import 'package:stantapp/controller/VaksinasiController.dart';
import 'package:stantapp/pages/VaksinasiAdd.dart';
import 'package:stantapp/pages/WelcomePage.dart';

class VaksinasiDetailPage extends StatefulWidget {
  String anak_id;
  String vaksin_id;
  String tgl_rekomendasi;
  String nama_vaksinasi;
  String status;
  VaksinasiDetailPage(
      {super.key,
      required this.anak_id,
      required this.vaksin_id,
      required this.tgl_rekomendasi,
      required this.nama_vaksinasi,
      required this.status});

  @override
  State<VaksinasiDetailPage> createState() => _VaksinasiDetailPageState();
}

class _VaksinasiDetailPageState extends State<VaksinasiDetailPage> {
  var vaksinasiController = Get.put(JadwalVaksinasiController());
  var vaksinasi = Get.put(VaksinasiController());
  String? _selectedOption;

  //image picker
  File? image;
  Future<void> _pickImage() async {
    try {
      final imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Mengambil file gambar yang dipilih
        File imageTemporary = File(image.path);

        setState(() {
          vaksinasiController.pickedImage = imageTemporary;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: const Color.fromARGB(255, 209, 209, 209),
                            width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Status Vaksinasi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: const Color.fromARGB(255, 209, 209, 209),
                                width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Belum'),
                            Radio(
                              value: 'Belum',
                              groupValue: _selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: const Color.fromARGB(255, 209, 209, 209),
                                width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sudah'),
                            Radio(
                              value: 'Sudah',
                              groupValue: _selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      print('Pilihan: $_selectedOption');
                      // Navigator.of(context).pop();
                      if (_selectedOption == 'Sudah') {
                        vaksinasi.dateinput.text = "";
                        vaksinasi.nama_dokter.text = "";
                        vaksinasi.no_batch.text = "";
                        vaksinasi.tempat.text = "";
                        Get.to(VaksinasiAddPage(
                            anak_id: widget.anak_id,
                            vaksin_id: widget.vaksin_id));
                        ;
                      } else {
                        Get.back();
                      }
                    },
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: height * 0.03),
                        padding: EdgeInsets.all(10),
                        width: width * 0.9,
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Simpan',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      // Inisialisasi ulang nilai _selectedOption
      // setState(() {
      //   _selectedOption = null;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    print(image);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.nama_vaksinasi}',
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 217, 216, 216),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Icon(
                      Icons.calendar_month,
                      size: 22,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal Direkomendasikan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${widget.tgl_rekomendasi}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      '${widget.nama_vaksinasi}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        text:
                            'Mencegah Penyakit hepatitis B yang dapat menyebabkan kerusakan hati',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Text(
                      'Lihat Lebih Lanjut',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.personal_injury_rounded,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Status Vaksinasi',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: widget.status == "Sudah"
                              ? Colors.green[100]
                              : Colors.red[100],
                        ),
                        child: Text(
                          widget.status,
                          style: TextStyle(
                            color: widget.status == "Sudah"
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.status == "Sudah") {
                        vaksinasi.getVaksinAnak(
                            anak_id: widget.anak_id,
                            vaksin_id: widget.vaksin_id);
                      } else {
                        _showModalBottomSheet(context);
                      }
                    },
                    child: Container(
                      width: width * 0.9,
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Edit Status',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
