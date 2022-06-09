import 'package:chat_app/modelview/signin_modelview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData? suffixIconData;
  final bool obscureText;
  final Function(String)? onChanged;

  const TextFieldWidget({
    Key? key,
    required this.hintText,
    required this.prefixIconData,
    this.suffixIconData,
    required this.obscureText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SingInModel>(context);
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
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
        suffixIcon: GestureDetector(
          onTap: () {
            model.isVisible = !model.isVisible;
          },
          child: Icon(
            suffixIconData,
            size: 18,
            // TODO: Assign color theme
            color: Colors.blue,
          ),
        ),
        // TODO: Assign color theme
        labelStyle: const TextStyle(color: Colors.blue),
        focusColor: Colors.blue,
      ),
    );
  }
}
