import 'package:growthtracker/services/WhoReference.dart';

/// Computes the growth status of a measurement locally, using the WHO
/// reference values bundled in [whoReference]. Bands and thresholds match the
/// legacy backend; the labels themselves are translated by the UI.
class GrowthStatus {
  static const String giziBuruk = 'gizi_buruk';
  static const String giziKurang = 'gizi_kurang';
  static const String giziBaik = 'gizi_baik';
  static const String giziLebih = 'gizi_lebih';

  static const String sangatPendek = 'sangat_pendek';
  static const String pendek = 'pendek';
  static const String tinggiNormal = 'tinggi_normal';
  static const String tinggi = 'tinggi';

  static const String mikrosefali = 'mikrosefali';
  static const String lingkarNormal = 'lingkar_normal';

  static const String tidakAda = 'tidak_ada';

  static const String consult = 'consult';
  static const String keepHealthy = 'keep_healthy';
  static const String noAdvice = 'none';

  static const Set<String> _normal = {giziBaik, tinggiNormal, lingkarNormal};

  /// Values the backend stored before the statuses became codes.
  static const Map<String, String> _legacy = {
    'Gizi Buruk': giziBuruk,
    'Gizi Kurang': giziKurang,
    'Gizi Baik': giziBaik,
    'Gizi Lebih': giziLebih,
    'Sangat Pendek (terindeksi stunting)': sangatPendek,
    'Pendek': pendek,
    'Tinggi Badan Normal': tinggiNormal,
    'Tinggi': tinggi,
    'Mikrosefali': mikrosefali,
    'Lingkar Kepala Normal': lingkarNormal,
    'Tidak Ada': tidakAda,
  };

  /// Whole months between [birth] and [at], the way the backend counted it
  /// (years * 12 + months + days / 30, rounded down).
  static int ageInMonths(DateTime birth, DateTime at) {
    final months = (at.year - birth.year) * 12 +
        (at.month - birth.month) +
        (at.day - birth.day) / 30;
    return months.floor();
  }

  /// Returns the status/advice codes stored on a growth record.
  static Map<String, String> compute({
    required String? jenisKelamin,
    required double? beratBadan,
    required double? tinggiBadan,
    required double? lingkarKepala,
    int? ageInMonths,
  }) {
    final boy = (jenisKelamin ?? '').toLowerCase().contains('laki');
    final months = ageInMonths;

    final weight = _row(boy ? 'BBAL' : 'BBAP', months);
    final height = _row(boy ? 'TBAL' : 'TBAP', months);
    final head = _row(boy ? 'LKAL' : 'LKAP', months);

    final result = <String, String>{};

    final weightStatus = _status(
      value: beratBadan,
      row: weight,
      bands: const [
        [giziBuruk, consult],
        [giziKurang, consult],
        [giziBaik, keepHealthy],
        [giziLebih, consult],
      ],
    );
    result['status_pertumbuhan_berat'] = weightStatus[0];
    result['ket_status_pertumbuhan_berat'] = weightStatus[1];

    final heightStatus = _status(
      value: tinggiBadan,
      row: height,
      bands: const [
        [sangatPendek, consult],
        [pendek, consult],
        [tinggiNormal, keepHealthy],
        [tinggi, consult],
      ],
    );
    result['status_pertumbuhan_tinggi'] = heightStatus[0];
    result['ket_status_pertumbuhan_tinggi'] = heightStatus[1];

    final headStatus = _status(
      value: lingkarKepala,
      row: head,
      bands: const [
        [mikrosefali, consult],
        [mikrosefali, consult],
        [lingkarNormal, keepHealthy],
        [mikrosefali, consult],
      ],
    );
    result['status_pertumbuhan_lingkar_kepala'] = headStatus[0];
    result['ket_status_pertumbuhan_lingkar_kepala'] = headStatus[1];

    return result;
  }

  /// The status code for a stored value, accepting both the codes written by
  /// [compute] and the labels the old backend stored. Null when unknown.
  static String? codeFor(String? value) {
    if (value == null) return null;
    final normalized = value.trim();
    if (normalized.isEmpty || normalized == '-') return null;
    if (_legacy.containsValue(normalized)) return normalized;
    return _legacy[normalized];
  }

  /// Translation key for a stored status value, e.g. `status_gizi_baik`.
  static String? labelKey(String? value) {
    final code = codeFor(value);
    return code == null ? null : 'status_$code';
  }

  static bool isNormal(String? value) => _normal.contains(codeFor(value));

  static bool hasReference(String? value) =>
      codeFor(value) != null && codeFor(value) != tidakAda;

  /// Translation key for the advice line of a status, or null when there is
  /// nothing to advise.
  static String? noteKey(String? value) {
    if (!hasReference(value)) return null;
    return isNormal(value) ? 'keep_healthy_note' : 'consult_note';
  }

  /// [min3sd, min2sd, plus2sd] for the given category and month, or null when
  /// the reference has no data for that age (over 60 months).
  static List<double>? _row(String category, int? months) {
    if (months == null || months < 0) return null;
    return whoReference[category]?[months];
  }

  /// Picks the band for [value]: below min-3SD, min-3SD..min-2SD,
  /// min-2SD..+2SD, and +2SD and above.
  static List<String> _status({
    required double? value,
    required List<double>? row,
    required List<List<String>> bands,
  }) {
    if (value == null || row == null || row.length < 3) {
      return const [tidakAda, noAdvice];
    }

    final min3sd = row[0];
    final min2sd = row[1];
    final plus2sd = row[2];

    if (value < min3sd) {
      return bands[0];
    } else if (value < min2sd) {
      return bands[1];
    } else if (value < plus2sd) {
      return bands[2];
    }
    return bands[3];
  }
}
