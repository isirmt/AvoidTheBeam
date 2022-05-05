class SceneChange{
  SceneChangeBall[] ball;
  
  private int max = 5;
  
  private int time,timeMax;
  private float exTimeRate, fadeTimeRate;
  private boolean fading;
  
  private String str;
  
  SceneChange(int _time, String _str){
    max += (int)random(0,3);
    ball = new SceneChangeBall[max];
    str = _str;
    for(int i = 0; i < max; i++){
      if (i == 0){
        ball[i] = new SceneChangeBall(0+random(0,50),random(0,800)-800);
      }else if (i == max-1){
        ball[i] = new SceneChangeBall(650+random(0,50),random(0,800)-800);
      }else{
        ball[i] = new SceneChangeBall(random(0,GameData.WINDOW_SIZE_X),random(0,800)-800);
      }
    }
    
    time = _time;
    timeMax = time;
    
    exTimeRate = 0.5f;
    fadeTimeRate = 0.8f;
    
    fading = false;
  }
  
  void Update(){
    if (timeMax == 0) return;
    time--;
    for(int i = 0; i < max; i++){
      if (time == (int)(timeMax*(1-exTimeRate))){
        ball[i].Explode(12);
      }
      if (time == (int)(timeMax*(1-fadeTimeRate))){
        fading = true;
        ball[i].Fade(time);
      }
      ball[i].Update();
    }
    
  }
  
  boolean FadeOutStart(){
    return fading;
  }
  
  void Draw(){
    if (timeMax == 0) return;
    for(int i = 0; i < max; i++){
      ball[i].Draw();
    }
    
    if (time < timeMax*(1-exTimeRate) && time > (int)(timeMax*(1-fadeTimeRate))){
      textAlign(CENTER);
      fill(255);
      noStroke();
      textSize(70);
      text(str,GameData.WINDOW_SIZE_X/2,GameData.WINDOW_SIZE_Y/2);
      textAlign(LEFT);
    }
  }
}
