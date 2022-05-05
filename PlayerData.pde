public class Player {
  private float x, y;
  private float sizeX, sizeY;
  private float sx, sy;
  private float finalSpeed = 0f;
  private color mainFillColor;

  public boolean isHavingLife = true;
  public boolean isDying = false;
  private int dyingEffectFrame = -1;
  private int dyingEffectFrameMax = 20;
  private int massSize;

  private boolean leveling = false;
  private int levelingEffectFrame = 30;
  private int levelingEffectFrameMax = levelingEffectFrame;

  public boolean isInvincible;
  private int invincibleTime;

  private int deathInvincibleTime = 120;

  private int lives = 3;

  Player(int _massSize, int maxLives) {
    x = random(GameData.LEFT_WALL, GameData.LEFT_WALL+GameData.BASE_SIZE*_massSize-sizeX);
    y = random(GameData.TOP_WALL, GameData.TOP_WALL+GameData.BASE_SIZE*_massSize-sizeX);
    sizeX = 25f;
    sizeY = sizeX;
    sx = 6f;
    sy = sx;
    mainFillColor = color(0, 0, 0);
    massSize = _massSize;
    isHavingLife = true;
    isInvincible = false;
    invincibleTime = 60;
    lives = maxLives;
  }

  boolean CheckHavingLife() {
    return isHavingLife;
  }

  void OnInvincible(int time) {
    isInvincible = true;
    ;
    invincibleTime = time;
    gameObj.AddAnnounce("");
    gameObj.AddAnnounce("Invincible");
    gameObj.AddAnnounce("For "+invincibleTime+" Frame");
    gameObj.AddAnnounce("");
  }

  void SetLevelWave() {
    leveling = true;
    levelingEffectFrame = 30;
  }

  void Update() {
    if (isDying) {
      dyingEffectFrame--;
      if (dyingEffectFrame <= 0) {
        isDying = false;
        OnInvincible(deathInvincibleTime);
        if (lives <= 0) {
          isHavingLife = false;
          gameObj.AddAnnounce("");
          gameObj.AddAnnounce("YOU DIED");
          gameObj.AddAnnounce("");
        }
      }
      return;
    }
    if (isInvincible) {
      invincibleTime--;
      if (invincibleTime <=0) {
        isInvincible = false;
        gameObj.AddAnnounce("");
        gameObj.AddAnnounce("END Invincible");
        gameObj.AddAnnounce("");
      }
    }
    if (leveling) {
      levelingEffectFrame--;
      if (levelingEffectFrame <= 0) {
        leveling = false;
      }
    }
    finalSpeed = 1f * sx;
    if (keys.shift) finalSpeed *= 2f;
    if (keys.up) y -= finalSpeed;
    if (keys.down) y += finalSpeed;
    if (keys.left) x -= finalSpeed;
    if (keys.right) x += finalSpeed;

    if (x <= GameData.LEFT_WALL) {
      x = GameData.LEFT_WALL;
    }
    if (x >= GameData.LEFT_WALL+GameData.BASE_SIZE*massSize - sizeX) {
      x = GameData.LEFT_WALL+GameData.BASE_SIZE*massSize - sizeX;
    }
    if (y <= GameData.TOP_WALL) {
      y = GameData.TOP_WALL;
    }
    if (y >= GameData.TOP_WALL+GameData.BASE_SIZE*massSize - sizeY) {
      y = GameData.TOP_WALL+GameData.BASE_SIZE*massSize - sizeY;
    }
  }

  float GetPosition(int pos) {
    switch (pos) {
    case 0:
      return x;
    case 1:
      return y;
    case 2:
      return x+sizeX;
    case 3:
      return y+sizeY;
    default:
      return -1f;
    }
  }

  public void Died() {
    isDying = true;
    lives--;
    gameObj.AddAnnounce("");
    gameObj.AddAnnounce("-1 Life");
    gameObj.AddAnnounce(lives+" Life Remaining");
    gameObj.AddAnnounce("");
    gameObj.camera.OnMotionBlur();
    dyingEffectFrame = dyingEffectFrameMax;
  }

  public int GetLives() {
    return lives;
  }

  void Draw() {
    if (leveling) {
      if (gameObj.massSize > GameData.SCROLL_MASS) {
        WaveLeveling(GameData.LEFT_WALL + GameData.SCROLL_SHIFT+sizeX/2, GameData.TOP_WALL + GameData.SCROLL_SHIFT+sizeY/2);
      } else {
        WaveLeveling(x+sizeX/2, y+sizeY/2);
      }
    }
    noStroke();
    if (!isDying) {
      fill(mainFillColor);
      if (lives <= 0) {
        fill(GameData.WHITE, GameData.WHITE, GameData.WHITE);
        stroke(0);
        strokeWeight(2);
      }
      if (isInvincible) {
        fill(239, 206, 52);
        stroke(0);
        strokeWeight(2);
      }
      if (keys.shift) {
        stroke(color(29, 158, 159));
        strokeWeight(2);
      }
      if (gameObj.massSize > GameData.SCROLL_MASS) {
        rect(GameData.LEFT_WALL + GameData.SCROLL_SHIFT, GameData.TOP_WALL + GameData.SCROLL_SHIFT, sizeX, sizeY);
      } else {
        rect(x, y, sizeX, sizeY);
      }
    } else {
      noStroke();
      fill(184, 60, 225);
      if (gameObj.massSize > GameData.SCROLL_MASS) {
        rect(GameData.LEFT_WALL + GameData.SCROLL_SHIFT + ((sizeX / dyingEffectFrameMax) * dyingEffectFrameMax - dyingEffectFrame)/2, GameData.TOP_WALL + GameData.SCROLL_SHIFT + ((sizeY / dyingEffectFrameMax) * dyingEffectFrameMax - dyingEffectFrame)/2, ((sizeX / dyingEffectFrameMax) * dyingEffectFrame), ((sizeY / dyingEffectFrameMax) * dyingEffectFrame));
        WaveDying(GameData.LEFT_WALL + GameData.SCROLL_SHIFT + ((sizeX / dyingEffectFrameMax) * dyingEffectFrameMax - dyingEffectFrame)/2+sizeX/2, GameData.TOP_WALL + GameData.SCROLL_SHIFT + ((sizeY / dyingEffectFrameMax) * dyingEffectFrameMax - dyingEffectFrame)/2+sizeY/2);
      } else {
        rect(x + ((sizeX / dyingEffectFrameMax) * dyingEffectFrameMax - dyingEffectFrame)/2-gameObj.camera.x, y + ((sizeY / dyingEffectFrameMax) * dyingEffectFrameMax - dyingEffectFrame)/2-gameObj.camera.x, ((sizeX / dyingEffectFrameMax) * dyingEffectFrame), ((sizeY / dyingEffectFrameMax) * dyingEffectFrame)); // プレイヤー 描画
        WaveDying(x + ((sizeX / dyingEffectFrameMax) * dyingEffectFrameMax - dyingEffectFrame)/2+sizeX/2, y + ((sizeY / dyingEffectFrameMax) * dyingEffectFrameMax - dyingEffectFrame)/2+sizeY/2);
      }
    }
  }
  
  void WaveDying(float x, float y) {
    noFill();
    fill(color(237, 37, 63, 180/dyingEffectFrameMax*dyingEffectFrame));
    strokeWeight(3);
    stroke(color(237, 37, 63, 255/dyingEffectFrameMax*dyingEffectFrame));
    rect(x-250/dyingEffectFrameMax*(dyingEffectFrameMax-dyingEffectFrame), y-250/dyingEffectFrameMax*(dyingEffectFrameMax-dyingEffectFrame), 500/dyingEffectFrameMax*(dyingEffectFrameMax-dyingEffectFrame), 500/dyingEffectFrameMax*(dyingEffectFrameMax-dyingEffectFrame));
  }
  
  void WaveLeveling(float x, float y) {
    noFill();
    strokeWeight(2);
    stroke(color(23, 232, 164, 255/levelingEffectFrameMax*levelingEffectFrame));
    rect(x-125/levelingEffectFrameMax*(levelingEffectFrameMax-levelingEffectFrame), y-125/levelingEffectFrameMax*(levelingEffectFrameMax-levelingEffectFrame), 250/levelingEffectFrameMax*(levelingEffectFrameMax-levelingEffectFrame), 250/levelingEffectFrameMax*(levelingEffectFrameMax-levelingEffectFrame));
  }
}
