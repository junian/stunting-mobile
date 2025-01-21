import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stantapp/pages/HomePage.dart';
import 'package:stantapp/controller/RegionController.dart';
import 'package:stantapp/widget/BottomNavbar.dart';

enum Gender { male, female }

class SetProfilePage2 extends StatefulWidget {
  const SetProfilePage2({super.key});

  @override
  State<SetProfilePage2> createState() => _SetProfilePage2State();
}

class _SetProfilePage2State extends State<SetProfilePage2> {
  var regionalController = Get.put(RegionController());
  bool isClicked = false;

  List<String> _genders = ['Male', 'Female'];
  String? _selectedGender;

  String? _selectedProvince;

  @override
  void initState() {
    super.initState();
    regionalController.getProvince();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      'https://cdn.vectorstock.com/i/1000x1000/70/84/default-avatar-profile-icon-symbol-for-website-vector-46547084.webp'),
                  backgroundColor: Colors.white,
                ),
                title: Text(
                  'Unggah Foto Anda',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          'Nama Lengkap Orang tua',
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
                      decoration: InputDecoration(
                        hintText: 'Masukkan Nama Orang tua',
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
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          'Email',
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
                      decoration: InputDecoration(
                        hintText: 'Masukkan Email',
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
                    SizedBox(height: 24),
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
                          value: 'Male',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        Text('Male'),
                        SizedBox(width: 16),
                        Radio(
                          value: 'Female',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        Text('Female'),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          'Provinsi',
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
                      value: _selectedProvince,
                      items: regionalController.provinces.map((province) {
                        return DropdownMenuItem(
                          value: province['province_id'].toString(),
                          child: Text(province['province_name'].toString()),
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
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Aksi ketika tombol submit ditekan
                        Get.to(
                          BottomNavbar(),
                        );
                        // Anda dapat menambahkan logika atau tindakan lain di sini
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 82, 163, 230),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Simpan',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
