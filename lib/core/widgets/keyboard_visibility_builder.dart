import 'package:flutter/material.dart';

class KeyboardVisibilityBuilder extends StatefulWidget {
  final Widget child;
  final void Function(Offset position) onPositionChange;
  final Widget Function(
    BuildContext context,
    Widget child,
    bool isKeyboardVisible,
  ) builder;

  const KeyboardVisibilityBuilder({
    Key? key,
    required this.child,
    required this.builder,
    required this.onPositionChange,
  }) : super(key: key);

  @override
  State<KeyboardVisibilityBuilder> createState() =>
      _KeyboardVisibilityBuilderState();
}

class _KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;
  GlobalKey key = GlobalKey();
  RenderBox? renderBox;
  Offset currentPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    renderBox = key.currentContext!.findRenderObject() as RenderBox?;

    Offset newPosition = renderBox!.localToGlobal(const Offset(-8.0, 0.0));

    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;

    final newValue = bottomInset > 0.0;

    setState(() {
      currentPosition = newPosition;
      widget.onPositionChange(currentPosition);
    });
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        key: key,
        child: widget.builder(
          context,
          widget.child,
          _isKeyboardVisible,
        ),
      );
}
