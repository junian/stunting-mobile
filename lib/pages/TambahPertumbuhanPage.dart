import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TambahPertummbuhanPage extends StatefulWidget {
  const TambahPertummbuhanPage({super.key});

  @override
  State<TambahPertummbuhanPage> createState() => _TambahPertummbuhanPageState();
}

class _TambahPertummbuhanPageState extends State<TambahPertummbuhanPage> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('d MMM y');
    String datenow = dateFormat.format(_selectedDate);
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
        onTap: () {},
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
      body: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: width * 0.6,
                  height: height * 0.1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Tgl Pertumbuhan',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: width * 0.4,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              child: Text(
                                datenow,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width * 0.3,
                  height: height * 0.1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Umur',
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
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            hintText: 'Usia Anak',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
          ],
        ),
      ),
    );
  }
}
