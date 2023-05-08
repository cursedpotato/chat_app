
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/theme/colors.dart';

class TextFieldWidget extends HookWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData? suffixIconData;
  final TextEditingController controller;
  final bool obscureText;
  final Function(String)? onChanged;
  final Function()? onIconTap;

  const TextFieldWidget({
    Key? key,
    required this.hintText,
    required this.prefixIconData,
    this.onChanged,
    this.onIconTap,
    required this.controller,
    this.suffixIconData,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      style: const TextStyle(
        color: khighlightColor,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: hintText,
        icon: Icon(
          prefixIconData,
          size: 18,
          color: khighlightColor,
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
        suffixIcon: GestureDetector(
          onTap: onIconTap,
          child: Icon(
            suffixIconData,
            size: 18,
            color: khighlightColor,
          ),
        ),
        labelStyle: const TextStyle(color: khighlightColor),
        focusColor: khighlightColor,
      ),
    );
  }
}
