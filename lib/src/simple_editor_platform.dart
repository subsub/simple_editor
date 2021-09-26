
import 'package:flutter/services.dart';

class Platform {
  static const channel = MethodChannel('id.subkhansarif.lib/simple_editor');

  static Future<String?> formatHTML(String value) async {
    try {
      final String? result = await channel.invokeMethod('formatHtml', value);
      return result;
    } on PlatformException catch (e) {
      // TODO: handle error
    }

    return null;
  }

  static Future<String?> sanitizeHTML(String value) async {
    try {
      final String? result = await channel.invokeMethod('sanitizeHTML', value);
      return result;
    } on PlatformException catch (e) {
      // TODO: handle error
    }

    return null;
  }
}