import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:growthtracker/pages/VaccinationEditorPage.dart';
import 'package:growthtracker/services/LocalStore.dart';

/// Reads and writes the child's vaccination records. Everything is kept in
/// [LocalStore], so the vaccination screens work without a network connection.
class VaccinationController extends GetxController {
  final LocalStore _store = LocalStore();

  File? pickedImage;
  TextEditingController nama_dokter = TextEditingController();
  TextEditingController tempat = TextEditingController();
  TextEditingController no_batch = TextEditingController();
  TextEditingController dateinput = TextEditingController();

  Future<List<Map<String, dynamic>>> vaccinations(String anakID) async {
    final records = await _store.vaccinations();
    return records
        .where((record) => record['anak_id'] == anakID)
        .map((record) => Map<String, dynamic>.from(record))
        .toList();
  }

  /// The saved record of one vaccine for one child, or `null` when the vaccine
  /// has not been recorded yet.
  Future<Map<String, dynamic>?> vaccinationRecord({
    required String anak_id,
    required String vaksin_id,
  }) async {
    for (final record in await vaccinations(anak_id)) {
      if (record['vaksin_id'] == vaksin_id) return record;
    }
    return null;
  }

  /// Opens the editor filled with the existing record of this vaccine.
  Future<void> getVaksinAnak({
    required String anak_id,
    required String vaksin_id,
  }) async {
    final record = await vaccinationRecord(anak_id: anak_id, vaksin_id: vaksin_id);
    if (record == null) return;

    dateinput.text = '${record['tanggal_vaksin'] ?? ''}';
    nama_dokter.text = '${record['nama_dokter'] ?? ''}';
    tempat.text = '${record['tempat'] ?? ''}';
    no_batch.text = '${record['no_batch'] ?? ''}';

    await Get.to(() => VaccinationEditorPage(
          anak_id: anak_id,
          vaksin_id: vaksin_id,
          vaksin_anak_id: '${record['vaksin_anak_id']}',
        ));
  }

  /// Saves (or updates) the record of one vaccine. Returns `false` when nothing
  /// could be written, so the caller can tell the user.
  Future<bool> addVaksinAnak({
    String? vaksin_anak_id,
    required anak_id,
    required vaksin_id,
    required String tanggal_vaksin,
    required String name_dokter,
    required String tempat,
    required String no_batch,
    required File? pickedImage,
  }) async {
    try {
      String? photoPath;
      if (pickedImage != null) {
        photoPath = await _store.savePhoto(pickedImage);
      }

      final records = await _store.vaccinations();
      Map<String, dynamic>? previous;
      final existing = records.indexWhere((record) =>
          record['anak_id'] == anak_id && record['vaksin_id'] == vaksin_id);
      if (existing >= 0) {
        previous = records.removeAt(existing);
      }

      records.add({
        'vaksin_anak_id': vaksin_anak_id ??
            previous?['vaksin_anak_id'] ??
            _store.newId('vaksin_anak_'),
        'anak_id': anak_id,
        'vaksin_id': vaksin_id,
        'tanggal_vaksin': tanggal_vaksin,
        'nama_dokter': name_dokter,
        'tempat': tempat,
        'no_batch': no_batch,
        'photo': photoPath ?? previous?['photo'],
        'created_date': DateTime.now().toIso8601String(),
      });

      await _store.saveVaccinations(records);

      if (photoPath != null) {
        await _store.deletePhoto(previous?['photo'] as String?);
      }
      return true;
    } catch (e) {
      print('Could not save vaccination: $e');
      return false;
    }
  }

  /// Deletes the record of one vaccine, used when the parent marks it as not
  /// done anymore.
  Future<void> removeVaksinAnak({
    required String anak_id,
    required String vaksin_id,
  }) async {
    final records = await _store.vaccinations();
    Map<String, dynamic>? removed;
    final existing = records.indexWhere((record) =>
        record['anak_id'] == anak_id && record['vaksin_id'] == vaksin_id);
    if (existing >= 0) {
      removed = records.removeAt(existing);
    }

    await _store.saveVaccinations(records);
    await _store.deletePhoto(removed?['photo'] as String?);
  }
}
