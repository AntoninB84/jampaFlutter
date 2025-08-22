import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/ui/widgets/custom_text_field.dart';
import 'package:jampa_flutter/ui/widgets/error_text.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';

class NoteTitleTextField extends StatefulWidget {
  const NoteTitleTextField({super.key});

  @override
  State<NoteTitleTextField> createState() => _NoteTitleTextFieldState();
}

class _NoteTitleTextFieldState extends State<NoteTitleTextField> {

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
    return BlocConsumer<CreateNoteCubit, CreateNoteState>(
      listener: (context, state){
        if(state.note != null){
          _textEditingController.text = state.note!.title;
        }
      },
      listenWhen: (previous, current) {
        // Only listen for changes in the note
        return previous.note != current.note;
      },
      builder: (context, state) {
        return CustomTextField(
            controller: _textEditingController,
            onChanged: (value) => context.read<CreateNoteCubit>().onNameChanged(value),
            hintText: context.strings.create_note_title_field_hint,
            errorWidget: !state.isValidTitle ? ErrorText(
                errorText: (){
                  if ((state.title.displayError?.isEmpty ?? false) || (state.title.displayError?.isInvalidLength ?? false)) {
                    return context.strings.create_note_title_invalid_length;
                  }
                  return context.strings.generic_error_message;
                }()
            ) : null
        );
      },
    );
  }
}