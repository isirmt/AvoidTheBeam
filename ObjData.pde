class ObjectData {
  public Camera camera;
  public Player player;
  public Score score;
  public LeftBeam leftBeam[];
  public TopBeam topBeam[];
  public Announce announce[];
  public Mass massTile[][];
  public int massSize;
  final static int MAX_ANNOUNCE = 20;
  public int oneBars = 1;
  public int startBars;
  private int barsIncreasingInterval = 5;
  private int gameTopicLeftEnd = 450;
  private int gameTopicTopEnd = 50;
  private int scoreBase;

  private int activeTileIndex1[];
  private int activeTileIndex2[];

  private int oneHeartFrame;
  private int oneHeartFrameMax = 60;

  public int modeLevel;
  public int startPlayerLives;

  private boolean isBarIncreasing = false;
  private int increacingBarFrame = 30;
  private int increacingBarFrameMax = increacingBarFrame;

  private boolean gameover = false;

  private int gameTime;

  private int dyingSlowSpeed = 2;
  private int dyingZeroLifeSlowSpeed = dyingSlowSpeed * 2;

  private int backGroundTime;

  ObjectData(int _massSize, int _oneBars, int _level, int _scoreBase, int _lives) {
    camera = new Camera(_massSize);
    player = new Player(_massSize, _lives);
    score = new Score();
    massSize = _massSize;
    oneBars = _oneBars;
    startBars = oneBars;
    oneHeartFrame = 0;
    modeLevel = _level;
    startPlayerLives = _lives;
    scoreBase = _scoreBase;

    activeTileIndex1 = new int[4];
    activeTileIndex2 = new int[4];

    for (int i = 0; i < 4; i++) {
      activeTileIndex1[i] = -1;
      activeTileIndex2[i] = -1;
    }

    massTile = new Mass[massSize][massSize];
    for (int i = 0; i < massSize; i++)
      for (int j = 0; j < massSize; j++) {
        Mass m = new Mass(250+i*50, 250+j*50);
        massTile[i][j] = m;
      }

    leftBeam = new LeftBeam[oneBars];//0
    for (int i = 0; i < oneBars; i++) {
      RechargeLeftBeam(i);
    }
    topBeam = new TopBeam[oneBars];//1
    for (int i = 0; i < oneBars; i++) {
      RecheageTopBeam(i);
    }
    announce = new Announce[MAX_ANNOUNCE];
    for (int i = 0; i < MAX_ANNOUNCE; i++) {
      announce[i] = null;
    }
    gameTime = 0;
    backGroundTime = 0;
  }

  public void RechargeLeftBeam(int array) {
    if (array == 0) {
      LeftBeam l = new LeftBeam(massSize, scoreBase, 0);
      leftBeam[0] = l;
    } else {
      LeftBeam l = new LeftBeam(massSize, scoreBase, (int)(massSize+(leftBeam[0].GetDefaultLife()*GameData.SCROLL_MASS/massSize*random(0.4, 1.3))));
      leftBeam[array] = l;
    }
  }
  public void RecheageTopBeam(int array) {
    if (array == 0) {
      TopBeam baseTopBeam = new TopBeam(massSize, scoreBase, 0);
      topBeam[0] = baseTopBeam;
    } else {
      TopBeam baseTopBeam = new TopBeam(massSize, scoreBase, (int)(massSize+(leftBeam[0].GetDefaultLife()*GameData.SCROLL_MASS/massSize*random(0.4, 1.3))));
      topBeam[array] = baseTopBeam;
    }
  }

  private void BarCheck() {
    if ((float)score.GetLevel() / (float)barsIncreasingInterval >= 1f && oneBars != startBars + score.GetLevel() / barsIncreasingInterval) {
      oneBars = startBars + score.GetLevel() / barsIncreasingInterval;
      isBarIncreasing = true;
      increacingBarFrame = increacingBarFrameMax;
      String s = " BARS "+oneBars*2+"! ";
      for (int i = 0; i < s.length(); i++) {
        gameObj.AddAnnounce(s.substring(i, i+1));
      }
      leftBeam = new LeftBeam[oneBars];
      topBeam = new TopBeam[oneBars];
      for (int i = 0; i < oneBars; i++) {
        RechargeLeftBeam(i);
      }
      for (int i = 0; i < oneBars; i++) {
        RecheageTopBeam(i);
      }
    }
  }

  void AddAnnounce(String s) {
    AnnounceSort();
    for (int i = 0; i < MAX_ANNOUNCE; i++) {

      if (announce[i] == null) {
        Announce baseAnnounce = new Announce(i+1, s);
        announce[i] = baseAnnounce;
        return;
      }
    }
    AnnouncePush(0);
    Announce baseAnnounce = new Announce(MAX_ANNOUNCE, s);
    announce[MAX_ANNOUNCE-1] = baseAnnounce;
  }

  private void AnnouncePush(int start) {
    for (int i = start; i < MAX_ANNOUNCE-1; i++) {
      if (announce[i] == null) continue;
      announce[i] = announce[i+1];
      if (announce[i] != null) announce[i].RowChange(i+1);
    }
    announce[MAX_ANNOUNCE-1] = null;
  }

  private void AnnounceSort() {
    for (int i = 0; i < MAX_ANNOUNCE-1; i++) {
      if (announce[i] == null) {
        AnnouncePush(i);
        continue;
      }
      if (announce[i].GetLife() < 0) {
        AnnouncePush(i);
      }
    }
  }

  void Update() {
    backGroundTime++;
    if (player.isDying && backGroundTime % dyingSlowSpeed != 0) return;
    if (player.isDying && player.GetLives() <= 0 && backGroundTime % dyingZeroLifeSlowSpeed != 0) return;
    if (massSize <= 0 || oneBars <= 0 || startPlayerLives <= 0) {
      if (gameTime % 180 == 0)
        gameObj.AddAnnounce("OOPS");
      if (gameTime % 180 == 0) {
        if (massSize <= 0 && oneBars > 0 && scoreBase > 0)
          gameObj.AddAnnounce("This SoftWare Will Crash!");
        gameObj.AddAnnounce("Want To Return?");
        gameObj.AddAnnounce("Press [R]");
      }
    }
    camera.Update();

    for (int i = 0; i < massSize; i++)
      for (int j = 0; j < massSize; j++) {
        massTile[i][j].Update();
        if (massTile[i][j].GetPlayerStamping()) {
          for (int k = 0; k<4; k++) {
            if (activeTileIndex1[k] == -1) {
              activeTileIndex1[k] = i;
              activeTileIndex2[k] = j;
              break;
            }
          }
        }
      }
    for (int i = 0; i < oneBars; i++) {
      if (leftBeam[i].GetLife() >= 0) {
        leftBeam[i].Update();
      } else {
        RechargeLeftBeam(i);
      }
      if (topBeam[i].GetLife() >= 0) {
        topBeam[i].Update();
      } else {
        RecheageTopBeam(i);
      }
    }

    player.Update();

    if (player.CheckHavingLife()) gameTime++;
    if (gameTime == 1) player.OnInvincible(300);
    if (gameTime == 180) {
      gameObj.AddAnnounce("Avoid The Beam!");
      gameObj.AddAnnounce("After Invincible,");
      gameObj.AddAnnounce("GAME START");
    }
    if (gameTime % 1800 == 0) {
      gameObj.AddAnnounce(gameTime/60+" Seconds!");
    }

    AnnounceSort(); // Nullを使用しているため，例外処理が起こらないように管理
    BarCheck();
    for (int i = 0; i < MAX_ANNOUNCE; i++) {
      if (announce[i] == null) continue; // 回避
      announce[i].Update();
    }
    score.Update();
    if (!player.CheckHavingLife()) {
      if (!gameover) {
        gameover = true;
      }
    }

    if (player.GetLives() == 1) {
      oneHeartFrame++;
      if (oneHeartFrame >= oneHeartFrameMax) oneHeartFrame = 0;
    }
    if (isBarIncreasing) {
      increacingBarFrame--;
      if (increacingBarFrame <= 0) {
        isBarIncreasing = true;
      }
    }
  }

  void Draw() {
    OutsideMassDraw();
    for (int i = 0; i < massSize; i++)
      for (int j = 0; j < massSize; j++) {
        if (!massTile[i][j].GetPlayerStamping()) {
          massTile[i][j].Draw();
        }
      }
    for (int i = 0; i < 4; i++) {
      if (activeTileIndex1[i] == -1) continue;
      massTile[activeTileIndex1[i]][activeTileIndex2[i]].Draw();
      if (player.isDying) continue;
      activeTileIndex1[i] = -1;
      activeTileIndex2[i] = -1;
    }
    for (int i = 0; i < oneBars; i++) {
      leftBeam[i].Draw();
      topBeam[i].Draw();
    }

    player.Draw();

    for (int i = 0; i < MAX_ANNOUNCE; i++) {
      if (announce[i] == null) continue;
      announce[i].Draw();
    }
    TopicDraw();
    LifeDraw();

    GameOverDraw();
    HelpControlDraw();
    score.Draw();
  }

  void TopicDraw() {
    noStroke();
    blendMode(BLEND);
    fill(color(GameData.WHITE, GameData.WHITE, GameData.WHITE, GameData.DEF_ALPHA));
    rect(gameTopicLeftEnd-15, gameTopicTopEnd-15, 230, 150, 5);
    fill(color(247, 188, 136, GameData.DEF_ALPHA+20));
    blendMode(MULTIPLY);
    rect(gameTopicLeftEnd, gameTopicTopEnd, 100, 20);
    fill(color(228, 9, 247, GameData.DEF_ALPHA+20));
    rect(gameTopicLeftEnd, gameTopicTopEnd, 35, 20);

    fill(color(33, 250, 206, GameData.DEF_ALPHA+20));
    rect(gameTopicLeftEnd, gameTopicTopEnd+50, 100, 20);

    fill(color(115, 25, 245, GameData.DEF_ALPHA+20));
    rect(gameTopicLeftEnd, gameTopicTopEnd+100, 100, 20);

    fill(0);
    textSize(12);
    text("Prediction Line", 560, 65);
    text("AoE Tips", gameTopicLeftEnd+150, gameTopicTopEnd+130);
    text("Attack Line", 560, 140);
    blendMode(BLEND);
  }
  void HelpControlDraw() {
    noStroke();
    blendMode(BLEND);
    fill(color(GameData.WHITE, GameData.WHITE, GameData.WHITE, GameData.DEF_ALPHA));
    rect(GameData.WINDOW_SIZE_X-185, GameData.WINDOW_SIZE_Y-100, 170, 90, 5);
    fill(0);
    textSize(15);
    text("[SHIFT] : DASH(x2)", GameData.WINDOW_SIZE_X-170, GameData.WINDOW_SIZE_Y-80);
    text("[W][A][S][D] : MOVE", GameData.WINDOW_SIZE_X-170, GameData.WINDOW_SIZE_Y-50);
    text("[R] : TITLE", GameData.WINDOW_SIZE_X-170, GameData.WINDOW_SIZE_Y-20);
  }
  void LifeDraw() {
    if (player.GetLives() <= 0) return;
    if (player.GetLives() <= 5) {
      if (oneHeartFrame <= oneHeartFrameMax/2) {
        if (player.GetLives() != 1) {
          for (int i = 0; i < player.GetLives(); i++) {
            stroke(color(GameData.WHITE, GameData.WHITE, GameData.WHITE));
            fill(color(245, 56, 56));
            strokeWeight(2);
            rect(25+i*(35), 230, 25, 25, 3);
          }
        } else {
          stroke(color(GameData.WHITE, GameData.WHITE, GameData.WHITE, 255/oneHeartFrameMax*2*oneHeartFrame));
          fill(color(245, 56, 56, 255/oneHeartFrameMax*2*oneHeartFrame));
          strokeWeight(2);
          rect(25, 230, 25, 25, 3);
        }
      } else {
        stroke(color(GameData.WHITE, GameData.WHITE, GameData.WHITE, 255/oneHeartFrameMax*2*(oneHeartFrameMax-oneHeartFrame)));
        fill(color(245, 56, 56, 255/oneHeartFrameMax*2*(oneHeartFrameMax-oneHeartFrame)));
        strokeWeight(2);
        rect(25, 230, 25, 25, 3);
      }
    } else {
      stroke(color(GameData.WHITE, GameData.WHITE, GameData.WHITE));
      fill(color(245, 56, 56));
      strokeWeight(2);
      rect(25, 230, 25, 25, 3);
      fill(color(GameData.WHITE, GameData.WHITE, GameData.WHITE, GameData.DEF_ALPHA));
      noStroke();
      rect(60, 233, textWidth("x "+player.GetLives())+15, 18, 3);
      fill(0);
      textSize(15);
      text("x "+player.GetLives(), 65, 250);
    }
  }

  void GameOverDraw() {
    if (!gameover) return;
    noStroke();
    blendMode(BLEND);
    fill(color(GameData.WHITE, GameData.WHITE, GameData.WHITE, GameData.DEF_ALPHA));
    rect(0, 0, GameData.WINDOW_SIZE_X, GameData.WINDOW_SIZE_Y);
    fill(0);
    textAlign(CENTER);
    textSize(35);
    text("GAME OVER", GameData.WINDOW_SIZE_X/2, GameData.WINDOW_SIZE_Y/2);
    textAlign(LEFT);
  }
  void OutsideMassDraw() {
    stroke(0);
    noFill();
    strokeWeight(2);
    if (player.isDying) {
      stroke(color(234, 21, 143));
      strokeWeight(4);
    }
    rect(250 - camera.x, 250 - camera.y, GameData.BASE_SIZE*massSize, GameData.BASE_SIZE*massSize);
    if (isBarIncreasing) {
      BarWave(250 - camera.x, 250 - camera.y);
    }
  }
  void BarWave(float x, float y) {
    noFill();
    strokeWeight(5);
    stroke(color(150, 150, 150, 255/increacingBarFrameMax*increacingBarFrame));
    rect(x-GameData.BASE_SIZE*massSize/4/increacingBarFrameMax*(increacingBarFrameMax-increacingBarFrame), y-GameData.BASE_SIZE*massSize/4/increacingBarFrameMax*(increacingBarFrameMax-increacingBarFrame), GameData.BASE_SIZE*massSize+(GameData.BASE_SIZE*massSize)/2/increacingBarFrameMax*(increacingBarFrameMax-increacingBarFrame), GameData.BASE_SIZE*massSize+GameData.BASE_SIZE*massSize/2/increacingBarFrameMax*(increacingBarFrameMax-increacingBarFrame));
  }
}
