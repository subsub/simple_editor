import 'package:flutter/material.dart';
import 'package:simple_editor/simple_editor.dart';
import 'package:simple_editor/src/simple_editor_controller.dart';

class SimpleEditorWidget extends StatefulWidget {
  SimpleEditorWidget(
    this.controller, {
    required this.value,
    required this.autoCorrect,
    required this.autoFocus,
    this.decoration = const DefaultSimpleEditorInputDecoration(),
    this.isValueSanitized = false,
  });

  final SimpleEditorController controller;
  final bool autoCorrect;
  final bool autoFocus;
  final InputDecoration decoration;
  final String value;
  final bool isValueSanitized;

  @override
  State<StatefulWidget> createState() => _SimpleEditorState();
}

class _SimpleEditorState extends State<SimpleEditorWidget> {
  @override
  void initState() {
    widget.controller.setValue(
      widget.value,
      sanitized: widget.isValueSanitized,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          child: TextField(
            expands: true,
            key: Key('simple_editor_text_field'),
            controller: widget.controller,
            autocorrect: widget.autoCorrect,
            autofocus: widget.autoFocus,
            decoration: widget.decoration,
            onChanged: _handleTextChanged,
            minLines: null,
            maxLines: null,
          )),
    );
  }

  void _handleTextChanged(String value) {
    // TODO: handle on text changed
  }
}

class DefaultSimpleEditorInputDecoration extends InputDecoration {
  const DefaultSimpleEditorInputDecoration();
}
