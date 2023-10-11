import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:flame/components.dart';

class BallSettings{
  Vector2 velocity;
  Vector2 gravity;
  BallSettings({required this.velocity, required this.gravity});
}

class PaddleSettings{
  double speedMultiplier;
  PaddleSettings({required this.speedMultiplier});
}

class BrickSettings{
  int strength;
  int numBricks;
  BrickSettings({required this.strength, required this.numBricks});
}

class LevelManager extends Component with HasGameRef<Breakout>{
  int level;
  LevelManager({this.level = 1});

  final Map<int, BallSettings> ballConfig =  {
    1: BallSettings(velocity: Vector2(0, 400), gravity: Vector2(0, 2)),
  };

  final Map<int, PaddleSettings> paddleConfig = {
    1: PaddleSettings(speedMultiplier: 100),
  };

  final Map<int, BrickSettings> brickConfig = {
    1: BrickSettings(strength: 1, numBricks: 10),
  };

  

  Vector2 get initialVelocity{
    if (ballConfig[level] != null){
      return ballConfig[level]!.velocity;
    }
    return Vector2.zero();
  }

  Vector2 get gravity{
    if (ballConfig[level] != null){
      return ballConfig[level]!.gravity;
    }
    return Vector2.zero();
  }

  double get paddleSpeedMultiplier{
    if (paddleConfig[level] != null){
      return paddleConfig[level]!.speedMultiplier;
    }
    return 0;
  }

  int get brickStrength{
    if (brickConfig[level] != null){
      return brickConfig[level]!.strength;
    }
    return 0;
  }

  int get numBricks{
    if (brickConfig[level] != null){
      return brickConfig[level]!.numBricks;
    }
    return 0;
  }
}