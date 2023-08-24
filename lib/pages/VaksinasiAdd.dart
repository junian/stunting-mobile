import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stantapp/controller/TambahDataPertumbuhanController.dart';
import 'package:stantapp/controller/VaksinasiController.dart';

class VaksinasiAddPage extends StatefulWidget {
  String anak_id;
  String vaksin_id;
  String? vaksin_anak_id;
  VaksinasiAddPage(
      {super.key,
      required this.anak_id,
      required this.vaksin_id,
      this.vaksin_anak_id});

  @override
  State<VaksinasiAddPage> createState() => _VaksinasiAddPageState();
}

class _VaksinasiAddPageState extends State<VaksinasiAddPage> {
  var vaksinasiController = Get.put(VaksinasiController());

  Future<void> _pickImage(ImageSource source) async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: source);

      if (pickedFile != null) {
        // Mengambil file gambar yang dipilih
        File pickedImageFile = File(pickedFile.path);

        setState(() {
          vaksinasiController.pickedImage = pickedImageFile;
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
        title: Text('Tambah Vaksinasi Anak'),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          vaksinasiController.addVaksinAnak(
              vaksin_anak_id: widget.vaksin_anak_id,
              anak_id: widget.anak_id,
              vaksin_id: widget.vaksin_id,
              tanggal_vaksin: vaksinasiController.dateinput.text,
              name_dokter: vaksinasiController.nama_dokter.text,
              tempat: vaksinasiController.tempat.text,
              no_batch: vaksinasiController.no_batch.text,
              pickedImage: vaksinasiController.pickedImage);
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
                                'Tanggal Vaksinasi',
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
                          controller: vaksinasiController
                              .dateinput, //editing controller of this TextField
                          decoration: InputDecoration(
                            hintText: 'Tanggal Vaksinasi',
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
                                vaksinasiController.dateinput.text =
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
                            'Nama Dokter',
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
                          controller: vaksinasiController.nama_dokter,
                          decoration: InputDecoration(
                            hintText: 'Nama Dokter',
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
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
                            'Tempat',
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
                          controller: vaksinasiController.tempat,
                          decoration: InputDecoration(
                            hintText: 'Nama Tempat',
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
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
                            'No Batch',
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
                          controller: vaksinasiController.no_batch,
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            hintText: 'No Batch',
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
                  child: vaksinasiController.pickedImage == null
                      ? SizedBox() // Tampilkan data kosong jika belum ada gambar terpilih
                      : Image.file(vaksinasiController.pickedImage!),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
