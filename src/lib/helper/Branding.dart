/// Product identity in one place.
///
/// The package id (`com.bebasstunting.stantapp`), API host and old social
/// handles intentionally keep their original values so existing installs,
/// links and backend data continue to work after the rename.
const String kAppName = 'KidScale';

/// Replaces the legacy product name in copy fetched from the server.
String rebrandServerCopy(String text) {
  if (text.isEmpty) return text;
  return text
      .replaceAll('STANTAPP', kAppName)
      .replaceAll('StantApp', kAppName)
      .replaceAll('Stantapp', kAppName)
      .replaceAll('Stant App', kAppName)
      .replaceAll('stantapp', kAppName);
}
