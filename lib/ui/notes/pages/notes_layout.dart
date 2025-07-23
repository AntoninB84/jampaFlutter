import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotesLayout extends StatelessWidget {
  const NotesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            context.goNamed("NoteDetails", pathParameters: {'id': '12345'});
          },
          child: const Text("Note Details Page"),
        ),
        SizedBox(height: 10,),
        TextButton(
          onPressed: () {
            context.pushNamed("Test");
          },
          child: const Text("Test Page"),
        )
      ],
    );
  }
}