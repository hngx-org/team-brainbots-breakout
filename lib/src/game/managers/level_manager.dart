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
  int maxLevel = 9;
  LevelManager({this.level = 1});

  final Map<int, BallSettings> ballConfig =  {
    1: BallSettings(initialVelocity: Vector2(0, 500), maxVelocity: Vector2(250, 500), gravity: Vector2(0, 2)),
    2: BallSettings(initialVelocity: Vector2(0, 600), maxVelocity: Vector2(350, 600), gravity: Vector2(0, 3)),
    3: BallSettings(initialVelocity: Vector2(0, 700), maxVelocity: Vector2(350, 700), gravity: Vector2(0, 4)),
    4: BallSettings(initialVelocity: Vector2(0, 800), maxVelocity: Vector2(400, 800), gravity: Vector2(0, 5)),
    5: BallSettings(initialVelocity: Vector2(0, 900), maxVelocity: Vector2(450, 900), gravity: Vector2(0, 6)),
    6: BallSettings(initialVelocity: Vector2(0, 1000), maxVelocity: Vector2(500, 1000), gravity: Vector2(0, 7)),
    7: BallSettings(initialVelocity: Vector2(0, 1100), maxVelocity: Vector2(550, 1100), gravity: Vector2(0, 8)),
    8: BallSettings(initialVelocity: Vector2(0, 1150), maxVelocity: Vector2(575, 1150), gravity: Vector2(0, 9)),
    9: BallSettings(initialVelocity: Vector2(0, 1200), maxVelocity: Vector2(600, 1200), gravity: Vector2(0, 10)),
  };

  final Map<int, PaddleSettings> paddleConfig = {
    1: PaddleSettings(speedMultiplier: 40),
    2: PaddleSettings(speedMultiplier: 45),
    3: PaddleSettings(speedMultiplier: 50),
    4: PaddleSettings(speedMultiplier: 55),
    5: PaddleSettings(speedMultiplier: 60),
    6: PaddleSettings(speedMultiplier: 65),
    7: PaddleSettings(speedMultiplier: 70),
    8: PaddleSettings(speedMultiplier: 75),
    9: PaddleSettings(speedMultiplier: 80),
  };

  final Map<int, BrickSettings> brickConfig = {
    1: BrickSettings(strength: 1, numBricks: 14),
    2: BrickSettings(strength: 1, numBricks: 21),
    3: BrickSettings(strength: 1, numBricks: 28),
    4: BrickSettings(strength: 1, numBricks: 28),
    5: BrickSettings(strength: 1, numBricks: 35),
    6: BrickSettings(strength: 1, numBricks: 35),
    7: BrickSettings(strength: 1, numBricks: 42),
    8: BrickSettings(strength: 1, numBricks: 42),
    9: BrickSettings(strength: 1, numBricks: 49),
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