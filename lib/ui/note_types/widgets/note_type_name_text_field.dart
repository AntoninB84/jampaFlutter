import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/note_types/save/save_note_type_cubit.dart';
import 'package:jampa_flutter/ui/widgets/inputs/custom_text_field.dart';
import 'package:jampa_flutter/ui/widgets/error_text.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';

/// A text field for entering the name of a note type.
class NoteTypeNameTextField extends StatefulWidget {
  const NoteTypeNameTextField({super.key});

  @override
  State<NoteTypeNameTextField> createState() => _NoteTypeNameTextFieldState();
}

class _NoteTypeNameTextFieldState extends State<NoteTypeNameTextField> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveNoteTypeCubit, SaveNoteTypeState>(
      listener: (context, state){
        if(state.noteType != null){
          _textEditingController.text = state.noteType!.name;
        }
      },
      listenWhen: (previous, current) {
        // Only listen for changes in the noteType
        return previous.noteType != current.noteType;
      },
      builder: (context, state) {
        return CustomTextField(
            controller: _textEditingController,
            onChanged: (value) => context.read<SaveNoteTypeCubit>().onNameChanged(value),
            hintText: context.strings.create_note_type_name_field_hint,
            errorWidget: (!state.isValidName || state.existsAlready) ? ErrorText(
                errorText: (){
                  if ((state.name.displayError?.isEmpty ?? false) || (state.name.displayError?.isInvalidLength ?? false)) {
                    return context.strings.create_note_type_name_invalid_length;
                  }else if (state.existsAlready) {
                    return context.strings.create_note_type_name_exists_already;
                  }
                  return context.strings.generic_error_message;
                }()
            ) : null
        );
      },
    );
  }
}