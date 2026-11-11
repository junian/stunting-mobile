import 'package:get/get.dart';
import 'package:growthtracker/pages/GrowthDetailPage.dart';
import 'package:growthtracker/services/LocalStore.dart';

class GrowthDetailController extends GetxController {
  final LocalStore _store = LocalStore();

  Future<Map<String, dynamic>?> getDetailPertumbuhan(
      String pertumbuhanAnakId, String umur) async {
    final records = await _store.growthRecords();
    for (final record in records) {
      if (record['pertumbuhan_anak_id'] != pertumbuhanAnakId) continue;

      await Get.to(
        GrowthDetailPage(
          pertumbuhanAnakId: '$pertumbuhanAnakId',
          anakId: '${record['anak_id']}',
          beratBadan: '${record['berat_badan']}',
          tinggiBadan: '${record['tinggi_badan']}',
          lingkarKepala: '${record['lingkar_kepala']}',
          createdDate: '${record['tanggal_pertumbuhan']}',
          statusPertumbuhanBerat:
              '${record['status_pertumbuhan_berat'] ?? '-'}',
          statusPertumbuhanTinggi:
              '${record['status_pertumbuhan_tinggi'] ?? '-'}',
          statusPertumbuhanLingkarKepala:
              '${record['status_pertumbuhan_lingkar_kepala'] ?? '-'}',
          umur: '${record['umur'] ?? umur}',
        ),
      );
      return record;
    }
    return null;
  }
}
