static public class GameData { // 基礎パラメータ 変更不可

  final static int WINDOW_SIZE_X = 700;
  final static int WINDOW_SIZE_Y = 700;

  final static float SCROLL_LEFT_X = 0;
  final static float SCROLL_LEFT_Y = 0;

  final static float LASER_LEFT_X = 0;
  final static float LASER_LEFT_Y = 0;

  final static float LEFT_WALL = 250f;
  final static float TOP_WALL = 250f;
  final static float BASE_SIZE = 50f;

  final static int SCROLL_MASS = ((int)GameData.WINDOW_SIZE_X - (int)GameData.LEFT_WALL) / (int)GameData.BASE_SIZE - 1;
  final static int SCROLL_SHIFT = 100;

  final static int DEF_ALPHA = 150;

  final static int WHITE = 245;
};
