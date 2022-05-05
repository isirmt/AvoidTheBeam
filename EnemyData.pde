public class LeftBeam extends Unit { // 基本同じ　パラメータがかなり違うだけ
  public float sx, sy;
  LeftBeam(int _maxWidth, int _scoreBase, int lifeMode) {// mode 0 default another 
    super(_maxWidth, _scoreBase);
    if (maxWidth > GameData.SCROLL_MASS) {
      x = laserLeftEnd;
    } else x = 0f;
    y = 250f + ((int)random(0, maxWidth)*50f);
    if (lifeMode != 0) {
      laserLifeMax = lifeMode;
      laserLife = laserLifeMax + laserFiringLifeMax;
    }
    if (maxWidth > GameData.SCROLL_MASS) {
      sizeX = laserRightEnd - laserLeftEnd;
    } else sizeX = (float)GameData.WINDOW_SIZE_X;
    sizeY = 50f;
    mainLaserFillColor = color(33 + (int)random(0, 30), 250 + (int)random(-30, 30), 206 + (int)random(-30, 30));
    SetAttackingArea();
  }
  void Draw() {
    if (GetWhetherOuterDrawArea()) {
      return;
    }
    //if (GetWhetherOuterDrawArea()) return;
    noStroke();
    blendMode(MULTIPLY);
    if (laserLife >= (laserFiringLifeMax)) {
      BaseDraw(); // 予測線
      rect(x-gameObj.camera.x, y-gameObj.camera.y, (sizeX/(laserLifeMax))*(laserLifeMax-laserLife+laserFiringLifeMax), sizeY); // 経過線
    } else {
      fill(mainLaserFillColor);
      if (hitPlayer) {
        stroke(hitPlayerColor);
        strokeWeight(3);
      }
      rect(x-gameObj.camera.x, y+((sizeY/(laserFiringLifeMax)) * laserFiringLifeMax-laserLife)/2-gameObj.camera.y, sizeX, ((sizeY/(laserFiringLifeMax)) * laserLife)); // エフェクト
      Wave(x-gameObj.camera.x, y-gameObj.camera.y);
    }
    blendMode(BLEND);
  }
};
public class TopBeam extends Unit {
  public float sx, sy;
  TopBeam(int _maxWidth, int _scoreBase, int lifeMode) {// pos 0 1 2
    super(_maxWidth, _scoreBase);
    x = 250f + ((int)random(0, maxWidth)*50f);
    if (maxWidth > GameData.SCROLL_MASS) {
      y = laserTopEnd;
    } else y = 0;
    if (lifeMode != 0) {
      laserLifeMax = lifeMode;
      laserLife = laserLifeMax + laserFiringLifeMax;
    }
    sizeX = 50f;
    if (maxWidth > GameData.SCROLL_MASS) {
      sizeY = laserBottomEnd-laserTopEnd;
    } else sizeY = (float)GameData.WINDOW_SIZE_Y;
    mainLaserFillColor = color(115 + (int)random(-30, 30), 25+ (int)random(0, 30), 245 + (int)random(-30, 10));
    SetAttackingArea();
  }
  void Draw() {
    if (GetWhetherOuterDrawArea()) {
      return;
    }
    //if (GetWhetherOuterDrawArea()) return;
    noStroke();
    blendMode(MULTIPLY);
    if (laserLife >= (laserFiringLifeMax)) {
      BaseDraw();
      rect(x-gameObj.camera.x, y-gameObj.camera.y, sizeX, (sizeY/(laserLifeMax))*(laserLifeMax-laserLife+laserFiringLifeMax));
    } else {
      if (hitPlayer) {
        stroke(hitPlayerColor);
        strokeWeight(3);
      }
      fill(mainLaserFillColor);
      rect(x-gameObj.camera.x+((sizeX/(laserFiringLifeMax)) * laserFiringLifeMax-laserLife)/2, y-gameObj.camera.y, ((sizeX/(laserFiringLifeMax)) * laserLife), sizeY);
      Wave(x-gameObj.camera.x, y-gameObj.camera.y);
    }
    blendMode(BLEND);
  }
};
