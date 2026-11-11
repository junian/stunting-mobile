import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stantapp/controller/ChildrenController.dart';
import 'package:stantapp/controller/SessionController.dart';
import 'HomePage2.dart';

class AddAccountChildernPage extends StatefulWidget {
  var anak_id;
  AddAccountChildernPage({super.key, required this.anak_id});

  @override
  State<AddAccountChildernPage> createState() => _AddAccountChildernPageState();
}

class _AddAccountChildernPageState extends State<AddAccountChildernPage> {
  var childernController = Get.put(ChildrenController());
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
    _selectedBloodGroup = _blood.isNotEmpty ? _blood[0] : null;

    if (widget.anak_id != null) {
      isChildern = jsonDecode(childernController.dataAnak.toString());

      // Set the TextEditingControllers values based on isChildern
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
      String bloodGroup = isChildern[0]['gol_darah'] ?? "";
      if (_blood.contains(bloodGroup)) {
        _selectedBloodGroup = bloodGroup;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.anak_id != null ? 'edit_child_account'.tr : 'set_profile'.tr),
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
                        options: CircularDottedBorderOptions(
                          color: Colors.blue,
                          strokeWidth: 1,
                          padding: EdgeInsets.all(5),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color.fromARGB(255, 194, 192, 192),
                          child: image == null
                              ? isChildern.isNotEmpty &&
                                      isChildern[0]['photo'] != null
                                  ? ClipOval(
                                      child: Image.network(
                                        "https://mystantapp.siuinsa.com/" +
                                            isChildern[0]['photo'],
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.white,
                                    )
                              : ClipOval(
                                  child: Image(
                                    image: FileImage(image!),
                                    height: 60,
                                    width: 60,
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
                          _pickImage();
                        },
                        child: Text(
                          'upload_photo'.tr,
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
                      'full_name'.tr,
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
                    hintText: 'full_name'.tr,
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
                      'birth_date'.tr,
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
                    hintText: 'birth_date'.tr,
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
                          _selectedGender = value as String?;
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
                          _selectedGender = value as String?;
                        });
                      },
                    ),
                    Text('female'.tr),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'birth_data'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                // Center(
                //   child: GestureDetector(
                //     onTap: () {
                //       // Action when the upload photo button is pressed
                //     },
                //     child: DottedBorder(
                //       borderType: BorderType.RRect,
                //       color: Colors.blue,
                //       radius: Radius.circular(20),
                //       padding: EdgeInsets.all(1),
                //       child: Container(
                //         width: 300,
                //         padding:
                //             EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                //         decoration: BoxDecoration(
                //           color: Color.fromARGB(255, 220, 232, 243),
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Icon(
                //               Icons.add,
                //               color: Colors.blue,
                //             ),
                //             SizedBox(width: 8),
                //             Text(
                //               'Unggah Foto',
                //               style: TextStyle(
                //                 color: Colors.blue,
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 16,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'is_premature'.tr,
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
                    Text('yes'.tr),
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
                    Text('no'.tr),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'birth_weight_label'.tr,
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
                    hintText: 'birth_weight_hint'.tr,
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
                      'birth_height_label'.tr,
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
                    hintText: 'birth_height_hint'.tr,
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
                      'birth_head_label'.tr,
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
                    hintText: 'birth_head_label'.tr,
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
                  'additional_profile'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'blood_group'.tr,
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
                      child: Text(blood == 'Pilih Golongan Darah'
                          ? 'select_blood_group'.tr
                          : blood),
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
                      'has_allergy'.tr,
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
                    Text('yes'.tr),
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
                    Text('no'.tr),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'parent_height'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'parent_height_note'.tr,
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
                      'mother_height'.tr,
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
                    hintText: 'mother_height'.tr,
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
                      'father_height'.tr,
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
                    hintText: 'father_height'.tr,
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
              image);
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
              "save".tr,
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
