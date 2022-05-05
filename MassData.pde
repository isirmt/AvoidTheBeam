class Mass {
  private int x, y;
  private int size;
  private color col;
  private color activeCol;
  private color drawCol;
  private int fadeoutTime = 45;
  private int fadeoutTimeMax = fadeoutTime;
  private boolean isFadeouting = false;

  private boolean isPlayerStamping = false;
  ;

  Mass(int _x, int _y) {
    x = _x;
    y = _y;
    col = 0;
    size = 50;
    activeCol = color(154, 173, 237);
    drawCol = col;
  }

  void Update() {
    if (x < gameObj.player.GetPosition(2) && y < gameObj.player.GetPosition(3) &&
      x+size > gameObj.player.GetPosition(0) && y+size > gameObj.player.GetPosition(1)) {
      drawCol = activeCol;
      isPlayerStamping = true;
      isFadeouting = false;
      fadeoutTime = fadeoutTimeMax;
    } else {
      if (drawCol != col && !isFadeouting) {
        isFadeouting = true;
      }
      isPlayerStamping = false;
      drawCol = col;
      if (isFadeouting) {
        fadeoutTime--;
        if (fadeoutTime < 0) {
          isFadeouting = false;
          fadeoutTime = fadeoutTimeMax;
        }
      }
    }
  }
  boolean GetPlayerStamping() {
    return isPlayerStamping;
  }

  void Draw() {
    if (GetWhetherOuterDrawArea()) {
      return;
    }
    blendMode(BLEND);
    strokeWeight(1);
    stroke(0);
    if (isPlayerStamping) { // 踏んでいる
      stroke(color(51, 90, 219));
      strokeWeight(2);
    }
    if (gameObj.player.isDying) { // ダメージタイル
      stroke(color(234, 21, 143));
      strokeWeight(2);
    }
    if (drawCol != 0) {
      if (!gameObj.player.isDying)
        fill(drawCol);
      else fill(color(234, 21, 143));
    } else noFill();
    if (isFadeouting) fill(color(154, 173, 237, 255/fadeoutTimeMax * fadeoutTime)); // フェードアウト
    rect(x-gameObj.camera.x, y-gameObj.camera.y, size, size); // これ以外エフェクト
  }

  protected boolean GetWhetherOuterDrawArea() {
    if (x-gameObj.camera.x + size > 0 && y-gameObj.camera.y + size > 0 &&
      x-gameObj.camera.x < GameData.WINDOW_SIZE_X && y-gameObj.camera.y < GameData.WINDOW_SIZE_X) {
      return false;
    }
    return true;
  }
}
