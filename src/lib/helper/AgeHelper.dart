import 'package:get/get.dart';

/// Builds the localized "X years Y months" label used for a child's age.
String ageLabel(DateTime? birthDate, DateTime at) {
  if (birthDate == null || at.isBefore(birthDate)) return '';

  var months =
      (at.year - birthDate.year) * 12 + at.month - birthDate.month;
  if (at.day < birthDate.day) months -= 1;
  if (months < 0) months = 0;

  final years = months ~/ 12;
  final remainingMonths = months % 12;

  if (years == 0) {
    return 'age_months_only'.trParams({'count': '$months'});
  }

  return 'age_years_months'
      .trParams({'years': '$years', 'months': '$remainingMonths'});
}
