part of 'media_preview_widget.dart';

class _ImgPrevTextField extends HookConsumerWidget {
  const _ImgPrevTextField({Key? key, required this.imageFileList})
      : super(key: key);

  final List<File> imageFileList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 32,
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextField(
                controller: textController,
                maxLength: 800,
                minLines: 1,
                maxLines: 5, // This way the textfield grows
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  // This hides the counter that appears when you set a chat limit
                  counterText: "",
                  hintText: "Image description...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ref.read(messagesVMProvider.notifier).sendMediaMessage(
                    context,
                    imageFileList,
                    textController.text,
                  );
            },
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
