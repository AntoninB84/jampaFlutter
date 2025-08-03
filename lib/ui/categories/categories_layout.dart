
import 'package:flutter/cupertino.dart';

class CategoriesLayout extends StatelessWidget {
  const CategoriesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            // Navigate to categories details or perform an action
          },
          child: const Text("Categories Page"),
        ),
        SizedBox(height: 10,),
        TextButton(
          onPressed: () {
            // Navigate to another page or perform an action
          },
          child: const Text("Test Page"),
        )
      ],
    );
  }
}