import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Calls Screen"),);
  }
}