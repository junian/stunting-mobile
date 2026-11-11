import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Manages the app language.
///
/// The stored preference can be:
/// - `system` (default): follow the device system language
/// - `en`: force English
/// - `id`: force Bahasa Indonesia
///
/// English is used as fallback when the system language is not Indonesian.
class LanguageController extends GetxController {
  static const String storageKey = 'language_code';
  static const String system = 'system';
  static const String english = 'en';
  static const String indonesian = 'id';

  final GetStorage _storage = GetStorage();

  /// The stored preference (`system`, `en` or `id`).
  final RxString preference = system.obs;

  /// The locale currently applied to the app.
  final Rx<Locale> locale = const Locale(english).obs;

  @override
  void onInit() {
    super.onInit();
    final saved = _storage.read<String>(storageKey);
    preference.value =
        (saved == english || saved == indonesian) ? saved! : system;
    locale.value = resolveLocale(preference.value);
  }

  /// Resolves a preference to a concrete locale, falling back to English.
  Locale resolveLocale(String preferenceValue) {
    if (preferenceValue == english) return const Locale(english);
    if (preferenceValue == indonesian) return const Locale(indonesian);

    final deviceLanguage =
        PlatformDispatcher.instance.locale.languageCode.toLowerCase();
    return deviceLanguage == indonesian
        ? const Locale(indonesian)
        : const Locale(english);
  }

  /// Applies the given preference and persists it.
  Future<void> setLanguage(String preferenceValue) async {
    preference.value = preferenceValue;
    locale.value = resolveLocale(preferenceValue);
    await _storage.write(storageKey, preferenceValue);
    await Get.updateLocale(locale.value);
  }

  /// Label of the currently selected language, translated.
  String get currentLabel {
    switch (preference.value) {
      case english:
        return 'language_english'.tr;
      case indonesian:
        return 'language_indonesian'.tr;
      default:
        return 'language_system'.tr;
    }
  }

  /// Label for a preference value, translated.
  String labelFor(String preferenceValue) {
    switch (preferenceValue) {
      case english:
        return 'language_english'.tr;
      case indonesian:
        return 'language_indonesian'.tr;
      default:
        return 'language_system'.tr;
    }
  }
}
