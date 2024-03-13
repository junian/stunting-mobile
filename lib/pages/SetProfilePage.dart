import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stantapp/controller/AuthController.dart';
import 'package:stantapp/controller/RegionController.dart';
import 'package:stantapp/controller/SessionController.dart';
import 'package:stantapp/models/MGetCity.dart';
import 'package:stantapp/models/MGetKecamatan.dart';
import 'package:stantapp/models/MGetKelurahan.dart';
import 'package:stantapp/models/MGetProvince.dart';
import 'package:stantapp/pages/HomePage.dart';
import 'package:stantapp/widget/BottomNavbar.dart';

enum Gender { male, female }

class SetProfilePage extends StatefulWidget {
  // List<dynamic> province = [];
  SetProfilePage({
    super.key,
  });

  @override
  State<SetProfilePage> createState() => _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  var sessionController = Get.put(SessionController());
  var authController = Get.put(AuthController());
  var regionController = Get.put(RegionController());
  bool isClicked = false;

  final TextEditingController nama_orang_tua = TextEditingController();
  final TextEditingController alamat = TextEditingController();
  final TextEditingController pendapatan = TextEditingController();

  String? idProv;
  String? idCity;
  String? idKecamatan;
  String? idKelurahan;
  String? pendidikan;
  final dio.Dio _dio = dio.Dio();

  List<String> _genders = ['Male', 'Female'];
  String? _selectedGender;

  // List<Map<String, dynamic>> _provinces = []; // List<String> _provinces = ['Provinsi A', 'Provinsi B', 'Provinsi C'];
  // String? _selectedProvince = '1';

  List<String> _lastEducation = [
    'Pilih Pendidikan Terakhir',
    'SD',
    'SMP',
    'SMA',
    'S1',
    'S2',
    'S3',
  ];
  String? _selectedLastEducation;
  String? _selectedLastEducationMother;

  List<String> _workType = [
    'Pilih Pendidikan Terakhir',
    'PNS',
    'Wiraswasta',
    'Swasta',
  ];
  String? _selectedWorkType;

  File? image;
  Future<void> _pickImage() async {
    try {
      final imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Mengambil file gambar yang dipilih
        File imageTemporary = File(image.path);

        setState(() {
          this.image = imageTemporary;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    authController.isParent;

    _selectedLastEducation =
        _lastEducation.isNotEmpty ? _lastEducation[0] : null;
    _selectedLastEducationMother =
        _lastEducation.isNotEmpty ? _lastEducation[0] : null;
    _selectedWorkType = _workType.isNotEmpty ? _workType[0] : null;

    // Set nilai pada TextEditingControllers berdasarkan nilai dari isParent
    if (authController.isParent.isNotEmpty) {
      nama_orang_tua.text = authController.isParent[0]['nama_orang_tua'] ?? '';
      alamat.text = authController.isParent[0]['alamat'] ?? '';
      pendapatan.text = authController.isParent[0]['pendapatan'] ?? '';
      String gender = authController.isParent[0]['jenis_kelamin'] ?? '';
      if (gender == 'Laki-Laki') {
        _selectedGender = 'Laki-Laki';
      } else if (gender == 'Perempuan') {
        _selectedGender = 'Perempuan';
      }

      String education = authController.isParent[0]['pendidikan'] ?? "";
      if (_lastEducation.contains(education)) {
        _selectedLastEducation = education;
      }

      String workType = authController.isParent[0]['pekerjaan'] ?? "";
      if (_workType.contains(workType)) {
        _selectedWorkType = workType;
      }
    }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: image !=
                          null // Cek apakah image tidak null (berarti gambar dari galeri telah dipilih)
                      ? ClipOval(
                          // Jika ada gambar dari galeri, tampilkan gambar menggunakan ClipOval
                          child: Image(
                            image: FileImage(image!),
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        )
                      : authController.isParent.isNotEmpty &&
                              authController.isParent[0]['photo'] != null
                          ? ClipOval(
                              child: Image.network(
                                "https://www.bebasstunting.com/" +
                                    authController.isParent[0]['photo'],
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipOval(
                              child: Container(
                                height: 60,
                                width: 60,
                                color: Colors.grey,
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                  title: GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: Text(
                      'Unggah Foto Anda',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                      ),
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
                        controller: nama_orang_tua,
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
                      // SizedBox(height: 24),
                      // Row(
                      //   children: [
                      //     Text(
                      //       'Email',
                      //       style: TextStyle(),
                      //     ),
                      //     Text(
                      //       '*',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.red,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // TextField(
                      //   decoration: InputDecoration(
                      //     hintText: 'Masukkan Email',
                      //     border: UnderlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: isClicked
                      //             ? const Color.fromARGB(255, 188, 180, 179)
                      //             : Colors.grey,
                      //         width: 2.0,
                      //       ),
                      //     ),
                      //     focusedBorder: UnderlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: Colors.blue,
                      //         width: 2.0,
                      //       ),
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     setState(() {
                      //       isClicked = true;
                      //     });
                      //   },
                      //   onSubmitted: (value) {
                      //     setState(() {
                      //       isClicked = false;
                      //     });
                      //   },
                      // ),
                      // SizedBox(height: 24),
                      // Row(
                      //   children: [
                      //     Text(
                      //       'No Handphone',
                      //       style: TextStyle(),
                      //     ),
                      //     Text(
                      //       '*',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.red,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // TextField(
                      //   decoration: InputDecoration(
                      //     hintText: 'Masukkan No Handphone',
                      //     border: UnderlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: isClicked
                      //             ? const Color.fromARGB(255, 188, 180, 179)
                      //             : Colors.grey,
                      //         width: 2.0,
                      //       ),
                      //     ),
                      //     focusedBorder: UnderlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: Colors.blue,
                      //         width: 2.0,
                      //       ),
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     setState(() {
                      //       isClicked = true;
                      //     });
                      //   },
                      //   onSubmitted: (value) {
                      //     setState(() {
                      //       isClicked = false;
                      //     });
                      //   },
                      // ),
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
                            value: 'Laki-Laki',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
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
                                _selectedGender = value;
                              });
                            },
                          ),
                          Text('Perempuan'),
                        ],
                      ),
                      SizedBox(height: 24),
                      authController.isParent.isEmpty
                          ? Container(
                              child: Column(
                                children: [
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
                                  DropdownSearch<MGetProvince>(
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    onChanged: (value) =>
                                        idProv = value?.provinceId,
                                    dropdownBuilder: (context, selectedItem) =>
                                        Text(selectedItem?.provinceName ??
                                            "Belum Memilih Provinsi"),
                                    popupItemBuilder:
                                        ((context, item, isSelected) =>
                                            ListTile(
                                              title: Text(item.provinceName),
                                            )),
                                    onFind: (text) async {
                                      var response = await _dio.get(
                                          "https://www.bebasstunting.com/api/getProvince");
                                      List<MGetProvince> allNameProvince = [];

                                      if (response.statusCode != 200) {
                                        return [];
                                      } else {
                                        List allProvince = response.data;

                                        allProvince.forEach((element) {
                                          allNameProvince.add(MGetProvince(
                                              provinceId:
                                                  element['province_id'],
                                              provinceName:
                                                  element['province_name'],
                                              locationid: element['locationid'],
                                              status: element['status']));
                                        });
                                        return allNameProvince;
                                      }
                                    },
                                  ),
                                  SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Text(
                                        'Kota/Kabupaten',
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
                                  DropdownSearch<MGetCity>(
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    onChanged: (value) =>
                                        idCity = value?.cityId,
                                    dropdownBuilder: (context, selectedItem) =>
                                        Text(selectedItem?.cityName ??
                                            "Belum Memilih Kota/Kabupaten"),
                                    popupItemBuilder:
                                        ((context, item, isSelected) =>
                                            ListTile(
                                              title: Text(item.cityName),
                                            )),
                                    onFind: (text) async {
                                      dio.FormData formData =
                                          dio.FormData.fromMap({
                                        'province_id': idProv,
                                      });
                                      var response = await _dio.post(
                                          "https://www.bebasstunting.com/api/getCity",
                                          data: formData);
                                      // print(response.data);
                                      List<MGetCity> allNameCity = [];

                                      if (response.statusCode != 200) {
                                        return [];
                                      } else {
                                        List allCity = response.data;

                                        allCity.forEach((element) {
                                          allNameCity.add(MGetCity(
                                            cityId: element['city_id'],
                                            cityName: element['city_name'],
                                            provinceId: element['province_id'],
                                          ));
                                        });
                                        return allNameCity;
                                      }
                                    },
                                  ),
                                  SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Text(
                                        'Kecamatan',
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
                                  DropdownSearch<MGetKecamatan>(
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    onChanged: (value) =>
                                        idKecamatan = value?.kecamatanId,
                                    dropdownBuilder: (context, selectedItem) =>
                                        Text(selectedItem?.kecamatanName ??
                                            "Belum Memilih Kecamatan"),
                                    popupItemBuilder:
                                        ((context, item, isSelected) =>
                                            ListTile(
                                              title: Text(item.kecamatanName),
                                            )),
                                    onFind: (text) async {
                                      dio.FormData formData =
                                          dio.FormData.fromMap({
                                        'city_id': idCity,
                                      });
                                      var response = await _dio.post(
                                          "https://www.bebasstunting.com/api/getKecamatan",
                                          data: formData);
                                      // print(response.data);
                                      List<MGetKecamatan> allNameKecamatan = [];

                                      if (response.statusCode != 200) {
                                        return [];
                                      } else {
                                        List allKecamatan = response.data;

                                        allKecamatan.forEach((element) {
                                          allNameKecamatan.add(MGetKecamatan(
                                              kecamatanId:
                                                  element['kecamatan_id'],
                                              kecamatanName:
                                                  element['kecamatan_name'],
                                              cityId: element['city_id']));
                                        });
                                        return allNameKecamatan;
                                      }
                                    },
                                  ),
                                  SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Text(
                                        'Kelurahan/Desa',
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
                                  DropdownSearch<MGetKelurahan>(
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    onChanged: (value) =>
                                        idKelurahan = value?.kelurahanId,
                                    dropdownBuilder: (context, selectedItem) =>
                                        Text(selectedItem?.kelurahanName ??
                                            "Belum Memilih Kelurahan/Desa"),
                                    popupItemBuilder:
                                        ((context, item, isSelected) =>
                                            ListTile(
                                              title: Text(item.kelurahanName),
                                            )),
                                    onFind: (text) async {
                                      dio.FormData formData =
                                          dio.FormData.fromMap({
                                        'kecamatan_id': idKecamatan,
                                      });
                                      var response = await _dio.post(
                                          "https://www.bebasstunting.com/api/getKelurahan",
                                          data: formData);
                                      // print(response.data);
                                      List<MGetKelurahan> allNameKelurahan = [];

                                      if (response.statusCode != 200) {
                                        return [];
                                      } else {
                                        List allKelurahan = response.data;

                                        allKelurahan.forEach((element) {
                                          allNameKelurahan.add(MGetKelurahan(
                                              kelurahanId:
                                                  element['kelurahan_id'],
                                              kelurahanName:
                                                  element['kelurahan_name'],
                                              kecamatanId:
                                                  element['kecamatan_id']));
                                        });
                                        return allNameKelurahan;
                                      }
                                    },
                                  ),
                                  SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Text(
                                        'Alamat',
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
                            )
                          : Container(),
                      TextField(
                        controller: alamat,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Alamat',
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
                            'Pendidikan',
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
                        value: _selectedLastEducation ?? '',
                        items: _lastEducation.map((lastEducation) {
                          return DropdownMenuItem(
                            value: lastEducation,
                            child: Text(lastEducation),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLastEducation = value;
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
                      // SizedBox(height: 24),
                      // Row(
                      //   children: [
                      //     Text(
                      //       'Pendidikan Terakhir Ibu',
                      //       style: TextStyle(),
                      //     ),
                      //     Text(
                      //       '*',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.red,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // DropdownButtonFormField(
                      //   value: _selectedLastEducationMother ?? '',
                      //   items: _lastEducation.map((lastEducation) {
                      //     return DropdownMenuItem(
                      //       value: lastEducation,
                      //       child: Text(lastEducation),
                      //     );
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _selectedLastEducationMother = value;
                      //     });
                      //   },
                      //   decoration: InputDecoration(
                      //     border: UnderlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.black),
                      //     ),
                      //     focusedBorder: UnderlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.blue),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            'Pekerjaan',
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
                        value: _selectedWorkType ?? '',
                        items: _workType.map((work) {
                          return DropdownMenuItem(
                            value: work,
                            child: Text(work),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedWorkType = value;
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
                      // SizedBox(height: 24),
                      // Row(
                      //   children: [
                      //     Text(
                      //       'Pekerjaan Ibu',
                      //       style: TextStyle(),
                      //     ),
                      //     Text(
                      //       '*',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.red,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // DropdownButtonFormField(
                      //   value: _selectedWorkType ?? '',
                      //   items: _workType.map((work) {
                      //     return DropdownMenuItem(
                      //       value: work,
                      //       child: Text(work),
                      //     );
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _selectedWorkType = value;
                      //     });
                      //   },
                      //   decoration: InputDecoration(
                      //     border: UnderlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.black),
                      //     ),
                      //     focusedBorder: UnderlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.blue),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            'Pendapatan',
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
                        controller: pendapatan,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Pendapatan Perkapita',
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
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Aksi ketika tombol submit ditekan
                          if (authController.isParent.isNotEmpty) {
                            authController.registerOrangtua(
                                authController.isParent[0]['orang_tua_id'],
                                sessionController.user_id.value,
                                nama_orang_tua.text,
                                _selectedGender.toString(),
                                authController.isParent[0]['kecamatan_id'],
                                authController.isParent[0]['kelurahan_id'],
                                alamat.text,
                                _selectedLastEducation.toString(),
                                _selectedWorkType.toString(),
                                pendapatan.text,
                                image);
                          } else {
                            authController.registerOrangtua(
                                null,
                                sessionController.user_id.value,
                                nama_orang_tua.text,
                                _selectedGender.toString(),
                                idKecamatan.toString(),
                                idKelurahan.toString(),
                                alamat.text,
                                _selectedLastEducation.toString(),
                                _selectedWorkType.toString(),
                                pendapatan.text,
                                image);
                          }
                          // Anda dapat menambahkan logika atau tindakan lain di sini
                        },
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 30.0),
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
      ),
    );
  }
}
