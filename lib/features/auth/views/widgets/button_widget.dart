import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final Color color;
  
  const ButtonWidget({
    Key? key,
    required this.title,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Material(
        color: Colors.white,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: color,
            border:Border.all(
              color: color,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
