import 'package:get/get.dart';
import 'package:growthtracker/helper/AgeHelper.dart';
import 'package:growthtracker/services/LocalStore.dart';

/// Reads the growth records this device has stored for a child.
class GrowthHistoryController extends GetxController {
  final LocalStore _store = LocalStore();

  RxList<Map<String, dynamic>> riwayatPertumbuhan =
      RxList<Map<String, dynamic>>([]);

  Future<String> getPertumbuhanAnak(String anakID) async {
    riwayatPertumbuhan.clear();
    try {
      final records = await _store.growthRecords();
      final birth = _parse((await _store.childById(anakID))?['tanggal_lahir']);

      riwayatPertumbuhan.value = records
          .where((record) => record['anak_id'] == anakID)
          .map((record) => _withAge(record, birth))
          .toList();
    } catch (e) {
      print('Could not load growth records: $e');
    }

    return "sukses";
  }

  /// The age is recalculated on read so it follows edits to the birth date.
  Map<String, dynamic> _withAge(Map<String, dynamic> record, DateTime? birth) {
    final result = Map<String, dynamic>.from(record);
    final measured = _parse(record['tanggal_pertumbuhan']) ??
        _parse(record['created_date']);
    result['umur'] = ageLabel(birth, measured ?? DateTime.now());
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
