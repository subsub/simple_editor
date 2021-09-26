import 'package:flutter/material.dart';
import 'package:simple_editor/src/simple_editor_platform.dart';

class SimpleEditorController extends TextEditingController {
  SimpleEditorController();

  void setValue(
    String val, {
    bool sanitized = false,
  }) async {
    if (!sanitized) {
      val = await _sanitizeHTML(val);
    }

    text = val;
  }

  /// returns original string
  String getRawResult() {
    return text;
  }

  /// returns string in formatted html
  Future<String> getFormattedResult() async {
    return _formatHTML(text);
  }

  Future<String> _formatHTML(String value) async {
    final String? formattedString = await Platform.formatHTML(value);
    return formattedString ?? '';
  }

  Future<String> _sanitizeHTML(String value) async {
    final String? sanitizedString = await Platform.sanitizeHTML(value);
    return sanitizedString ?? '';
  }
}
