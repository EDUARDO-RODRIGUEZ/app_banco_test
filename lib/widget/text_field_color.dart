
import 'package:flutter/material.dart';

class TextFieldColor extends StatelessWidget {
  
  final TextInputType? keyboardType;
  final TextEditingController? textController;
  final Color color;
  final void Function(String)? onChanged;
  final bool obscureText;
  const TextFieldColor({ 
    super.key,
    required this.color,
    required this.textController,
    required this.onChanged,
    required this.keyboardType,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color:color,width: 2)
        )
    );

    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      controller: textController,
      decoration: inputDecoration,
      cursorColor: color,
      onChanged: onChanged
    );
  }
}