import 'package:growthtracker/services/GrowthStatus.dart';
import 'package:growthtracker/services/LocalStore.dart';

/// Temporary helper used only to prepare the Play Store screenshots.
/// It replaces the local demo data with two believable child profiles.
Future<void> seedPlayStoreData() async {
  final store = LocalStore();
  if ((await store.children()).isNotEmpty) return;

  final aisyahBirth = DateTime(2024, 8, 12);
  final rakaBirth = DateTime(2022, 3, 5);

  final children = <Map<String, dynamic>>[
    _child(
      id: 'anak_aisyah',
      name: 'Aisyah Putri',
      birth: aisyahBirth,
      gender: 'Perempuan',
      weight: '3.1',
      height: '49',
      head: '34',
      motherHeight: '158',
      fatherHeight: '170',
      blood: 'B',
    ),
    _child(
      id: 'anak_raka',
      name: 'Muhammad Raka',
      birth: rakaBirth,
      gender: 'Laki-Laki',
      weight: '3.3',
      height: '50',
      head: '34.5',
      motherHeight: '156',
      fatherHeight: '172',
      blood: 'O',
    ),
  ];
  await store.saveChildren(children);

  final growth = <Map<String, dynamic>>[];
  _addGrowth(
    growth,
    child: children[0],
    birth: aisyahBirth,
    values: const [
      (0, 3.1, 49.0, 34.0),
      (2, 4.9, 56.0, 38.0),
      (4, 6.2, 61.0, 40.5),
      (6, 7.3, 65.0, 42.5),
      (9, 8.2, 69.0, 44.0),
      (12, 9.0, 73.0, 45.0),
      (15, 9.8, 76.0, 45.8),
      (18, 10.5, 79.0, 46.3),
      (21, 11.1, 82.0, 46.8),
      (24, 11.8, 85.0, 47.2),
      (27, 12.4, 88.0, 47.6),
    ],
  );
  _addGrowth(
    growth,
    child: children[1],
    birth: rakaBirth,
    values: const [
      (0, 3.3, 50.0, 34.5),
      (6, 7.8, 67.0, 43.0),
      (12, 10.0, 76.0, 46.0),
      (18, 11.5, 82.0, 47.0),
      (24, 12.8, 87.0, 48.0),
      (30, 13.8, 91.0, 48.5),
      (36, 14.6, 95.0, 49.0),
      (42, 15.4, 99.0, 49.5),
      (48, 16.2, 103.0, 50.0),
      (54, 16.9, 106.0, 50.3),
      (56, 17.2, 107.0, 50.4),
    ],
  );
  await store.saveGrowthRecords(growth);

  final vaccinations = <Map<String, dynamic>>[];
  _addVaccinations(
    vaccinations,
    child: children[0],
    birth: aisyahBirth,
    doctor: 'dr. Anita Pratama, Sp.A',
    place: 'Posyandu Melati',
    skipIds: const {'22'},
  );
  _addVaccinations(
    vaccinations,
    child: children[1],
    birth: rakaBirth,
    doctor: 'dr. Budi Santoso, Sp.A',
    place: 'Puskesmas Kebayoran',
  );
  await store.saveVaccinations(vaccinations);
}

Map<String, dynamic> _child({
  required String id,
  required String name,
  required DateTime birth,
  required String gender,
  required String weight,
  required String height,
  required String head,
  required String motherHeight,
  required String fatherHeight,
  required String blood,
}) {
  final now = DateTime.now().toIso8601String();
  return {
    'anak_id': id,
    'user_id': 'local',
    'nama_anak': name,
    'tanggal_lahir': _date(birth),
    'jenis_kelamin': gender,
    'photo': null,
    'berat_badan': weight,
    'tinggi_badan': height,
    'lingkar_kepala': head,
    'tinggi_badan_ibu': motherHeight,
    'tinggi_badan_ayah': fatherHeight,
    'gol_darah': blood,
    'alergi': 'Tidak',
    'prematur': 'Tidak',
    'is_active': '1',
    'created_by': 'local',
    'created_date': now,
    'updated_by': 'local',
    'updated_date': now,
  };
}

void _addGrowth(
  List<Map<String, dynamic>> out, {
  required Map<String, dynamic> child,
  required DateTime birth,
  required List<(int, double, double, double)> values,
}) {
  for (final (month, weight, height, head) in values) {
    final date = DateTime(birth.year, birth.month + month, birth.day, 9);
    final status = GrowthStatus.compute(
      jenisKelamin: '${child['jenis_kelamin']}',
      beratBadan: weight,
      tinggiBadan: height,
      lingkarKepala: head,
      ageInMonths: GrowthStatus.ageInMonths(birth, date),
    );
    out.add({
      'pertumbuhan_anak_id': 'pertumbuhan_${child['anak_id']}_$month',
      'anak_id': child['anak_id'],
      'tanggal_pertumbuhan': _date(date),
      'berat_badan': weight,
      'tinggi_badan': height,
      'lingkar_kepala': head,
      'tinggi_badan_ibu': child['tinggi_badan_ibu'],
      'tinggi_badan_ayah': child['tinggi_badan_ayah'],
      'photo': null,
      'created_date': DateTime(date.year, date.month, date.day, 9, 20)
          .toIso8601String(),
      'umur': _ageLabel(birth, date),
      ...status,
    });
  }
}

void _addVaccinations(
  List<Map<String, dynamic>> out, {
  required Map<String, dynamic> child,
  required DateTime birth,
  required String doctor,
  required String place,
  Set<String> skipIds = const {},
}) {
  const schedule = <(int, List<String>)>[
    (0, ['1', '5', '8']),
    (2, ['2', '7', '9', '12', '15', '18']),
    (3, ['3', '6', '11', '13']),
    (4, ['4', '10', '14', '16', '19', '27']),
    (6, ['17', '20']),
    (9, ['21']),
    (12, ['23', '25']),
    (18, ['24', '26']),
    (24, ['22']),
  ];

  for (final (month, ids) in schedule) {
    final date = DateTime(birth.year, birth.month + month, birth.day, 10);
    for (final id in ids) {
      if (skipIds.contains(id)) continue;
      out.add({
        'vaksin_anak_id': 'vaksin_anak_${child['anak_id']}_$id',
        'anak_id': child['anak_id'],
        'vaksin_id': id,
        'tanggal_vaksin': _date(date),
        'nama_dokter': doctor,
        'tempat': place,
        'no_batch': 'VK-${date.year.toString().substring(2)}${date.month.toString().padLeft(2, '0')}-${id.padLeft(2, '0')}',
        'photo': null,
        'created_date': DateTime(date.year, date.month, date.day, 10, 30)
            .toIso8601String(),
      });
    }
  }
}

String _date(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

String _ageLabel(DateTime birth, DateTime at) {
  var months = (at.year - birth.year) * 12 + at.month - birth.month;
  if (at.day < birth.day) months -= 1;
  if (months < 0) months = 0;
  final years = months ~/ 12;
  final remaining = months % 12;
  if (years == 0) return '$months months';
  return '$years years $remaining months';
}
