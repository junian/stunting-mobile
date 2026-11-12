import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:growthtracker/controller/GrowthEditorController.dart';
import 'package:growthtracker/widget/DecimalInputFormatter.dart';

class GrowthEditorPage extends StatefulWidget {
  String anakID;
  String tinggiBadanAyah;
  String tinggiBadanIbu;
  GrowthEditorPage(
      {super.key,
      required this.anakID,
      required this.tinggiBadanAyah,
      required this.tinggiBadanIbu});

  @override
  State<GrowthEditorPage> createState() => _GrowthEditorPageState();
}

class _GrowthEditorPageState extends State<GrowthEditorPage> {
  var tambahPertumbuhanAnak = Get.put(GrowthEditorController());

  TextEditingController dateinput = TextEditingController();

  bool _isSaving = false;
  final Map<String, String> _errors = {};

  Future<void> _pickImage(ImageSource source) async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: source);

      if (pickedFile != null) {
        // Get the selected image file
        File pickedImageFile = File(pickedFile.path);

        setState(() {
          tambahPertumbuhanAnak.pickedImage = pickedImageFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  double _toDouble(String value) =>
      double.parse(value.trim().replaceAll(',', '.'));

  void _clearError(String field) {
    if (_errors.containsKey(field)) {
      setState(() => _errors.remove(field));
    }
  }

  void _validateNumber(
    Map<String, String> errors,
    String field,
    String value, {
    required double min,
    required double max,
  }) {
    final raw = value.trim().replaceAll(',', '.');
    if (raw.isEmpty) {
      errors[field] = 'validation_required'.tr;
      return;
    }
    final number = double.tryParse(raw);
    if (number == null) {
      errors[field] = 'validation_number'.tr;
    } else if (number < min || number > max) {
      errors[field] = 'validation_range'.tr;
    }
  }

  Future<void> _save() async {
    final errors = <String, String>{};

    if (dateinput.text.trim().isEmpty) {
      errors['date'] = 'validation_required'.tr;
    } else {
      final date = DateTime.tryParse(dateinput.text.trim());
      if (date == null) {
        errors['date'] = 'validation_date'.tr;
      } else if (date.isAfter(DateTime.now())) {
        errors['date'] = 'validation_date_future'.tr;
      }
    }

    _validateNumber(errors, 'weight', tambahPertumbuhanAnak.beratBadan.text,
        min: 0.5, max: 60);
    _validateNumber(errors, 'height', tambahPertumbuhanAnak.tinggiBadan.text,
        min: 20, max: 200);
    _validateNumber(errors, 'head', tambahPertumbuhanAnak.lingkarKepala.text,
        min: 20, max: 70);

    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
    });

    if (errors.isNotEmpty) {
      return;
    }

    setState(() => _isSaving = true);

    final saved = await tambahPertumbuhanAnak.addPertumbuhanAnak(
        anakID: widget.anakID,
        selectedDate: dateinput.text,
        pickedImage: tambahPertumbuhanAnak.pickedImage,
        beratBadan: _toDouble(tambahPertumbuhanAnak.beratBadan.text),
        tinggiBadan: _toDouble(tambahPertumbuhanAnak.tinggiBadan.text),
        lingkarKepala: _toDouble(tambahPertumbuhanAnak.lingkarKepala.text),
        tinggiBadanIbu: widget.tinggiBadanIbu,
        tinggiBadanAyah: widget.tinggiBadanAyah);

    if (!saved) {
      if (mounted) {
        setState(() => _isSaving = false);
      }
      Get.snackbar('warning'.tr, 'save_failed'.tr);
      return;
    }

    Get.back();
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
        title: Text('add_growth_data'.tr),
      ),
      floatingActionButton: GestureDetector(
        onTap: _isSaving ? null : _save,
        child: Container(
            alignment: Alignment.center,
            width: width * 0.9,
            height: height * 0.07,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              shape: BoxShape.rectangle,
              color: Colors.blue,
            ),
            child: _isSaving
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    "save".tr,
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
                      'growth_date'.tr,
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
                  controller: dateinput, //editing controller of this TextField
                  decoration: InputDecoration(
                    hintText: 'growth_date'.tr,
                    errorText: _errors['date'],
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
                        lastDate: DateTime.now());

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
                        _errors.remove('date');
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
                            'weight_kg'.tr,
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
                          controller: tambahPertumbuhanAnak.beratBadan,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [DecimalInputFormatter()],
                          onChanged: (_) => _clearError('weight'),
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            hintText: 'example_weight'.tr,
                            errorText: _errors['weight'],
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
                            'height_cm'.tr,
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
                          controller: tambahPertumbuhanAnak.tinggiBadan,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [DecimalInputFormatter()],
                          onChanged: (_) => _clearError('height'),
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            hintText: 'example_height'.tr,
                            errorText: _errors['height'],
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
                            'head_cm'.tr,
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
                          controller: tambahPertumbuhanAnak.lingkarKepala,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [DecimalInputFormatter()],
                          onChanged: (_) => _clearError('head'),
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.black),
                            hintText: 'example_height'.tr,
                            errorText: _errors['head'],
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
                      // Action when the upload photo button is pressed
                      _pickImage(ImageSource.gallery);
                    },
                    child: DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        color: Colors.blue,
                        radius: Radius.circular(20),
                        padding: EdgeInsets.all(3),
                      ),
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
                              'upload_photo'.tr,
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
                  child: tambahPertumbuhanAnak.pickedImage == null
                      ? SizedBox() // Show an empty placeholder if no image has been selected
                      : Image.file(tambahPertumbuhanAnak.pickedImage!),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
