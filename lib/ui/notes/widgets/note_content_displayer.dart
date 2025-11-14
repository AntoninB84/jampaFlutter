import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';

class NoteContentDisplayer extends StatefulWidget {
  const NoteContentDisplayer({super.key,
    required this.content,
  });

  final String? content;

  @override
  State<NoteContentDisplayer> createState() => _NoteContentDisplayerState();
}

class _NoteContentDisplayerState extends State<NoteContentDisplayer> {

  late QuillController _quillController;

  @override
  void initState() {
    super.initState();
    if(widget.content != null && widget.content!.isNotEmpty) {
      final document = Document.fromJson(jsonDecode(widget.content ?? ''));
      _quillController = QuillController(
        document: document,
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      );
    }
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.content == null || widget.content!.isEmpty){
      return kEmptyWidget;
    }
    return QuillEditor.basic(
      controller: _quillController,
    );
  }
}