import 'package:get/get.dart';
import 'package:growthtracker/pages/GrowthDetailPage.dart';
import 'package:growthtracker/services/GrowthStatus.dart';
import 'package:growthtracker/services/LocalStore.dart';

class GrowthDetailController extends GetxController {
  final LocalStore _store = LocalStore();

  Future<Map<String, dynamic>?> getDetailPertumbuhan(
      String pertumbuhanAnakId, String umur) async {
    final records = await _store.growthRecords();
    for (final record in records) {
      if (record['pertumbuhan_anak_id'] != pertumbuhanAnakId) continue;

      // Records saved before the WHO reference shipped are missing the
      // statuses, so derive them here instead of showing '-'.
      final detail = record['status_pertumbuhan_berat'] == null
          ? await _withStatus(Map<String, dynamic>.from(record))
          : record;

      await Get.to(
        GrowthDetailPage(
          pertumbuhanAnakId: '$pertumbuhanAnakId',
          anakId: '${detail['anak_id']}',
          beratBadan: '${detail['berat_badan']}',
          tinggiBadan: '${detail['tinggi_badan']}',
          lingkarKepala: '${detail['lingkar_kepala']}',
          createdDate: '${detail['tanggal_pertumbuhan']}',
          statusPertumbuhanBerat:
              '${detail['status_pertumbuhan_berat'] ?? '-'}',
          statusPertumbuhanTinggi:
              '${detail['status_pertumbuhan_tinggi'] ?? '-'}',
          statusPertumbuhanLingkarKepala:
              '${detail['status_pertumbuhan_lingkar_kepala'] ?? '-'}',
          umur: '${detail['umur'] ?? umur}',
        ),
      );
      return detail;
    }
    return null;
  }

  Future<Map<String, dynamic>> _withStatus(
      Map<String, dynamic> record) async {
    final child = await _store.childById('${record['anak_id']}');
    final birthDate = _parse(child?['tanggal_lahir']);
    final measuredAt =
        _parse(record['tanggal_pertumbuhan']) ?? _parse(record['created_date']);

    final status = GrowthStatus.compute(
      jenisKelamin: child?['jenis_kelamin']?.toString(),
      beratBadan: _number(record['berat_badan']),
      tinggiBadan: _number(record['tinggi_badan']),
      lingkarKepala: _number(record['lingkar_kepala']),
      ageInMonths: birthDate == null || measuredAt == null
          ? null
          : GrowthStatus.ageInMonths(birthDate, measuredAt),
    );
    return {...record, ...status};
  }

  double? _number(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
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
