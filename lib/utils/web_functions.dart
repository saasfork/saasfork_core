import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:saasfork_core/saasfork_core.dart';
import 'package:web/web.dart' as web;

// get http://localhost:XXX or http://example.com
String getLocalhostUrl() {
  if (kIsWeb) {
    try {
      final location = web.window.location;
      final protocol = location.protocol;
      final hostname = location.hostname;
      final port = location.port;

      return '$protocol//$hostname${port.isNotEmpty ? ':$port' : ''}';
    } catch (e) {
      error('Error while retrieving localhost URL: $e');
      return '';
    }
  } else {
    warn('Non-web environment detected');
    return '';
  }
}
