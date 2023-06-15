import 'package:flutter/material.dart';

class TextButtonColor extends StatelessWidget {
  final Color color;
  final void Function()? onPressed;
  final String text;
  const TextButtonColor({
      super.key,
      required this.color,
      required this.onPressed,
      required this.text
  });
  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(color: color, borderRadius: BorderRadius.circular(10));
    var textStyle = const TextStyle(color: Colors.white);
    return Container(
      decoration: boxDecoration,
      child: TextButton(
          onPressed: onPressed,
          child: Text(text, style: textStyle)
      ),
    );
  }
}
