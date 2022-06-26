import 'package:chat_app/modelview/signin_modelview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData? suffixIconData;
  final TextEditingController controller;
  final bool obscureText;
  final Function(String)? onChanged;

  const TextFieldWidget({
    Key? key,
    required this.hintText,
    required this.prefixIconData,
    this.onChanged, 
    required this.controller,
    this.suffixIconData,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SingInModel>(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      style: const TextStyle(
        // TODO: Assign color theme
        color: Color(0xFF087949),
        fontSize: 14,
      ),
      decoration: InputDecoration(
        
        labelText: hintText,
        icon: Icon(
          prefixIconData,
          size: 18,
          // TODO: Assign color theme
          color: Color(0xFF087949),
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
          onTap: () {
            model.isVisible = !model.isVisible;
          },
          child: Icon(
            suffixIconData,
            size: 18,
            // TODO: Assign color theme
            color: Color(0xFF087949),
          ),
        ),
        // TODO: Assign color theme
        labelStyle: const TextStyle(color: Color(0xFF087949)),
        focusColor: Color(0xFF087949),
      ),
    );
  }
}
