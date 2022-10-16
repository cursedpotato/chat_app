import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MicWidget extends HookWidget {
  const MicWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(child: TextField(autofocus: true, showCursor: false, decoration: InputDecoration(border: InputBorder.none),));
  }
}