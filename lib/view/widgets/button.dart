import 'package:flutter/material.dart';

import '../../utils/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.onPressed, required this.text}) : super(key: key);
  final Function() onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(100,45),
        primary: primaryClr,
      ),
    );
  }
}
