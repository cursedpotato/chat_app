String twoDigits(int n) => n.toString().padLeft(2, '0');

String formatDuration(Duration duration) {
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  final minutes = duration.inMinutes.remainder(60).toString();

  return '$minutes:$seconds';
}
