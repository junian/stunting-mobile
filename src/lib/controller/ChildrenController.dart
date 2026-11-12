import 'dart:io';

import 'package:get/get.dart';
import 'package:growthtracker/helper/AgeHelper.dart';
import 'package:growthtracker/services/LocalStore.dart';
import 'package:growthtracker/widget/BottomNavbar.dart';

/// Manages the children kept on this device.
class ChildrenController extends GetxController {
  final LocalStore _store = LocalStore();

  /// Children shown by the home and detail pages.
  RxList<dynamic> anakList = <dynamic>[].obs;

  /// The child currently opened in the detail page.
  final RxList<dynamic> dataAnak = RxList<dynamic>([]);

  Future<bool> registerAnak(
    String user_id,
    String? anak_id,
    String nama_anak,
    String tanggal_lahir,
    String jenis_kelamin,
    String berat_badan,
    String tinggi_badan,
    String lingkar_kepala,
    String tinggi_badan_ibu,
    String tinggi_badan_ayah,
    String gol_darah,
    String alergi,
    String prematur,
    File? photo,
  ) async {
    try {
      final children = await _store.children();
      final existingIndex = anak_id == null
          ? -1
          : children.indexWhere((child) => child['anak_id'] == anak_id);
      final existing = existingIndex >= 0 ? children[existingIndex] : null;

      var photoPath = existing?['photo'] as String?;
      if (photo != null) {
        final savedPath = await _store.savePhoto(photo);
        if (savedPath != null) {
          await _store.deletePhoto(photoPath);
          photoPath = savedPath;
        }
      }

      final now = DateTime.now().toIso8601String();
      final owner = user_id.isEmpty ? 'local' : user_id;
      final child = <String, dynamic>{
        'anak_id': existing?['anak_id'] ?? _store.newId('anak_'),
        'user_id': owner,
        'nama_anak': nama_anak,
        'tanggal_lahir': tanggal_lahir,
        'jenis_kelamin': jenis_kelamin,
        'photo': photoPath,
        'berat_badan': berat_badan,
        'tinggi_badan': tinggi_badan,
        'lingkar_kepala': lingkar_kepala,
        'tinggi_badan_ibu': tinggi_badan_ibu,
        'tinggi_badan_ayah': tinggi_badan_ayah,
        'gol_darah': gol_darah,
        'alergi': alergi,
        'prematur': prematur,
        'is_active': '1',
        'created_by': existing?['created_by'] ?? owner,
        'created_date': existing?['created_date'] ?? now,
        'updated_by': owner,
        'updated_date': now,
      };

      if (existingIndex >= 0) {
        children[existingIndex] = child;
      } else {
        children.add(child);
      }
      await _store.saveChildren(children);

      await getAnak(owner, null);
      Get.off(BottomNavbar());
      return true;
    } catch (e) {
      print('Could not save child: $e');
      return false;
    }
  }

  Future<void> getAnak(String user_id, String? anak_id) async {
    try {
      final children = await _store.children();
      final selected = anak_id == null
          ? children
          : children.where((child) => child['anak_id'] == anak_id).toList();

      final now = DateTime.now();
      anakList.value =
          selected.map((child) => _withAge(child, now)).toList();
    } catch (e) {
      print('Could not load children: $e');
    }
  }

  Future<Map<String, dynamic>?> getAnakById(
      String user_id, String? anak_id) async {
    final child = await _store.childById('$anak_id');
    if (child == null) {
      dataAnak.value = [];
      return null;
    }

    final withAge = _withAge(child, DateTime.now());
    dataAnak.value = [withAge];
    return withAge;
  }

  /// Removes the child together with its growth records and photos.
  Future<void> deleteAnak(String anakId) async {
    try {
      final children = await _store.children();
      final child = await _store.childById(anakId);

      children.removeWhere((item) => item['anak_id'] == anakId);
      await _store.saveChildren(children);

      final records = await _store.growthRecords();
      final removed = records
          .where((record) => record['anak_id'] == anakId)
          .toList();
      records.removeWhere((record) => record['anak_id'] == anakId);
      await _store.saveGrowthRecords(records);

      for (final record in removed) {
        await _store.deletePhoto(record['photo'] as String?);
      }
      await _store.deletePhoto(child?['photo'] as String?);

      await getAnak('', null);
    } catch (e) {
      print('Could not delete child: $e');
    }
  }

  Map<String, dynamic> _withAge(Map<String, dynamic> child, DateTime at) {
    final result = Map<String, dynamic>.from(child);
    result['umur'] = ageLabel(_parse(child['tanggal_lahir']), at);
    return result;
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
