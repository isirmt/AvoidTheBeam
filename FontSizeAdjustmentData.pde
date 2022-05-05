void SetTextSize(String drawText, int maxTextSize, int maxWidth) { // 画面外に出ないように強制的にフォントサイズを自動調整 重いかも
  int smallSize = 0;
  while (true) {
    textSize(maxTextSize-smallSize);
    if (textWidth(drawText) < maxWidth) {
      break;
    } else {
      smallSize++;
    }
  }
}
