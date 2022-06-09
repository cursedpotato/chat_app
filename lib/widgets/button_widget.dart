import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  
  final Function()? onTap;
  const ButtonWidget({
    Key? key,
    required this.title,

    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      // TODO: Make color theme
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.blue,
          border:Border.all(
            color: Colors.blue,
            width: 1.0
          ) 
        ),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 60,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  // TODO: Assign color theme
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
