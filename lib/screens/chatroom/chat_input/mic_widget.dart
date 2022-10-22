
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    final totalWidth = MediaQuery.of(context).size.width;

    ValueNotifier<double> centerPosition = useState(totalWidth*0.333);

    return Expanded(

      child: SizedBox(
        height: 48,
        child: Stack(
          fit: StackFit.loose,
          children: [
            Slidable(centerPosition: centerPosition),
            Container(
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  // We place this widget to prevent the keyboard from closing, giving the user a bad experience
                  SizedBox(
                    width: 10,
                    child: TextField(
                      focusNode: focusNode,
                      showCursor: false,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const Flexible(child: Text('0:01')),
                  const SizedBox(width: 10,)
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class Slidable extends ConsumerWidget {
  const Slidable({
    Key? key,
    required this.centerPosition,
  }) : super(key: key);

  final ValueNotifier<double> centerPosition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Transform.translate(
      offset: Offset(centerPosition.value - 100,0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:const [
          Text('slide to cancel'),
          SizedBox(height: 48,),
          Icon(Icons.arrow_back_ios_new_outlined),
        ],
      ),
    );
  }
}
