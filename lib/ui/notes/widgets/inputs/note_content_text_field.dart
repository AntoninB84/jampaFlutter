import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import 'package:jampa_flutter/utils/constants/styles/styles.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

class NoteContentTextField extends StatefulWidget {
  const NoteContentTextField({super.key,
    this.value,
    required this.onChanged,
  });

  final Document? value;
  final Function(Document?) onChanged;

  @override
  State<NoteContentTextField> createState() => _NoteContentTextFieldState();
}

class _NoteContentTextFieldState extends State<NoteContentTextField> {

  final QuillController _quillController = QuillController.basic();

  @override
  void initState() {
    if(widget.value != null){
      _quillController.document = widget.value!;
    }
    _quillController.addListener(_handleContentChange);
    super.initState();
  }

  @override
  void dispose() {
    _quillController.removeListener(_handleContentChange);
    _quillController.dispose();
    super.dispose();
  }

  void _handleContentChange(){
    if(_quillController.document.isEmpty()){
      widget.onChanged(null);
    }else{
      widget.onChanged(_quillController.document);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: MultiDropdownTheme.fieldDecoration(context, null)
              .border?.borderSide.color ?? Colors.grey
        ),
        borderRadius: kRadius8
      ),
      child: Column(
        children: [
          QuillSimpleToolbar(
            controller: _quillController,
            config: QuillSimpleToolbarConfig(
              multiRowsDisplay: false,
              showFontFamily: false,
              showCodeBlock: false,
              showInlineCode: false,
              showSubscript: false,
              showSuperscript: false,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(kRadiusValue8),
                ),
                border: BorderDirectional(
                  bottom: BorderSide(
                    color: MultiDropdownTheme.fieldDecoration(context, null)
                        .border?.borderSide.color ?? Colors.grey
                  )
                )
              )
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.3,
            ),
            child: QuillEditor.basic(
              controller: _quillController,
              config: QuillEditorConfig(
                placeholder: context.strings.create_note_content_field_hint,
                expands: true,
                padding: const EdgeInsets.all(kGap4),
              ),
            ),
          )
        ],
      ),
    );
  }
}