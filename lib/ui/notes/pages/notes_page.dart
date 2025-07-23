import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jampa_flutter/ui/notes/pages/notes_layout.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Page'),
      ),
      body: NotesLayout()
    );
  }
}