import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// TODO: Do necessary implementations for iOS for flutter sound
class MicWidget extends HookWidget {
  const MicWidget({Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();

    AnimationController opacityController =
        useAnimationController(duration: const Duration(milliseconds: 800))
          ..repeat(reverse: true);

    useEffect(() {
      focusNode.requestFocus();
      return () {
        focusNode.dispose();
      };
    });

    ValueNotifier<double> centerPosition = useState(0.0);

    return Expanded(
      child: MeasurableWidget(
        onChange: (size) {
          centerPosition.value = size.width * 0.40;
        },
        child: SizedBox(
          height: 48,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: opacityController,
                        curve: Curves.easeIn,
                      ),
                      child: const Icon(
                        Icons.surround_sound_outlined,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('0:01'),
                  ],
                ),
              ),
              SizedBox(
                height: 0,
                width: 0,
                child: TextField(
                  focusNode: focusNode,
                  showCursor: false,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),

              Positioned(
                top: 10,
                left: centerPosition.value,
                child: Row(
                  children: const [
                    Text('slide to cancel'),
                    Icon(Icons.arrow_back_ios_new_outlined)
                  ],
                ),
              ),
              // We place this whole widget to avoid the keyboard from closing, giving the user a bad experience
            ],
          ),
        ),
      ),
    );
  }
}

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
