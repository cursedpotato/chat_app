//----------------
// Utility widgets
//----------------
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MeasureSizeRenderObject extends RenderProxyBox {
  MeasureSizeRenderObject(this.onChange);
  void Function(Size size) onChange;

  Size _prevSize = Size.zero;
  @override
  void performLayout() {
    super.performLayout();
    Size newSize = child!.size;
    if (_prevSize == newSize) return;
    _prevSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) => onChange(newSize));
  }
}

class MeasurableWidget extends SingleChildRenderObjectWidget {
  const MeasurableWidget(
      {Key? key, required this.onChange, required Widget child})
      : super(key: key, child: child);
  final void Function(Size size) onChange;
  @override
  RenderObject createRenderObject(BuildContext context) =>
      MeasureSizeRenderObject(onChange);
}

// Flutter hasn't implemented yet the option to open the keyboard without the need of a textfield
class PreventKeyboardClosing extends HookWidget {
  const PreventKeyboardClosing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode()..requestFocus();
    return SizedBox.shrink(
      child: TextField(
        focusNode: focusNode,
        showCursor: false,
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }
}
