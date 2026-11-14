/// Product identity in one place.
///
/// The package id (`com.bebasstunting.stantapp`) and API host intentionally
/// keep their original values so existing installs and backend data continue
/// to work after the rename.
const String kAppName = 'KidScale';

/// Support and public links. Keep these in one place so the About page, the
/// settings screen and the help copy cannot drift apart.
const String kSupportEmail = 'support+kidscale@mail.juniandev.com';
const String kSupportMailto = 'mailto:$kSupportEmail';
const String kWebsiteUrl = 'https://kidscale.juniandev.com';
const String kYouTubeUrl = 'https://youtube.com/@JunianDev';

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
