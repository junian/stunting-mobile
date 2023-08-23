import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stantapp/controller/TambahDataPertumbuhanController.dart';

class TambahPertummbuhanPage extends StatefulWidget {
  String anakID;
  String tinggiBadanAyah;
  String tinggiBadanIbu;
  TambahPertummbuhanPage(
      {super.key,
      required this.anakID,
      required this.tinggiBadanAyah,
      required this.tinggiBadanIbu});

  @override
  State<TambahPertummbuhanPage> createState() => _TambahPertummbuhanPageState();
}

class _TambahPertummbuhanPageState extends State<TambahPertummbuhanPage> {
  var tambahPertumbuhanAnak = Get.put(TambahDataPertumbuhanController());

  TextEditingController dateinput = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: source);

      if (pickedFile != null) {
        // Mengambil file gambar yang dipilih
        File pickedImageFile = File(pickedFile.path);

        setState(() {
          tambahPertumbuhanAnak.pickedImage = pickedImageFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    bool isClicked = true;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Tambah Data Pertumbuhan'),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          tambahPertumbuhanAnak.addPertumbuhanAnak(
              anakID: widget.anakID,
              selectedDate: dateinput.text,
              pickedImage: tambahPertumbuhanAnak.pickedImage as File,
              beratBadan: double.parse(tambahPertumbuhanAnak.beratBadan.text),
              tinggiBadan: double.parse(tambahPertumbuhanAnak.tinggiBadan.text),
              lingkarKepala:
                  double.parse(tambahPertumbuhanAnak.lingkarKepala.text),
              tinggiBadanIbu: widget.tinggiBadanIbu,
              tinggiBadanAyah: widget.tinggiBadanAyah);
          Get.back();
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
              "Simpan",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
          child: Column(
            children: [
              Row(
                children: [
                  // Container(
                  //   width: width * 0.3,
                  //   height: height * 0.1,
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Text(
                  //             'Umur',
                  //             style: TextStyle(color: Colors.grey),
                  //           ),
                  //           Text(
                  //             '*',
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.red,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           border: Border(
                  //             bottom: BorderSide(
                  //               color: Colors.black,
                  //               width: 1.0,
                  //             ),
                  //           ),
                  //         ),
                  //         child: TextField(
                  //           keyboardType: TextInputType.number,
                  //           decoration: InputDecoration(
                  //             hintStyle:
                  //                 TextStyle(fontSize: 15, color: Colors.black),
                  //             hintText: 'Usia Anak',
                  //             border: InputBorder.none,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  width: width,
                  height: height * 0.1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Row(
                  children: [
                    Text(
                      'Tanggal Pertumbuhan',
                      style: TextStyle(),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: TextField(
                  controller: dateinput, //editing controller of this TextField
                  decoration: InputDecoration(
                    hintText: 'Tanggal Pertumbuhan',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isClicked
                            ? const Color.fromARGB(255, 188, 180, 179)
                            : Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement

                      setState(() {
                        dateinput.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                  onSubmitted: (value) {
                    setState(() {
                      isClicked = false;
                    });
                  },
                ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  width: width,
                  height: height * 0.1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Berat Badan (kg)',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: tambahPertumbuhanAnak.beratBadan,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            hintText: 'Contoh : 3.5',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  width: width,
                  height: height * 0.1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Tinggi Badan (cm)',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: tambahPertumbuhanAnak.tinggiBadan,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            hintText: 'Contoh : 40.8',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  width: width,
                  height: height * 0.1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Lingkar Kepala (cm)',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: tambahPertumbuhanAnak.lingkarKepala,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            hintText: 'Contoh : 40.8',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      // Aksi ketika tombol unggah foto ditekan
                      _pickImage(ImageSource.gallery);
                    },
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      color: Colors.blue,
                      radius: Radius.circular(20),
                      padding: EdgeInsets.all(3),
                      child: Container(
                        width: width * 0.9,
                        height: height * 0.07,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Unggah Foto',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: width,
                  height: height * 0.2,
                  child: tambahPertumbuhanAnak.pickedImage == null
                      ? SizedBox() // Tampilkan data kosong jika belum ada gambar terpilih
                      : Image.file(tambahPertumbuhanAnak.pickedImage!),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
