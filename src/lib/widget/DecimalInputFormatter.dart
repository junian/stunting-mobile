import 'package:flutter/services.dart';

/// Allows only digits and a single decimal separator (`.` or `,`),
/// so numeric fields can never hold arbitrary text.
class DecimalInputFormatter extends TextInputFormatter {
  static final RegExp _valid = RegExp(r'^\d*[.,]?\d*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty || text == '.' || text == ',') {
      return newValue;
    }
    if (_valid.hasMatch(text)) {
      return newValue;
    }
    return oldValue;
  }
}
