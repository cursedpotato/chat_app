String displayText(int listLength) {
  if (listLength > 1 && listLength < 5) {
    return "${listLength - 1}+";
  } else if (listLength > 4) {
    return "${listLength - 4}+";
  }
  return "";
}
