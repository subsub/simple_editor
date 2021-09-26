import 'package:flutter/material.dart';
import 'package:simple_editor/src/simple_editor_platform.dart';

class SimpleEditorController extends TextEditingController {
  SimpleEditorController();

  void setValue(
    String val, {
    bool sanitized = false,
  }) {
    if (!sanitized) {
      val = _sanitizeHTML(val);
    }

    text = val;
  }

  /// returns original string
  String getRawResult() {
    return text;
  }

  /// returns string in formatted html
  String getFormattedResult() {
    return _formatHTML(text);
  }

  String _formatHTML(String value) {
    var result = value.formatBullets();
    result = result.formatNewLine();    
    return "<p>$result</p>";
  }

  String _sanitizeHTML(String value) {
    var result = value.sanitizeBullets();
    result = result.sanitizeNewLine();
    result = result.sanitizeP();
    return result;
  }
}

extension StringExt on String {
  String formatNewLine() {
    final String result = replaceAll("\n", "<br/>");
    return result;
  }
  
  String formatBullets() {
    final RegExp regex = RegExp("(\n-\\s)(.{1,})(\n)", multiLine: true,caseSensitive: false,);
    final String result = replaceAllMapped(regex, (match) => "<br/><li>${match.group(2)}</li><br/>",);
    return result;
  }

  String sanitizeNewLine() {
    final RegExp regex = RegExp("(<br\\s*/>)", multiLine: true, caseSensitive: false,);
    final String result = replaceAllMapped(regex, (match) => "\n",);
    return result;
  }
    
  String sanitizeP() {
    final RegExp regex = RegExp("(<p>)|(</p>)",  multiLine: true, caseSensitive: false,);
    final String result = replaceAllMapped(regex, (match) => "");
    return result;
  }

  String sanitizeBullets() {
    final RegExp regex = RegExp("(<li>)(([^<>/]){1,})(</li>)", multiLine: true, caseSensitive: false,);
    final String result = replaceAllMapped(regex, (match) => "\n-${match.group(2)}",);
    return result;
  }
}