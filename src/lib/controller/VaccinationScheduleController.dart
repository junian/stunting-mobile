import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:growthtracker/services/ImmunizationSchedule.dart';
import 'package:growthtracker/services/LocalStore.dart';

/// Builds a child's immunization schedule from data stored on the device: the
/// schedule bundled in [immunizationSchedule] plus the vaccination records in
/// [LocalStore]. This mirrors the server's getJadwalVaksin endpoint without
/// needing a network connection.
class VaccinationScheduleController extends GetxController {
  final LocalStore _store = LocalStore();

  final RxList<Map<String, dynamic>> jadwalVaksinasi =
      <Map<String, dynamic>>[].obs;

  Future<void> getJadwalVaksin(String anakID) async {
    final child = await _store.childById(anakID);
    final records = await _store.vaccinations();

    final done = <String>{
      for (final record in records)
        if (record['anak_id'] == anakID && record['vaksin_id'] != null)
          record['vaksin_id'].toString(),
    };

    final birthDate = DateTime.tryParse('${child?['tanggal_lahir'] ?? ''}');

    jadwalVaksinasi.value = [
      for (final period in immunizationSchedule)
        {
          'periode': 'age_months_only'.trParams({'count': '${period.ageMonths}'}),
          'bulan_ke': '${period.ageMonths}',
          'rekomendasi': birthDate == null
              ? ''
              : DateFormat('d MMM yyyy')
                  .format(_addMonths(birthDate, period.ageMonths)),
          'vaksin': [
            for (final vaccine in period.vaccines)
              {
                'vaksin_id': vaccine.id,
                'nama_vaksin': vaccine.name,
                'bulan_ke': '${period.ageMonths}',
                'status': done.contains(vaccine.id) ? 'Sudah' : 'Belum',
              },
          ],
        },
    ];
  }

  /// Adds [months] to [date], keeping the day of the month when it exists.
  DateTime _addMonths(DateTime date, int months) {
    final target = DateTime(date.year, date.month + months, 1);
    final lastDay = DateTime(target.year, target.month + 1, 0).day;
    return DateTime(
      target.year,
      target.month,
      date.day <= lastDay ? date.day : lastDay,
    );
  }
}
