import 'package:package_info_plus/package_info_plus.dart';

/// Version information reported by the platform for this build.
///
/// Android and iOS derive this value from the `version` field in pubspec.yaml,
/// so the UI never needs a hard-coded release number.
class AppVersion {
  AppVersion._();

  static String _version = '';

  /// The version name, as declared by the platform build.
  static String get version => _version;

  /// Loads the version once during app startup.
  static Future<void> load() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _version = info.version.trim();
    } catch (_) {
      // Keep the label usable even if the platform channel is unavailable.
      _version = '';
    }
  }

  /// Returns "Version <version>" (or the localized prefix when unavailable).
  static String label(String prefix) =>
      _version.isEmpty ? prefix : '$prefix $_version';
}
