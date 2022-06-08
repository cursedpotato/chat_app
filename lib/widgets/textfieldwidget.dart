import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData? suffixIconData;
  final bool obsureText;
  final Function(String)? onChanged;

  const TextFieldWidget({
    Key? key,
    required this.hintText,
    required this.prefixIconData,
    this.suffixIconData,
    required this.obsureText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(
        // TODO: Assign color theme
        color: Colors.blue,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: hintText,
        icon: Icon(
          prefixIconData,
          size: 18,
          // TODO: Assign color theme
          color: Colors.blue,
        ),
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Icon(
          suffixIconData,
          size: 18,
          // TODO: Assign color theme
          color: Colors.blue,
        ),
        // TODO: Assign color theme
        labelStyle: const TextStyle(color: Colors.blue),
        focusColor: Colors.blue,
      ),
    );
  }
}
