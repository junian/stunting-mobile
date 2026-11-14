import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:growthtracker/helper/Constant.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class VaccinationScheduleByIdaiController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();

  Future<File> createFileOfPdfUrl() async {
    final url = "https://mystantapp.siuinsa.com/jadwal-imunisasi.pdf";
    final filename = url.substring(url.lastIndexOf("/") + 1);
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$filename");

    try {
      var response = await _dio.get(url,
          options: Options(responseType: ResponseType.bytes));
      await file.writeAsBytes(response.data, flush: true);
      return file;
    } catch (e) {
      // Offline: fall back to the copy downloaded on a previous visit.
      if (await file.exists()) {
        return file;
      }
      throw Exception('Error downloading file!');
    }
  }
}
