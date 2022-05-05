class Score {
  private double score;
  private double scoreBefore;
  private int level;
  final static int baseDivide = 160;
  final static int divideInterval = 5;
  private boolean scoreUp;
  private int scoreUpTime;

  private double totalScoreDiv;

  Score() {
    scoreUp = false;
    scoreUpTime = -1;
    score = 0;
    level = 1;
    totalScoreDiv = 0;
  }
  public void ScoreAdd(int add) {
    score += add;
    gameObj.AddAnnounce("+"+add);
  }
  public double GetScore() {
    return score;
  }
  public int GetLevel() {
    return level;
  }
  private void LevelUp() {
    while (totalScoreDiv + baseDivide + divideInterval * level * level - score <= 0) {
      if (totalScoreDiv + baseDivide + divideInterval * level * level - score <= 0) {
        totalScoreDiv += baseDivide + divideInterval * level * level;
        level++;
        String s = " LEVEL UP! ";
        for (int i = 0; i < s.length(); i++) {
          gameObj.AddAnnounce(s.substring(i, i+1));
        }
        gameObj.player.SetLevelWave();
      }
    }
  }
  public void Update() {
    LevelUp();
    if (score != scoreBefore) {
      scoreUp = true;
      scoreUpTime = 20;
    } else if (scoreUp) {
      scoreUpTime--;
      if (scoreUpTime < 0) scoreUp = false;
    }

    scoreBefore = score;
  }
  public void Draw() {
    if (scoreUpTime > 0) stroke(226, 104, 58);
    else stroke(0, 0, 0);
    strokeWeight(3);
    fill(GameData.WHITE, GameData.WHITE, GameData.WHITE, GameData.DEF_ALPHA);
    rect(25, 35, 200, 190);
    noStroke();
    blendMode(BLEND);
    fill(0);
    String pasteText;
    if (gameObj.score.GetScore() <= 2147483647) {
      pasteText = "SCORE: \t"+(int)(gameObj.score.GetScore());
      SetTextSize(pasteText, 25, 180);
      text(pasteText, 35, 80);
    } else {
      pasteText = "SCORE: \t"+(gameObj.score.GetScore());
      SetTextSize(pasteText, 25, 180);
      text(pasteText, 35, 80);
    }
    pasteText = "LEVEL:  \t"+gameObj.score.GetLevel();
    SetTextSize(pasteText, 25, 180);
    text(pasteText, 35, 130);
    textSize(12);
    if (totalScoreDiv + baseDivide + divideInterval * level * level - score <= 2147483647) {
      pasteText = (int)(totalScoreDiv + baseDivide + divideInterval * level * level - score)+" Scores To The Next Level";
      SetTextSize(pasteText, 12, 180);
      text(pasteText, 35, 140);
    } else {
      pasteText = (totalScoreDiv + baseDivide + divideInterval * level * level - score)+" Scores To The Next Level";
      SetTextSize(pasteText, 12, 180);
      text(pasteText, 35, 140);
    }
    pasteText = "BARS:   \t"+gameObj.oneBars*2;
    SetTextSize(pasteText, 25, 180);
    text(pasteText, 35, 180);
    textSize(11);
    text("2 Increase For Every "+gameObj.barsIncreasingInterval+" Levels", 35, 190);
    if (gameObj.modeLevel >= 49 && gameObj.modeLevel <= 57) {
      text("LEVEL: "+(gameObj.modeLevel-48), 28, 50);
    } else if (gameObj.modeLevel == 48) {
      text("LEVEL: ∞", 28 + random(0, 1), 50 + random(0, 1) );
    } else {
      text("LEVEL: Custom", 28, 50);
    }
    pasteText = gameObj.massSize+" x "+gameObj.massSize;
    SetTextSize(pasteText, 11, 50);
    text(pasteText, 160, 220);
    pasteText = "GameTime: "+gameObj.gameTime;
    SetTextSize(pasteText, 11, 100);
    text(pasteText, 30, 220);
    pasteText = "From "+gameObj.startBars*2+" Bars..., Base Score: "+gameObj.scoreBase+", Lives: "+gameObj.startPlayerLives;
    SetTextSize(pasteText, 11, 190);
    text(pasteText, 30, 205);
  }
}
