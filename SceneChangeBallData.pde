class SceneChangeBall{
  private float vx, vy, x, y;
  private float fy;
  private color col;
  private int size;
  private int sizeAfter;
  private int boundNum;
  private int exFrame,exFrameMax;
  private int fadeFrame, fadeFrameMax;
  private float fadeDistance;
  
  private boolean falling;
  private boolean exploding;
  private boolean fading;
  
  SceneChangeBall(float _x, float _y){
    x = _x;
    y = _y;
    col = color(53+(int)random(0,30),223,189+(int)random(0,20));
    size = 20+(int)random(0,30);
    sizeAfter = 2000;
    vx = 0;
    vy = 0;
    fy = 1.21f;
    falling = true;
    exploding = false;
    fading = false;
    boundNum = 0;
  }
  
  void Update(){
    if (falling){
      vy += fy;
      if (boundNum > 0 && vy > 0){
        Fix();
      }
    
      x = x + vx;
      y = y + vy;
      
      if (y>GameData.WINDOW_SIZE_Y-size/2){
        y = GameData.WINDOW_SIZE_Y-size/2;
        vy = -vy*0.6;
        vx = vx*0.9;
        boundNum++;
      }
    }
    if (exploding){
      exFrame--;
      if (exFrame >= 0){
        size += (sizeAfter-size)/exFrameMax;
      }
    }
    if (fading){
      fadeFrame--;
      y += fadeDistance/fadeFrameMax;
    }
  }
  
  void Explode(int _frame){
    Fix();
    exploding = true;
    exFrame = _frame;
    exFrameMax = exFrame;
  }
  
  void Fade(int _frame){
    Fix();
    fading = true;
    fadeFrame = _frame;
    fadeFrameMax = fadeFrame;
    fadeDistance = (GameData.WINDOW_SIZE_Y-y)+sizeAfter;
  }
  
  private void Fix(){
    falling = false;
    vx = 0; vy = 0;
  }
  
  void Draw(){
    fill(col);
    strokeWeight(2);
    stroke(250);
    if (exploding){
      noStroke();
    }
    ellipse(x,y,size,size);
    blendMode(BLEND);
  }
}
