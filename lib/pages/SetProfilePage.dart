import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stantapp/controller/RegionController.dart';
import 'package:stantapp/pages/HomePage.dart';
import 'package:stantapp/widget/BottomNavbar.dart';

enum Gender { male, female }

class SetProfilePage extends StatefulWidget {
  List<dynamic> province = [];
  SetProfilePage({super.key, required this.province});

  @override
  State<SetProfilePage> createState() => _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  var regionController = Get.put(RegionController());
  bool isClicked = false;

  List<String> _genders = ['Male', 'Female'];
  String? _selectedGender;

  // List<Map<String, dynamic>> _provinces = []; // List<String> _provinces = ['Provinsi A', 'Provinsi B', 'Provinsi C'];
  String? _selectedProvince = '1';
  String? _selectedCity = '1';

  List<String> _lastEducation = [
    'Pilih Pendidikan Terakhir',
    'SD',
    'SMP',
    'SMA',
    'S1',
    'S2',
    'S3',
  ];
  String? _selectedLastEducationFather;
  String? _selectedLastEducationMother;

  List<String> _workType = [
    'Pilih Pendidikan Terakhir',
    'PNS',
    'Wiraswasta',
    'Swasta',
  ];
  String? _selectedWorkType;

  @override
  void initState() {
    super.initState();
    // regionController.getProvince();
    _selectedProvince = regionController.provinces.isNotEmpty
        ? regionController.provinces[0]['province_name']
        : '1';
    _selectedLastEducationFather =
        _lastEducation.isNotEmpty ? _lastEducation[0] : null;
    _selectedLastEducationMother =
        _lastEducation.isNotEmpty ? _lastEducation[0] : null;
    _selectedWorkType = _workType.isNotEmpty ? _workType[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    print(regionController.city);

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
                            'No Handphone',
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
                          hintText: 'Masukkan No Handphone',
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
                      Obx(
                        () => DropdownButtonFormField(
                          value: _selectedProvince ?? "1",
                          items: widget.province.map((province) {
                            return DropdownMenuItem(
                              value: province['province_id'].toString(),
                              child: Text(province['province_name'].toString()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              if (_selectedProvince == null) {
                                _selectedProvince = "1";
                              } else {
                                regionController.getCity(value.toString());
                                _selectedProvince = value;
                              }
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
                      Obx(
                        () => DropdownButtonFormField(
                          value: _selectedCity ?? '1',
                          items: regionController.city.map((city) {
                            return DropdownMenuItem(
                              value: city['city_id'].toString(),
                              child: Text(city['city_name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCity = value;
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
                      ),

                      // SizedBox(height: 24),
                      // Row(
                      //   children: [
                      //     Text(
                      //       'Kecamatan',
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
                      //   value: _selectedProvince ?? '',
                      //   items: regionController.provinces.map((province) {
                      //     return DropdownMenuItem(
                      //       value: province['province_id'].toString(),
                      //       child: Text(province['province_name']),
                      //     );
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _selectedProvince = value;
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
                      // SizedBox(height: 24),
                      // Row(
                      //   children: [
                      //     Text(
                      //       'Kelurahan/Desa',
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
                      //   value: _selectedProvince ?? '',
                      //   items: regionController.provinces.map((province) {
                      //     return DropdownMenuItem(
                      //       value: province['province_id'].toString(),
                      //       child: Text(province['province_name']),
                      //     );
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _selectedProvince = value;
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
                            'Pendidikan Terakhir Ayah',
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
                        value: _selectedLastEducationFather ?? '',
                        items: _lastEducation.map((lastEducation) {
                          return DropdownMenuItem(
                            value: lastEducation,
                            child: Text(lastEducation),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLastEducationFather = value;
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
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            'Pendidikan Terakhir Ibu',
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
                        value: _selectedLastEducationMother ?? '',
                        items: _lastEducation.map((lastEducation) {
                          return DropdownMenuItem(
                            value: lastEducation,
                            child: Text(lastEducation),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLastEducationMother = value;
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
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            'Pekerjaan Ayah',
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
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            'Pekerjaan Ibu',
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
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            'Pendapatan per Kapita',
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
                          regionController.getProvince();
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
      ),
    );
  }
}
