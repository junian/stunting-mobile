import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:stantapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:stantapp/helper/Constant.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class JadwalVaksinasiIDAIController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("Start downloading file from the internet!");
    try {
      final url = "https://stantapp.alalanusantara.com/jadwal-imunisasi.pdf";
      final filename = url.substring(url.lastIndexOf("/") + 1);

      var response = await _dio.get(url,
          options: Options(responseType: ResponseType.bytes));
      var bytes = response.data;
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error downloading file!');
    }

    return completer.future;
  }
}
