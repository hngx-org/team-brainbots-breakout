import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:flame/components.dart';

class BallSpeed{
  Vector2 speed;
  Vector2 gravity;
  BallSpeed({required this.speed, required this.gravity});
}

class LevelManager extends Component with HasGameRef<Breakout>{
  int level;
  LevelManager({this.level = 1});

  final Map<int, BallSpeed> ballConfig =  {
    1: BallSpeed(speed: Vector2(200, 200), gravity: Vector2(0, 20))
  };

  Vector2 get ballSpeed{
    if (ballConfig[level] != null){
      return ballConfig[level]!.speed;
    }
    return Vector2.zero();
  }

  Vector2 get gravity{
    if (ballConfig[level] != null){
      return ballConfig[level]!.gravity;
    }
    return Vector2.zero();
  }
}