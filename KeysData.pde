class Keys {
  public boolean left, right, up, down, shift;
  Keys() {
    left = false;
    right = false;
    up = false;
    down = false;
    shift = false;
  }
  void ChangeBool(boolean tf) {
    left = tf;
    right = tf;
    up = tf;
    down = tf;
  }
}
