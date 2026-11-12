import 'package:growthtracker/services/WhoReference.dart';

/// Computes the growth status labels locally, using the WHO reference values
/// bundled in [whoReference]. Same thresholds and labels as the legacy backend.
class GrowthStatus {
  static const String _consult =
      'Silahkan konsultasi dengan petugas kesehatan setempat';
  static const String _keepHealthy = 'Tetap jaga kesehatan anak anda.';
  static const String _none = 'Tidak Ada';

  /// Whole months between [birth] and [at], the way the backend counted it
  /// (years * 12 + months + days / 30, rounded down).
  static int ageInMonths(DateTime birth, DateTime at) {
    final months = (at.year - birth.year) * 12 +
        (at.month - birth.month) +
        (at.day - birth.day) / 30;
    return months.floor();
  }

  /// Returns the status/description keys stored on a growth record.
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
        ['Gizi Buruk', _consult],
        ['Gizi Kurang', _consult],
        ['Gizi Baik', _keepHealthy],
        ['Gizi Lebih', _consult],
      ],
    );
    result['status_pertumbuhan_berat'] = weightStatus[0];
    result['ket_status_pertumbuhan_berat'] = weightStatus[1];

    final heightStatus = _status(
      value: tinggiBadan,
      row: height,
      bands: const [
        ['Sangat Pendek (terindeksi stunting)', _consult],
        ['Pendek', _consult],
        ['Tinggi Badan Normal', _keepHealthy],
        ['Tinggi', _consult],
      ],
    );
    result['status_pertumbuhan_tinggi'] = heightStatus[0];
    result['ket_status_pertumbuhan_tinggi'] = heightStatus[1];

    final headStatus = _status(
      value: lingkarKepala,
      row: head,
      bands: const [
        ['Mikrosefali', _consult],
        ['Mikrosefali', _consult],
        ['Lingkar Kepala Normal', _keepHealthy],
        ['Mikrosefali', _consult],
      ],
    );
    result['status_pertumbuhan_lingkar_kepala'] = headStatus[0];
    result['ket_status_pertumbuhan_lingkar_kepala'] = headStatus[1];

    return result;
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
      return const [_none, _none];
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
