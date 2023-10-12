import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:flame/components.dart';

class BallSettings{
  Vector2 initialVelocity;
  Vector2 maxVelocity;
  Vector2 gravity;
  BallSettings({
    required this.initialVelocity,
    required this.maxVelocity,
    required this.gravity,
  });
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
    1: BallSettings(initialVelocity: Vector2(0, 400), maxVelocity: Vector2(200, 400), gravity: Vector2(0, 2)),
    2: BallSettings(initialVelocity: Vector2(0, 500), maxVelocity: Vector2(250, 500), gravity: Vector2(0, 3)),
  };

  final Map<int, PaddleSettings> paddleConfig = {
    1: PaddleSettings(speedMultiplier: 25),
    2: PaddleSettings(speedMultiplier: 30),
  };

  final Map<int, BrickSettings> brickConfig = {
    1: BrickSettings(strength: 1, numBricks: 10),
    2: BrickSettings(strength: 2, numBricks: 20),
  };

  

  Vector2 get initialVelocity{
    if (ballConfig[level] != null){
      return ballConfig[level]!.initialVelocity;
    }
    return Vector2.zero();
  }
  
  Vector2 get maxVelocity{
    if (ballConfig[level] != null){
      return ballConfig[level]!.maxVelocity;
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