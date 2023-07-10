import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stantapp/controller/ChildernController.dart';
import 'HomePage2.dart';

class AddAccountChildernPage extends StatefulWidget {
  const AddAccountChildernPage({super.key});

  @override
  State<AddAccountChildernPage> createState() => _AddAccountChildernPageState();
}

class _AddAccountChildernPageState extends State<AddAccountChildernPage> {
  var childernController = Get.put(ChildernController());

  TextEditingController nama_anak = TextEditingController();
  TextEditingController tanggal_lahir = TextEditingController();
  TextEditingController jenis_kelamin = TextEditingController();
  TextEditingController berat_badan = TextEditingController();
  TextEditingController tinggi_badan = TextEditingController();
  TextEditingController lingkar_kepala = TextEditingController();
  TextEditingController tinggi_badan_ibu = TextEditingController();
  TextEditingController tinggi_badan_ayah = TextEditingController();

  bool isClicked = false;

  List<String> _genders = ['Laki - Laki', 'Perempuan'];
  String? _selectedGender;

  List<String> _provinces = ['Pilih Golongan Darah', 'A', 'B', 'O', 'AB'];
  String? _selectedProvince;

  TextEditingController dateinput = TextEditingController();
  //text editing controller for text field

  @override
  void initState() {
    super.initState();
    dateinput.text = ""; //set the initial value of text field
    _selectedProvince = _provinces.isNotEmpty ? _provinces[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Set Profile Anda'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Aksi ketika ikon kembali ditekan
            Get.back();
            // Anda dapat menambahkan Navigator.pop atau tindakan lain di sini
          },
        ),
      ),
      body: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, const Color.fromARGB(255, 220, 235, 247)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      DottedBorder(
                        borderType: BorderType.Circle,
                        color: Colors.blue,
                        strokeWidth: 1,
                        padding: EdgeInsets.all(5),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 194, 192, 192),
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Unggah Foto',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Text(
                      'Nama Lengkap',
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
                TextField(
                  controller: nama_anak,
                  decoration: InputDecoration(
                    hintText: 'Nama Lengkap',
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
                  onTap: () {
                    setState(() {
                      isClicked = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      isClicked = false;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Tanggal Lahir',
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
                TextField(
                  controller: dateinput, //editing controller of this TextField
                  decoration: InputDecoration(
                    hintText: 'Tanggal Lahir',
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
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Jenis Kelamin',
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
                Row(
                  children: [
                    Radio(
                      value: 'Laki-laki',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                    Text('Laki-laki'),
                    SizedBox(width: 16),
                    Radio(
                      value: 'Perempuan',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                    Text('Perempuan'),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Data Kelahiran',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Aksi ketika tombol unggah foto ditekan
                    },
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      color: Colors.blue,
                      radius: Radius.circular(20),
                      padding: EdgeInsets.all(1),
                      child: Container(
                        width: 300,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 220, 232, 243),
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
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Apakah anak anda lahir prematur',
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
                Row(
                  children: [
                    Radio(
                      value: 'ya',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                    Text('Ya'),
                    SizedBox(width: 16),
                    Radio(
                      value: 'tidak',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                    Text('Tidak'),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Input Berat Badan Saat Lahir (kg)',
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
                TextField(
                  controller: berat_badan,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Input Berat Badan dalam Kg',
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
                  onTap: () {
                    setState(() {
                      isClicked = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      isClicked = false;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Input Tinggi Badan Saat Lahir (Cm)',
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
                TextField(
                  controller: tinggi_badan,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Input Tinggi Badan dalam cm',
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
                  onTap: () {
                    setState(() {
                      isClicked = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      isClicked = false;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Input Lingkar Kepala Saat Lahir (Cm)',
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
                TextField(
                  controller: lingkar_kepala,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Input Lingkar Kepala Saat Lahir (Cm)',
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
                  onTap: () {
                    setState(() {
                      isClicked = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      isClicked = false;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Profil Tambahan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Golongan Darah',
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
                DropdownButtonFormField(
                  value: _selectedProvince ?? '',
                  items: _provinces.map((province) {
                    return DropdownMenuItem(
                      value: province,
                      child: Text(province),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProvince = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Mempunyai Alergi',
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
                Row(
                  children: [
                    Radio(
                      value: 'ya',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                    Text('Ya'),
                    SizedBox(width: 16),
                    Radio(
                      value: 'tidak',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                    Text('Tidak'),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Tinggi Badan Orang Tua',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Keterangan: Data tinggi badang orang tua akan digunakan untuk mengukur potensial tinggi badan anak saat dewasa',
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Tinggi Badan Ibu (Cm)',
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
                TextField(
                  controller: tinggi_badan_ibu,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Tinggi Badan Ibu (Cm)',
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
                  onTap: () {
                    setState(() {
                      isClicked = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      isClicked = false;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Tinggi Badan Ayah (Cm)',
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
                TextField(
                  controller: tinggi_badan_ayah,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Tinggi Badan Ayah (Cm)',
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
                  onTap: () {
                    setState(() {
                      isClicked = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      isClicked = false;
                    });
                  },
                ),
                SizedBox(
                  height: height * 0.13,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          childernController.registerAnak(
            5.toString(),
            nama_anak.text,
            dateinput.text,
            _selectedGender.toString(),
            berat_badan.text,
            tinggi_badan.text,
            lingkar_kepala.text,
            tinggi_badan_ibu.text,
            tinggi_badan_ayah.text,
          );
          // Get.to(
          //   HomePage2(),
          // );
        },
        child: Container(
            alignment: Alignment.center,
            width: width * 0.9,
            height: height * 0.06,
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
    );
  }
}
