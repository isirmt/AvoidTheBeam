public class Unit {
  protected float x, y;
  protected float sizeX, sizeY;
  protected int laserFiringLifeMax = 30;
  protected int laserLife = 100 + laserFiringLifeMax;
  protected int laserLifeMax = laserLife - laserFiringLifeMax;
  protected color mainLaserFillColor;
  protected color primaryLaserFillColor = color(228, 9, 247);
  protected color baseFillColor = color(247, 188, 136);

  protected color hitPlayerColor = color(0, 0, 0);
  protected int maxWidth;
  private int scoreBase;

  protected boolean hitPlayer = false;

  protected int laserLeftEnd, laserRightEnd, laserTopEnd, laserBottomEnd;

  protected float[] attackingArea = {0, 0, 0, 0};

  Unit(int _maxWidth, int _scoreBase) {
    scoreBase = _scoreBase;
    maxWidth = _maxWidth;
    if (maxWidth > GameData.SCROLL_MASS) {
      laserLeftEnd = (int)GameData.LEFT_WALL;
      laserTopEnd = (int)GameData.TOP_WALL;
      laserRightEnd = (int)GameData.LEFT_WALL+(int)GameData.BASE_SIZE*maxWidth;
      laserBottomEnd = (int)GameData.TOP_WALL+(int)GameData.BASE_SIZE*maxWidth;
    }
  }

  int GetDefaultLife() {
    return laserLifeMax;
  }

  void Update() { // decrease life and collide
    laserLife--;
    if (laserLife < 0) laserLife = -1;
    if (GetFiring()) {
      CollideOfPlayer();
    }
  }

  public float GetAttackingArea(int num) {
    return attackingArea[num];
  }

  protected boolean GetWhetherOuterDrawArea() {
    if (x-gameObj.camera.x + sizeX > 0 && y-gameObj.camera.y + sizeY > 0 &&
      x-gameObj.camera.x < GameData.WINDOW_SIZE_X && y-gameObj.camera.y < GameData.WINDOW_SIZE_X) return false;
    return true;
  }

  private void CollideOfPlayer() {
    if (!gameObj.player.isHavingLife || gameObj.player.isDying || gameObj.player.isInvincible) return;
    if (attackingArea[0] < gameObj.player.GetPosition(2) && attackingArea[1] < gameObj.player.GetPosition(3) &&
      attackingArea[2] > gameObj.player.GetPosition(0) && attackingArea[3] > gameObj.player.GetPosition(1)) {
      gameObj.player.Died();
      hitPlayer = true;
    } else gameObj.score.ScoreAdd(scoreBase);
  }

  protected void SetAttackingArea() {
    attackingArea[0] = x;
    attackingArea[1] = y;
    attackingArea[2] = x+sizeX;
    attackingArea[3] = y+sizeY;
  }

  boolean GetFiring() {
    return laserLife == laserFiringLifeMax;
  }
  void BaseDraw() {
    fill(baseFillColor);
    rect(x-gameObj.camera.x, y-gameObj.camera.y, sizeX, sizeY);
    fill(primaryLaserFillColor);
  }

  void Draw() {
  }

  int GetLife() {
    return laserLife;
  }

  void Wave(float x, float y) {
    noFill();
    strokeWeight(2);
    stroke(color(180, 180, 180, 255/laserFiringLifeMax*laserLife));
    rect(x-(attackingArea[2]-attackingArea[0])/4/laserFiringLifeMax*(laserFiringLifeMax-laserLife), y-(attackingArea[3]-attackingArea[1])/4/laserFiringLifeMax*(laserFiringLifeMax-laserLife), attackingArea[2]-attackingArea[0]+(attackingArea[2]-attackingArea[0])/2/laserFiringLifeMax*(laserFiringLifeMax-laserLife), attackingArea[3]-attackingArea[1]+(attackingArea[3]-attackingArea[1])/2/laserFiringLifeMax*(laserFiringLifeMax-laserLife));
  }
};
