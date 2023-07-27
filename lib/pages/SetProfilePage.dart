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
  final TextEditingController pekerjaan = TextEditingController();
  final TextEditingController pendapatan = TextEditingController();

  String? idProv;
  String? idCity;
  String? idKecamatan;
  String? idKelurahan;
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

  File? _imageFile;
  Future<void> pickImage() async {
    final picker = await ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Gambar berhasil dipilih
      _imageFile = File(image.path);
      // Lakukan sesuatu dengan file gambar yang dipilih
    } else {
      // Gambar tidak dipilih
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

    print(authController.isParent);

    // Set nilai pada TextEditingControllers berdasarkan nilai dari isChildern
    nama_orang_tua.text = authController.isParent[0]['nama_orang_tua'] ?? '';
    String gender = authController.isParent[0]['jenis_kelamin'] ?? '';
    if (gender == 'Laki-Laki') {
      _selectedGender = 'Laki-Laki';
    } else if (gender == 'Perempuan') {
      _selectedGender = 'Perempuan';
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
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://cdn.vectorstock.com/i/1000x1000/70/84/default-avatar-profile-icon-symbol-for-website-vector-46547084.webp'),
                    backgroundColor: Colors.white,
                  ),
                  title: GestureDetector(
                    onTap: () {
                      ImagePicker();
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
                        onChanged: (value) => idProv = value?.provinceId,
                        dropdownBuilder: (context, selectedItem) => Text(
                            selectedItem?.provinceName ??
                                "Belum Memilih Provinsi"),
                        popupItemBuilder: ((context, item, isSelected) =>
                            ListTile(
                              title: Text(item.provinceName),
                            )),
                        onFind: (text) async {
                          var response = await _dio.get(
                              "http://stantapp.pejuang-subuh.com/api/getProvince");
                          List<MGetProvince> allNameProvince = [];

                          if (response.statusCode != 200) {
                            return [];
                          } else {
                            List allProvince = response.data;

                            allProvince.forEach((element) {
                              allNameProvince.add(MGetProvince(
                                  provinceId: element['province_id'],
                                  provinceName: element['province_name'],
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
                        onChanged: (value) => idCity = value?.cityId,
                        dropdownBuilder: (context, selectedItem) => Text(
                            selectedItem?.cityName ??
                                "Belum Memilih Kota/Kabupaten"),
                        popupItemBuilder: ((context, item, isSelected) =>
                            ListTile(
                              title: Text(item.cityName),
                            )),
                        onFind: (text) async {
                          dio.FormData formData = dio.FormData.fromMap({
                            'province_id': idProv,
                          });
                          var response = await _dio.post(
                              "http://stantapp.pejuang-subuh.com/api/getCity",
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
                        onChanged: (value) => idKecamatan = value?.kecamatanId,
                        dropdownBuilder: (context, selectedItem) => Text(
                            selectedItem?.kecamatanName ??
                                "Belum Memilih Kecamatan"),
                        popupItemBuilder: ((context, item, isSelected) =>
                            ListTile(
                              title: Text(item.kecamatanName),
                            )),
                        onFind: (text) async {
                          dio.FormData formData = dio.FormData.fromMap({
                            'city_id': idCity,
                          });
                          var response = await _dio.post(
                              "http://stantapp.pejuang-subuh.com/api/getKecamatan",
                              data: formData);
                          // print(response.data);
                          List<MGetKecamatan> allNameKecamatan = [];

                          if (response.statusCode != 200) {
                            return [];
                          } else {
                            List allKecamatan = response.data;

                            allKecamatan.forEach((element) {
                              allNameKecamatan.add(MGetKecamatan(
                                  kecamatanId: element['kecamatan_id'],
                                  kecamatanName: element['kecamatan_name'],
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
                        onChanged: (value) => idKelurahan = value?.kelurahanId,
                        dropdownBuilder: (context, selectedItem) => Text(
                            selectedItem?.kelurahanName ??
                                "Belum Memilih Kelurahan/Desa"),
                        popupItemBuilder: ((context, item, isSelected) =>
                            ListTile(
                              title: Text(item.kelurahanName),
                            )),
                        onFind: (text) async {
                          dio.FormData formData = dio.FormData.fromMap({
                            'kecamatan_id': idKecamatan,
                          });
                          var response = await _dio.post(
                              "http://stantapp.pejuang-subuh.com/api/getKelurahan",
                              data: formData);
                          // print(response.data);
                          List<MGetKelurahan> allNameKelurahan = [];

                          if (response.statusCode != 200) {
                            return [];
                          } else {
                            List allKelurahan = response.data;

                            allKelurahan.forEach((element) {
                              allNameKelurahan.add(MGetKelurahan(
                                  kelurahanId: element['kelurahan_id'],
                                  kelurahanName: element['kelurahan_name'],
                                  kecamatanId: element['kecamatan_id']));
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
                          authController.registerOrangtua(
                              sessionController.user_id.value,
                              nama_orang_tua.text,
                              _selectedGender.toString(),
                              idKecamatan.toString(),
                              idKelurahan.toString(),
                              alamat.text,
                              _selectedLastEducation.toString(),
                              _selectedWorkType.toString(),
                              pendapatan.text,
                              _imageFile);
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
