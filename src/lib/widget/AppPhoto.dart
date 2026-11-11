import 'dart:io';

import 'package:flutter/material.dart';

/// Shows a photo saved on the device, while still supporting the server paths
/// stored by older records.
class AppPhoto extends StatelessWidget {
  static const String _legacyHost = 'https://mystantapp.siuinsa.com/';

  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppPhoto(
    this.source, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  /// Absolute paths start with `/` (or a drive letter on Windows); older
  /// records hold paths relative to the API host.
  bool get _isLocalFile => RegExp(r'^([a-zA-Z]:[\\/]|/)').hasMatch(source);

  @override
  Widget build(BuildContext context) {
    final placeholder = Icon(
      Icons.broken_image,
      size: width ?? height ?? 24,
      color: Colors.grey,
    );

    if (_isLocalFile) {
      return Image.file(
        File(source),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => placeholder,
      );
    }

    return Image.network(
      source.startsWith('http') ? source : '$_legacyHost$source',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}
