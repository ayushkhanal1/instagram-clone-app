import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    required this.hinttext,
    this.ispass=false,
    required this.textEditingController,
    required this.textinputtype,
  });
  final TextEditingController textEditingController;
  final bool ispass;
  final String hinttext;
  final TextInputType textinputtype;

  @override
  Widget build(BuildContext context) {
    final inputborder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hinttext,
          focusedBorder: inputborder,
          border:inputborder,
          enabledBorder: inputborder,
          filled: true,
          contentPadding: const EdgeInsets.all(8)),
      keyboardType: textinputtype,
      obscureText: ispass,
    );
  }
}
