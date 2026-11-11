import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthtracker/helper/AgeHelper.dart';
import 'package:growthtracker/services/LocalStore.dart';

/// Creates, reads and deletes the growth records stored on this device.
class GrowthEditorController extends GetxController {
  final LocalStore _store = LocalStore();

  File? pickedImage;
  TextEditingController beratBadan = TextEditingController();
  TextEditingController tinggiBadan = TextEditingController();
  TextEditingController lingkarKepala = TextEditingController();

  Future<void> addPertumbuhanAnak({
    required String anakID,
    required String selectedDate,
    File? pickedImage,
    required double beratBadan,
    required double tinggiBadan,
    required double lingkarKepala,
    required String tinggiBadanIbu,
    required String tinggiBadanAyah,
  }) async {
    try {
      String? photoPath;
      if (pickedImage != null) {
        photoPath = await _store.savePhoto(pickedImage);
      }

      final measuredAt = _parse(selectedDate) ?? DateTime.now();
      final record = <String, dynamic>{
        'pertumbuhan_anak_id': _store.newId('pertumbuhan_'),
        'anak_id': anakID,
        'tanggal_pertumbuhan': selectedDate,
        'berat_badan': beratBadan,
        'tinggi_badan': tinggiBadan,
        'lingkar_kepala': lingkarKepala,
        'tinggi_badan_ibu': tinggiBadanIbu,
        'tinggi_badan_ayah': tinggiBadanAyah,
        'photo': photoPath,
        'created_date': DateTime.now().toIso8601String(),
        'umur': ageLabel(
            _parse((await _store.childById(anakID))?['tanggal_lahir']),
            measuredAt),
        // Growth status needs the WHO reference tables, which this app does
        // not carry offline yet.
        'status_pertumbuhan_berat': null,
        'status_pertumbuhan_tinggi': null,
        'status_pertumbuhan_lingkar_kepala': null,
      };

      final records = await _store.growthRecords();
      records.add(record);
      await _store.saveGrowthRecords(records);
    } catch (e) {
      print('Could not save growth record: $e');
    }
  }

  Future<Map<String, dynamic>?> editPertumbuhanAnak(
      String pertumbuhanAnakId) async {
    final records = await _store.growthRecords();
    for (final record in records) {
      if (record['pertumbuhan_anak_id'] == pertumbuhanAnakId) {
        return Map<String, dynamic>.from(record);
      }
    }
    return null;
  }

  Future<void> deletePertumbuhanAnak(String pertumbuhanAnakId) async {
    final records = await _store.growthRecords();
    Map<String, dynamic>? removed;
    for (final record in records) {
      if (record['pertumbuhan_anak_id'] == pertumbuhanAnakId) {
        removed = record;
        break;
      }
    }

    records.removeWhere(
        (record) => record['pertumbuhan_anak_id'] == pertumbuhanAnakId);
    await _store.saveGrowthRecords(records);
    await _store.deletePhoto(removed?['photo'] as String?);
  }

  DateTime? _parse(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
}
