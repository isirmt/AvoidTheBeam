class Camera {
  public float x, y;
  private int massSize;

  private boolean isMotionBluring = false;
  private int motionBlurFrame = 16;
  private int motionBlurFrameMax = motionBlurFrame;
  private int blurSize = 25;

  Camera(int _massSize) {
    x = 0f;
    y = 0f;
    massSize = _massSize;
  }

  void Update() {
    if (massSize <= GameData.SCROLL_MASS) {
      x = 0f;
      y = 0f;
    } else {
      x = gameObj.player.x - GameData.LEFT_WALL - GameData.SCROLL_SHIFT;
      y = gameObj.player.y - GameData.LEFT_WALL - GameData.SCROLL_SHIFT;
    }

    if (isMotionBluring) { // モーションブラー ランダムでずらしながら移動
      motionBlurFrame--;
      if (motionBlurFrame >= motionBlurFrameMax/2) {
        x += blurSize/(motionBlurFrameMax/2)*(motionBlurFrameMax-motionBlurFrame)+random(0, blurSize/10);
        y += blurSize/(motionBlurFrameMax/2)*(motionBlurFrameMax-motionBlurFrame)+random(0, blurSize/10);
      } else if (motionBlurFrame >= 0) {
        x += blurSize-blurSize/(motionBlurFrameMax/2)*(motionBlurFrameMax-motionBlurFrame)+random(0, blurSize/10);
        y += blurSize-blurSize/(motionBlurFrameMax/2)*(motionBlurFrameMax-motionBlurFrame)+random(0, blurSize/10);
      } else {
        isMotionBluring = false;
      }
    }
  }

  void OnMotionBlur() {
    isMotionBluring = true;
    motionBlurFrame = motionBlurFrameMax;
  }
}
