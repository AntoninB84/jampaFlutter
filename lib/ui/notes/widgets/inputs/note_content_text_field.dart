import 'dart:async';

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
  StreamSubscription? _docChangesSubscription;

  @override
  void initState() {
    _handleInitParameterChange();
    super.initState();
  }

  @override
  void dispose() {
    if(_docChangesSubscription != null) {
      _docChangesSubscription?.cancel();
    }
    _quillController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NoteContentTextField oldWidget) {
    if(oldWidget.value != widget.value){
      _handleInitParameterChange();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _handleInitParameterChange(){
    if(widget.value != null && !widget.value!.isEmpty()) {
      _quillController.document = widget.value!;
      _startListeningToChanges();
    }
  }

  void _startListeningToChanges() async {
    await _docChangesSubscription?.cancel();
    _docChangesSubscription = _quillController.changes.listen((event) {
      widget.onChanged(_quillController.document);
    });
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
                onTapOutside: (event, focusNode) {
                  focusNode.unfocus();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}