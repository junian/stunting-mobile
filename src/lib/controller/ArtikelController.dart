import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:stantapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:stantapp/helper/Constant.dart';
import 'package:stantapp/models/MGetArtikel.dart';
import 'package:stantapp/models/MGetArtikelKategori.dart';

class ArtikelController extends GetxController {
  final api = helper.api;
  final dio.Dio _dio = dio.Dio();

  RxList<MGetArtikelKategori> kategori = RxList<MGetArtikelKategori>([]);
  RxList<MGetArtikel> artikel = RxList<MGetArtikel>([]);

  Future<String> getArtikel() async {
    artikel.clear();

    try {
      final response = await _dio.post('$api/getArtikel');
      if (response.statusCode == 200) {
        List allArtikel = response.data;

        allArtikel.forEach((element) {
          artikel.add(MGetArtikel(
              thumbnail: element['thumbnail'],
              artikelId: element['artikel_id'],
              artikelKategoriId: element['artikel_kategori_id'],
              judul: element['judul'],
              konten: element['konten'],
              createdBy: element['created_by'],
              createdDate: element['created_date'],
              namaKategori: element['nama_kategori'],
              fullname: element['fullname']));
        });

        return response.data;
      } else {
        print("erorr");
      }
    } catch (e) {
      print(e);
    }
    return 'Data yang diperoleh dari sumber eksternal';
  }

  Future<String> getArtikelKategori() async {
    kategori.clear();
    try {
      final response = await _dio.post('$api/getArtikelKategori');
      if (response.statusCode == 200) {
        List allKategori = response.data;

        allKategori.forEach((element) {
          kategori.add(MGetArtikelKategori(
            artikelKategoriId: element['artikel_kategori_id'],
            namaKategori: element['nama_kategori'],
            isActive: element['is_active'],
            createdBy: element['created_by'],
            createdDate: element['created_date'],
          ));
        });
        return response.data;
      } else {
        print("erorr");
      }
    } catch (e) {
      print(e);
    }

    return 'Data yang diperoleh dari sumber eksternal';
  }
}
