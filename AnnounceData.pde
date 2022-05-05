class Announce {
  public int x = 100, y;
  private int fontSize = 20;
  private String str;
  private int life;
  private int defY = 300;
  private int logTime;

  Announce(int row, String s) {
    y = defY+(row-1)*fontSize;
    str = s;
    life = 180;
    logTime = gameObj.gameTime;
  }

  void RowChange(int row) {
    y = defY+(row-1)*fontSize;
  }
  void Update() {
    life--;
  }
  void Draw() {
    noStroke();
    blendMode(BLEND);
    fill(color(GameData.WHITE, GameData.WHITE, GameData.WHITE, GameData.DEF_ALPHA));
    if (life <= 20) {
      fill(GameData.WHITE, 255/20*life); // 時間経過で透明化
    }
    textSize(fontSize);
    SetTextSize(str, fontSize, 150);
    rect(x-fontSize*2.2-5, y-fontSize+2, fontSize*2.2+textWidth(str)+10, fontSize, 3);
    noStroke();
    blendMode(BLEND);
    fill(0);
    if (life <= 20) {
      fill(0, 255/20*life);
    }
    SetTextSize("["+logTime+"]", fontSize/2, fontSize*(int)2.2);
    text("["+logTime+"]", x-fontSize*2.2, y);
    SetTextSize(str, fontSize, 150);
    text(str, x, y);
  }
  int GetLife() {
    return life;
  }
}
