class TitleData {
  int currentActiveScene;
  int gameSetMass, setBar, setScore, setLife;
  boolean change;
  boolean customInputMode;
  int customSelectedMode;
  int powCount;
  boolean isKeyReception;
  boolean effecting;
  
  int selectingScene;
  
  float r = 125f;
  float bigR = 700;
  float[] t = new float[]{0f,0.4f,0.8f,0f};
  
  int warnFrame = 60;
  int warnFrameMax = warnFrame;
  boolean drawWarn;
  
  PImage logo;
  PImage back;
  PImage cir;
  
  //Movie back;

  int PWidth = GameData.WINDOW_SIZE_X;
  int PHeight = GameData.WINDOW_SIZE_Y;
  float ScaleW = 1.0;
  float ScaleH = 1.0;
}
