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
        // Get the selected image file
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

    // Set the TextEditingControllers values based on isParent
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

  String _educationLabel(String value) {
    switch (value) {
      case 'Pilih Pendidikan Terakhir':
        return 'select_last_education'.tr;
      case 'SD':
        return 'edu_sd'.tr;
      case 'SMP':
        return 'edu_smp'.tr;
      case 'SMA':
        return 'edu_sma'.tr;
      case 'S1':
        return 'edu_s1'.tr;
      case 'S2':
        return 'edu_s2'.tr;
      case 'S3':
        return 'edu_s3'.tr;
      default:
        return value;
    }
  }

  String _workLabel(String value) {
    switch (value) {
      case 'Pilih Pendidikan Terakhir':
        return 'select_occupation'.tr;
      case 'PNS':
        return 'civil_servant'.tr;
      case 'Wiraswasta':
        return 'entrepreneur'.tr;
      case 'Swasta':
        return 'private_employee'.tr;
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('set_profile'.tr),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Action when the back icon is pressed
            Get.back();
            // You can add Navigator.pop or another action here
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
                          null // Check that image is not null (an image from the gallery has been selected)
                      ? ClipOval(
                          // If there is an image from the gallery, display it using ClipOval
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
                                "https://mystantapp.siuinsa.com/" +
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
                      'upload_your_photo'.tr,
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
                            'parent_full_name'.tr,
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
                          hintText: 'parent_full_name_hint'.tr,
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
                            'gender'.tr,
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
                          Text('male'.tr),
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
                          Text('female'.tr),
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
                                        'province'.tr,
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
                                    mode: Mode.custom,
                                    //showSearchBox: true,
                                    compareFn: (item1, item2) => item1.provinceId == item2.provinceId,
                                    onChanged: (value) =>
                                        idProv = value?.provinceId,
                                    dropdownBuilder: (context, selectedItem) =>
                                        Text(selectedItem?.provinceName ??
                                            'select_province'.tr),
                                    popupProps: PopupProps.menu(
                                      menuProps: MenuProps(align: MenuAlign.bottomCenter),
                                      fit: FlexFit.loose,
                                      itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          title: Text(item.provinceName),
                                        )
                                      ),
                                    ),
                                    items: (text, loadProps) async {
                                      var response = await _dio.get(
                                          "https://mystantapp.siuinsa.com/api/getProvince");
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
                                        'city'.tr,
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
                                    mode: Mode.custom,
                                    // showSearchBox: true,
                                    compareFn: (x, y) => x.cityId == y.cityId,
                                    onChanged: (value) =>
                                        idCity = value?.cityId,
                                    dropdownBuilder: (context, selectedItem) =>
                                        Text(selectedItem?.cityName ??
                                            'select_city'.tr),
                                    popupProps: PopupProps.menu(
                                      menuProps: MenuProps(align: MenuAlign.bottomCenter),
                                      fit: FlexFit.loose,
                                      itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            title: Text(item.cityName),
                                          )
                                      ),
                                    ),
                                    items: (text, loadProps) async {
                                      dio.FormData formData =
                                          dio.FormData.fromMap({
                                        'province_id': idProv,
                                      });
                                      var response = await _dio.post(
                                          "https://mystantapp.siuinsa.com/api/getCity",
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
                                        'district'.tr,
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
                                    mode: Mode.custom,
                                    //showSearchBox: true,
                                    compareFn: (x,y)=>x.kecamatanId == y.kecamatanId,
                                    onChanged: (value) =>
                                        idKecamatan = value?.kecamatanId,
                                    dropdownBuilder: (context, selectedItem) =>
                                        Text(selectedItem?.kecamatanName ??
                                            'select_district'.tr),
                                    popupProps: PopupProps.menu(
                                      menuProps: MenuProps(align: MenuAlign.bottomCenter),
                                      fit: FlexFit.loose,
                                      itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            title: Text(item.kecamatanName),
                                          )
                                      ),
                                    ),
                                    items: (text, loadProps) async {
                                      dio.FormData formData =
                                          dio.FormData.fromMap({
                                        'city_id': idCity,
                                      });
                                      var response = await _dio.post(
                                          "https://mystantapp.siuinsa.com/api/getKecamatan",
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
                                        'village'.tr,
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
                                    mode: Mode.custom,
                                    // showSearchBox: true,
                                    compareFn: (x, y) => x.kelurahanId == y.kelurahanId,
                                    onChanged: (value) =>
                                        idKelurahan = value?.kelurahanId,
                                    dropdownBuilder: (context, selectedItem) =>
                                        Text(selectedItem?.kelurahanName ??
                                            'select_village'.tr),
                                    popupProps: PopupProps.menu(
                                      menuProps: MenuProps(align: MenuAlign.bottomCenter),
                                      fit: FlexFit.loose,
                                      itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            title: Text(item.kelurahanName),
                                          )
                                      ),
                                    ),
                                    items: (text, loadProps) async {
                                      dio.FormData formData =
                                          dio.FormData.fromMap({
                                        'kecamatan_id': idKecamatan,
                                      });
                                      var response = await _dio.post(
                                          "https://mystantapp.siuinsa.com/api/getKelurahan",
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
                                        'address'.tr,
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
                          hintText: 'address_hint'.tr,
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
                            'education'.tr,
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
                            child: Text(_educationLabel(lastEducation)),
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
                            'occupation'.tr,
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
                            child: Text(_workLabel(work)),
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
                            'income'.tr,
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
                          hintText: 'income_hint'.tr,
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
                          // Action when the submit button is pressed
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
                          // You can add logic or another action here
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
                              'save'.tr,
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
