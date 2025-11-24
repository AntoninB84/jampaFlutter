import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import 'package:jampa_flutter/utils/constants/styles/styles.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

/// A Quill rich text editor for note content input.
class NoteContentTextField extends StatefulWidget {
  const NoteContentTextField({super.key,
    required this.quillController,
    this.editorMaxHeight = 300.0
  });

  final double editorMaxHeight;
  final QuillController quillController;

  @override
  State<NoteContentTextField> createState() => _NoteContentTextFieldState();
}

class _NoteContentTextFieldState extends State<NoteContentTextField> {

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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
            controller: widget.quillController,
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
              maxHeight: widget.editorMaxHeight,
            ),
            child: QuillEditor.basic(
              controller: widget.quillController,
              focusNode: _focusNode,
              config: QuillEditorConfig(
                placeholder: context.strings.create_note_content_field_hint,
                expands: true,
                padding: const EdgeInsets.all(kGap4),
                // onTapOutside: (event, focusNode) {
                //   // focusNode.unfocus();
                // },
              ),
            ),
          )
        ],
      ),
    );
  }
}