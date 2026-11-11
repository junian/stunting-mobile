import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local persistence for the app: children, their growth records and the
/// photos attached to them. Everything is stored on the device, so the app
/// works without an account or network connection.
class LocalStore {
  static const String _childrenKey = 'local_children';
  static const String _growthKey = 'local_growth_records';

  Future<List<Map<String, dynamic>>> children() => _read(_childrenKey);

  Future<Map<String, dynamic>?> childById(String anakId) async {
    for (final child in await children()) {
      if (child['anak_id'] == anakId) return child;
    }
    return null;
  }

  Future<void> saveChildren(List<Map<String, dynamic>> children) =>
      _write(_childrenKey, children);

  Future<List<Map<String, dynamic>>> growthRecords() => _read(_growthKey);

  Future<void> saveGrowthRecords(List<Map<String, dynamic>> records) =>
      _write(_growthKey, records);

  String newId(String prefix) =>
      '$prefix${DateTime.now().microsecondsSinceEpoch}';

  /// Copies [source] into the app documents directory so the photo survives
  /// even if the original picked file is removed.
  Future<String?> savePhoto(File source) async {
    try {
      final documents = await getApplicationDocumentsDirectory();
      final dir = Directory('${documents.path}/photos');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final fileName = source.path.split(Platform.pathSeparator).last;
      final target = File(
          '${dir.path}/${DateTime.now().microsecondsSinceEpoch}_$fileName');
      await target.writeAsBytes(await source.readAsBytes());
      return target.path;
    } catch (e) {
      print('Could not save photo: $e');
      return null;
    }
  }

  Future<void> deletePhoto(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Could not delete photo: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (e) {
      // Ignore corrupted entries instead of crashing the page.
      print('Could not read $key: $e');
      return [];
    }
  }

  Future<void> _write(String key, List<Map<String, dynamic>> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(value));
  }
}
