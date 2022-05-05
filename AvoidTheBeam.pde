ObjectData gameObj;
Keys keys;
TitleData title;
SceneChange sc;

void settings() {
  if (displayWidth >= displayHeight) { // ディスプレイサイズの短辺に対して 2/3 のサイズの正方形に指定
    size(displayHeight * 2 / 3, displayHeight * 2 / 3); // 基準として700x700の正方形ウインドウを拡大縮小表示する
  } else {
    size(displayWidth * 2 / 3, displayWidth * 2 / 3);
  }
}

void setup() {
  frameRate(60);
  background(GameData.WHITE, GameData.WHITE, GameData.WHITE);
  title = new TitleData();

  PSurface suf = this.getSurface();
  suf.setTitle("Avoid The Beam"); // ウインドウバータイトル
  PImage icon;
  icon = loadImage("./data/icon.png"); // 必須アイコン
  suf.setIcon(icon);
  //suf.setResizable( true ); // これをオンにすると軽減処理の実態がわかる

  title.logo = loadImage("./data/logo.png");
  //title.back = new Movie(this, "bk.mp4");
  //title.back.loop();

  title.back = loadImage("./data/bk.png");

  title.gameSetMass = 3;
  title.setBar = 1;
  title.setScore = 50;
  title.setLife = 3;
  ChangeScene(1,"Avoid The Beam");
  title.selectingScene = 1;
  title.change = false;
  title.drawWarn = false;
  keys = new Keys(); // 基本パラメータ設定
}

void draw() {

  if (title.PWidth != width || title.PHeight!=height) { // ウインドウサイズ関係
    title.ScaleW *= (float)width / title.PWidth;
    title.ScaleH *= (float)height / title.PHeight;
    title.PWidth = width;
    title.PHeight = height;
  }

  scale(title.ScaleW, title.ScaleH);

  background(GameData.WHITE, GameData.WHITE, GameData.WHITE); // 白は目に悪いため統一
  switch(title.currentActiveScene) {
  case 1: // タイトルシーン

    image(title.back, 0, 0);

    textSize(40);
    textAlign(CENTER, BASELINE);
    noStroke();
    fill(color(33, 250, 206, GameData.DEF_ALPHA));
    rect(0, 60, GameData.WINDOW_SIZE_X/5, 40);
    if (!title.customInputMode) {
      rect(0, GameData.WINDOW_SIZE_Y-60, GameData.WINDOW_SIZE_X/2, 40);
    } else {
      rect(0, GameData.WINDOW_SIZE_Y-60, GameData.WINDOW_SIZE_X/5, 40);
    }
    fill(color(115, 25, 245, GameData.DEF_ALPHA));
    rect(GameData.WINDOW_SIZE_X-GameData.WINDOW_SIZE_X/5, 60, GameData.WINDOW_SIZE_X/5, 40);
    if (!title.customInputMode) {
      rect(GameData.WINDOW_SIZE_X/2, GameData.WINDOW_SIZE_Y-60, GameData.WINDOW_SIZE_X/2, 40);
    } else {
      rect(GameData.WINDOW_SIZE_X-GameData.WINDOW_SIZE_X/5, GameData.WINDOW_SIZE_Y-60, GameData.WINDOW_SIZE_X/5, 40); // ここまでタイトルの2色バー
    }

    image(title.logo, 165, 47, width/2, height/11);
    fill(220,170,170, GameData.DEF_ALPHA/10);
    title.t[3] += 0.04f;
    /*
    fill(100);
     blendMode(SCREEN);
     text("Avoid The Beam", GameData.WINDOW_SIZE_X/2+3, 100);
     fill(0);
     blendMode(BLEND);
     text("Avoid The Beam", GameData.WINDOW_SIZE_X/2, 100); // タイトル描画
     */
    textSize(25);
    textAlign(LEFT, BOTTOM);
    for (int i = 0; i < 10; i++) {

      if (i != 9) {
        DrawBox(250, 130 + 50 * i, color(245 - i*10, 56 + i *5, 100+ i *15), (10-i)+3);
        fill(0);
        text("LEVEL "+(i+1), 300, 155 + 50 * i);
      } else {
        DrawBox(250, 130 + 50 * i, color(245 - random(10, 100), 56, 100+ i *15), -1);
        fill(0);
        text("LEVEL ∞", 300 + random(0, 1), 155 + random(0, 1) + 50 * i); // レベル∞の時のみrand振動
      }
      if (i == 0 || i == 5 || i == 9) {
        textSize(13);
        text("RECOMMENDATION!", 400, 155 + 50 * i); // 制作者のイチオシ
        textSize(25);
      }
    }
    if (keyPressed && !title.customInputMode) { // 難易度パラメータ調整
      title.setScore = 50;
      title.setLife = 3;
      String s = "";
      switch(key) {
      case '1':
        title.change = true;
        title.gameSetMass = 8;
        title.setBar = 1;
        s = "LEVEL 1";
        break;
      case '2':
        title.change = true;
        title.gameSetMass = 6;
        title.setBar = 1;
        s = "LEVEL 2";
        break;
      case '3':
        title.change = true;
        title.gameSetMass = 5;
        title.setBar = 1;
        s = "LEVEL 3";
        break;
      case '4':
        title.change = true;
        title.gameSetMass = 5;
        title.setBar = 2;
        s = "LEVEL 4";
        break;
      case '5':
        title.change = true;
        title.gameSetMass = 4;
        title.setBar = 2;
        s = "LEVEL 5";
        break;
      case '6':
        title.change = true;
        title.gameSetMass = 12;
        title.setBar = 6;
        s = "LEVEL 6";
        break;
      case '7':
        title.change = true;
        title.gameSetMass = 20;
        title.setBar = 10;
        s = "LEVEL 7";
        break;
      case '8':
        title.change = true;
        title.gameSetMass = 40;
        title.setBar = 25;
        s = "LEVEL 8";
        break;
      case '9':
        title.change = true;
        title.gameSetMass = 50;
        title.setBar = 35;
        s = "LEVEL 9";
        break;
      case '0':
        title.change = true;
        title.gameSetMass = 3;
        title.setBar = 1;
        s = "LEVEL INFINITY";
        break;
      case 'x':
        title.change = false;
        title.customInputMode = true;
        title.customSelectedMode = 1;
        break;
      default:
        title.change = false;
        break;
      }
      if (title.change){
        ChangeScene(2,s); // 遷移
      }
    }
    if (title.customInputMode) { // カスタム指定 xキー
      if (title.customSelectedMode == 1) {
        textSize(20);
        fill(0);
        textAlign(CENTER);
        text("Mass : "+title.gameSetMass, GameData.WINDOW_SIZE_X/2, GameData.WINDOW_SIZE_Y-30); // MASS
        if (keyPressed && title.isKeyReception) {
          if (key >= 48 && key <= 57) {
            title.powCount++;
            title.gameSetMass = title.gameSetMass*10+key-48;
            title.isKeyReception = false;
            if (title.gameSetMass < 0) title.gameSetMass *= -1;
          }
          if (key == '\n' && title.isKeyReception) {
            title.customSelectedMode = 2;
            title.isKeyReception = false;
          }
          if (key == BACKSPACE && title.isKeyReception) {
            title.powCount--;
            title.gameSetMass = (int)(title.gameSetMass / 10);
            title.isKeyReception = false;
          }
        }
      } else if (title.customSelectedMode == 2) {
        textSize(20);
        fill(0);
        textAlign(CENTER);
        text("Bars : "+title.setBar, GameData.WINDOW_SIZE_X/2, GameData.WINDOW_SIZE_Y-30); // BARS
        if (keyPressed && title.isKeyReception) {
          if (key >= 48 && key <= 57) {
            title.powCount++;
            title.setBar = title.setBar*10+key-48;
            title.isKeyReception = false;
            if (title.setBar < 0) title.setBar *= -1;
          }
          if (key == '\n' && title.isKeyReception) {
            title.customSelectedMode = 3;
            title.isKeyReception = false;
          }
          if (key == BACKSPACE && title.isKeyReception) {
            title.powCount--;
            title.setBar = (int)(title.setBar / 10);
            title.isKeyReception = false;
          }
        }
      } else if (title.customSelectedMode == 3) {
        textSize(20);
        fill(0);
        textAlign(CENTER);
        text("ScoreBase : "+title.setScore, GameData.WINDOW_SIZE_X/2, GameData.WINDOW_SIZE_Y-30); // SCORE
        if (keyPressed && title.isKeyReception) {
          if (key >= 48 && key <= 57) {
            title.powCount++;
            title.setScore = title.setScore*10+key-48;
            title.isKeyReception = false;
            if (title.setScore < 0) title.setScore *= -1;
          }
          if (key == '\n' && title.isKeyReception) {
            title.customSelectedMode = 4;
            title.isKeyReception = false;
          }
          if (key == BACKSPACE && title.isKeyReception) {
            title.powCount--;
            title.setScore = (int)(title.setScore / 10);
            title.isKeyReception = false;
          }
        }
      } else if (title.customSelectedMode == 4) {
        textSize(20);
        fill(0);
        textAlign(CENTER);
        text("Lives : "+title.setLife, GameData.WINDOW_SIZE_X/2, GameData.WINDOW_SIZE_Y-30); // Life
        if (keyPressed && title.isKeyReception) {
          if (key >= 48 && key <= 57) {
            title.powCount++;
            title.setLife = title.setLife*10+key-48;
            title.isKeyReception = false;
            if (title.setLife < 0) title.setLife *= -1;
          }
          if (key == '\n' && title.isKeyReception) {
            ChangeScene(2,"LEVEL CUSTOM");
            title.isKeyReception = false;
          }
          if (key == BACKSPACE && title.isKeyReception) {
            title.powCount--;
            title.setLife = (int)(title.setLife / 10);
            title.isKeyReception = false;
          }
        }
      }
      if (key == 'z' && title.isKeyReception && keyPressed) {
        title.customInputMode = false;
      }
    } else {
      blendMode(SCREEN);
      fill(250, GameData.DEF_ALPHA/2);
      noStroke();
      for (int i = 0; i < 3; i++) {
        title.t[i] += 0.12f;
        ellipse(350+(float)title.r*(float)cos(title.t[i]), GameData.WINDOW_SIZE_Y-40, 10, 10);
      }
      blendMode(BLEND);
    }
    textSize(15);
    fill(0);
    textAlign(CENTER);
    if (!title.customInputMode) {
      text("[1]~[9] & [0]: Select Difficult , [x] : Custom", GameData.WINDOW_SIZE_X/2, GameData.WINDOW_SIZE_Y-5);
    } else {
      text("[0]~[9] : Input Value , [Enter] : Enter , [BS] : Delete , [z] Back To Select", GameData.WINDOW_SIZE_X/2, GameData.WINDOW_SIZE_Y-5);
    }
    break;
  case 2: // ゲーム画面
    textAlign(LEFT, BASELINE);
    gameObj.Update();
    gameObj.Draw();
    if (keyPressed) { // 遷移
      if (key == 'r'){
        ChangeScene(1, "Avoid The Beam");
      }
    }
    break;
  }
  if (title.effecting){
    ChangeSceneProcess(title.selectingScene);
  }
  if (title.drawWarn){
    title.warnFrame--;
    if (title.warnFrame <= 0) title.drawWarn = false;
    fill(250,250,250,200);
    stroke(121,11,97);
    strokeWeight(2);
    rect(-30,GameData.WINDOW_SIZE_Y-100,GameData.WINDOW_SIZE_X+60,100);
    textSize(20);
    fill(154,14,122);
    noStroke();
    textAlign(CENTER);
    text("This game is For KEYBOARD ONLY",GameData.WINDOW_SIZE_X/2,GameData.WINDOW_SIZE_Y-50);
    textAlign(LEFT);
  }
  sc.Update();
  sc.Draw();
}

void ChangeScene(int num, String str) { // 遷移用
  title.selectingScene = num;
  title.effecting = true;
  sc = new SceneChange(120,str);
}

void ChangeSceneProcess(int num){
  if (sc.FadeOutStart()){
    title.currentActiveScene = num;
    title.effecting = false;
    switch(title.currentActiveScene) {
    case 1:
      title.powCount = 1;
      title.customInputMode = false;
      title.customSelectedMode = 1;
      title.isKeyReception = true;
      break;
    case 2:
      textAlign(LEFT, BASELINE);
      gameObj = new ObjectData(title.gameSetMass, title.setBar, key, title.setScore, title.setLife);
      break;
    }
  }
}

void DrawBox(int x, int y, color col, int rad) {
  stroke(color(0, 0, 0));
  fill(col);
  strokeWeight(2);
  if (rad != -1) {
    rect(x, y, 25, 25, rad);
  } else {
    rect(x, y, 25, 25, 3, 13, 3, 13);
  }
}

void keyPressed() {
  if (keyCode == 'W' || keyCode == 'A' || keyCode == 'S' || keyCode == 'D') {
    keys.ChangeBool(false);
    if (keyCode == 'A') keys.left = true;
    if (keyCode == 'D') keys.right = true;
    if (keyCode == 'W') keys.up = true;
    if (keyCode == 'S') keys.down = true;
  }
  if (keyCode == SHIFT) keys.shift = true;
}

void keyReleased() {
  if (keyCode == 'A') keys.left = false;
  if (keyCode == 'D') keys.right = false;
  if (keyCode == 'W') keys.up = false;
  if (keyCode == 'S') keys.down = false;
  if (keyCode == SHIFT) keys.shift = false;
  title.isKeyReception = true;
}

void mousePressed(){
  title.warnFrame = title.warnFrameMax;
  title.drawWarn = true;
}
