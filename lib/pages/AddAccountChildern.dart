import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stantapp/controller/ChildernController.dart';
import 'package:stantapp/controller/SessionController.dart';
import 'HomePage2.dart';

class AddAccountChildernPage extends StatefulWidget {
  var anak_id;
  AddAccountChildernPage({super.key, required this.anak_id});

  @override
  State<AddAccountChildernPage> createState() => _AddAccountChildernPageState();
}

class _AddAccountChildernPageState extends State<AddAccountChildernPage> {
  var childernController = Get.put(ChildernController());
  var sessionController = Get.put(SessionController());

  TextEditingController nama_anak = TextEditingController();
  TextEditingController tanggal_lahir = TextEditingController();
  TextEditingController jenis_kelamin = TextEditingController();
  TextEditingController berat_badan = TextEditingController();
  TextEditingController tinggi_badan = TextEditingController();
  TextEditingController lingkar_kepala = TextEditingController();
  TextEditingController tinggi_badan_ibu = TextEditingController();
  TextEditingController tinggi_badan_ayah = TextEditingController();

  bool isClicked = false;

  // List<String> _genders = ['Laki - Laki', 'Perempuan'];
  String? _selectedGender;
  String? _selectedPrematur;
  String? _selectedAllergy;

  List<String> _blood = ['Pilih Golongan Darah', 'A', 'B', 'O', 'AB'];
  String? _selectedBloodGroup;

  TextEditingController dateinput = TextEditingController();
  //text editing controller for text field

  List<dynamic> isChildern = [];

  //image picker
  File? _imageFile;
  String? _result;
  Future<void> pickImage() async {
    final picker = await ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Gambar berhasil dipilih
      _imageFile = File(image.path);
      _result = _imageFile?.path.split('/').last;
      // Lakukan sesuatu dengan file gambar yang dipilih
    } else {
      // Gambar tidak dipilih
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.anak_id != null) {
      isChildern = jsonDecode(childernController.dataAnak.toString());

      print(isChildern);

      // Set nilai pada TextEditingControllers berdasarkan nilai dari isChildern
      nama_anak.text = isChildern[0]['nama_anak'] ?? '';
      dateinput.text = isChildern[0]['tanggal_lahir'] ?? '';
      // jenis_kelamin.text = isChildern[0]['jenis_kelamin'] ?? '';
      berat_badan.text = isChildern[0]['berat_badan'] ?? '';
      tinggi_badan.text = isChildern[0]['tinggi_badan'] ?? '';
      lingkar_kepala.text = isChildern[0]['lingkar_kepala'] ?? '';
      tinggi_badan_ibu.text = isChildern[0]['tinggi_badan_ibu'] ?? '';
      tinggi_badan_ayah.text = isChildern[0]['tinggi_badan_ayah'] ?? '';

      String gender = isChildern[0]['jenis_kelamin'] ?? '';
      if (gender == 'Laki-Laki') {
        _selectedGender = 'Laki-Laki';
      } else if (gender == 'Perempuan') {
        _selectedGender = 'Perempuan';
      }

      String prematur = isChildern[0]['prematur'] ?? '';
      if (prematur == 'Ya') {
        _selectedPrematur = 'Ya';
      } else if (prematur == 'Tidak') {
        _selectedPrematur = 'Tidak';
      }

      String alergi = isChildern[0]['alergi'] ?? '';
      if (alergi == 'Ya') {
        _selectedAllergy = 'Ya';
      } else if (alergi == 'Tidak') {
        _selectedAllergy = 'Tidak';
      }

      // dateinput.text = ""; //set the initial value of text field
      String bloodGroup = isChildern[0]['gol_darah'] ?? "Pilih Golongan Darah";
      if (_blood.contains(bloodGroup)) {
        _selectedBloodGroup = bloodGroup;
      }
    }

    _selectedBloodGroup = _blood.isNotEmpty ? _blood[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.anak_id != null ? 'Edit Akun Anak' : 'Set Profile Anda'),
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
                          child: isChildern.isNotEmpty &&
                                  isChildern[0]['photo'] != null
                              ? Image.network(
                                  "http://stantapp.pejuang-subuh.com/" +
                                      isChildern[0]['photo'],
                                  fit: BoxFit.contain,
                                )
                              : _imageFile == null
                                  ? Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.white,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image(
                                        image: FileImage(_imageFile!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          pickImage();
                        },
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
                      value: 'Laki-Laki',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value as String?;
                        });
                      },
                    ),
                    Text('Laki-Laki'),
                    SizedBox(width: 16),
                    Radio(
                      value: 'Perempuan',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value as String?;
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
                      value: 'YA',
                      groupValue: _selectedPrematur,
                      onChanged: (value) {
                        setState(() {
                          _selectedPrematur = value as String?;
                        });
                      },
                    ),
                    Text('Ya'),
                    SizedBox(width: 16),
                    Radio(
                      value: 'Tidak',
                      groupValue: _selectedPrematur,
                      onChanged: (value) {
                        setState(() {
                          _selectedPrematur = value as String?;
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
                  value: _selectedBloodGroup ?? '',
                  items: _blood.map((blood) {
                    return DropdownMenuItem(
                      value: blood,
                      child: Text(blood),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBloodGroup = value;
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
                      'Apakah anak anda Mempunyai Alergi',
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
                      value: 'YA',
                      groupValue: _selectedAllergy,
                      onChanged: (value) {
                        setState(() {
                          _selectedAllergy = value as String?;
                        });
                      },
                    ),
                    Text('Ya'),
                    SizedBox(width: 16),
                    Radio(
                      value: 'Tidak',
                      groupValue: _selectedAllergy,
                      onChanged: (value) {
                        setState(() {
                          _selectedAllergy = value as String?;
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
              sessionController.user_id.value,
              widget.anak_id,
              nama_anak.text,
              dateinput.text,
              _selectedGender.toString(),
              berat_badan.text,
              tinggi_badan.text,
              lingkar_kepala.text,
              tinggi_badan_ibu.text,
              tinggi_badan_ayah.text,
              _selectedBloodGroup.toString(),
              _selectedAllergy.toString(),
              _selectedPrematur.toString(),
              _imageFile);
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
