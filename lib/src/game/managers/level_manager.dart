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
    1: BallSettings(initialVelocity: Vector2(0, 400), maxVelocity: Vector2(200, 400), gravity: Vector2(0, 2)),
    2: BallSettings(initialVelocity: Vector2(0, 500), maxVelocity: Vector2(250, 500), gravity: Vector2(0, 3)),
    3: BallSettings(initialVelocity: Vector2(0, 600), maxVelocity: Vector2(300, 600), gravity: Vector2(0, 4)),
    4: BallSettings(initialVelocity: Vector2(0, 600), maxVelocity: Vector2(300, 600), gravity: Vector2(0, 5)),
    5: BallSettings(initialVelocity: Vector2(0, 700), maxVelocity: Vector2(350, 700), gravity: Vector2(0, 6)),
    6: BallSettings(initialVelocity: Vector2(0, 700), maxVelocity: Vector2(350, 700), gravity: Vector2(0, 7)),
    7: BallSettings(initialVelocity: Vector2(0, 800), maxVelocity: Vector2(400, 800), gravity: Vector2(0, 8)),
    8: BallSettings(initialVelocity: Vector2(0, 900), maxVelocity: Vector2(450, 900), gravity: Vector2(0, 9)),
    9: BallSettings(initialVelocity: Vector2(0, 1000), maxVelocity: Vector2(500, 1000), gravity: Vector2(0, 10)),
  };

  final Map<int, PaddleSettings> paddleConfig = {
    1: PaddleSettings(speedMultiplier: 25),
    2: PaddleSettings(speedMultiplier: 30),
    3: PaddleSettings(speedMultiplier: 35),
    4: PaddleSettings(speedMultiplier: 35),
    5: PaddleSettings(speedMultiplier: 40),
    6: PaddleSettings(speedMultiplier: 40),
    7: PaddleSettings(speedMultiplier: 50),
    8: PaddleSettings(speedMultiplier: 50),
    9: PaddleSettings(speedMultiplier: 50),
  };

  final Map<int, BrickSettings> brickConfig = {
    1: BrickSettings(strength: 1, numBricks: 30),
    2: BrickSettings(strength: 2, numBricks: 40),
    3: BrickSettings(strength: 2, numBricks: 50),
    4: BrickSettings(strength: 2, numBricks: 60),
    5: BrickSettings(strength: 2, numBricks: 70),
    6: BrickSettings(strength: 2, numBricks: 80),
    7: BrickSettings(strength: 2, numBricks: 90),
    8: BrickSettings(strength: 2, numBricks: 90),
    9: BrickSettings(strength: 2, numBricks: 100),
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