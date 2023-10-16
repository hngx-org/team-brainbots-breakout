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
class ExtraBallSettings{
  Vector2 initialVelocity;
  Vector2 maxVelocity;
  Vector2 gravity;
  ExtraBallSettings({
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

class PowerUpSettings {
  Vector2 velocity;

  PowerUpSettings({required this.velocity});
}

class LevelManager extends Component with HasGameRef<Breakout>{
  int level;
  int maxLevel = 9;
  LevelManager({this.level = 1});

  final Map<int, BallSettings> ballConfig =  {
    1: BallSettings(initialVelocity: Vector2(0, 50), maxVelocity: Vector2(25.0, 50), gravity: Vector2(0, 0.2)),
    2: BallSettings(initialVelocity: Vector2(0, 55), maxVelocity: Vector2(27.5, 55), gravity: Vector2(0, 0.3)),
    3: BallSettings(initialVelocity: Vector2(0, 60), maxVelocity: Vector2(30.0, 60), gravity: Vector2(0, 0.4)),
    4: BallSettings(initialVelocity: Vector2(0, 65), maxVelocity: Vector2(32.5, 65), gravity: Vector2(0, 0.5)),
    5: BallSettings(initialVelocity: Vector2(0, 70), maxVelocity: Vector2(35.0, 70), gravity: Vector2(0, 0.6)),
    6: BallSettings(initialVelocity: Vector2(0, 75), maxVelocity: Vector2(37.5, 75), gravity: Vector2(0, 0.7)),
    7: BallSettings(initialVelocity: Vector2(0, 80), maxVelocity: Vector2(40.0, 80), gravity: Vector2(0, 0.8)),
    8: BallSettings(initialVelocity: Vector2(0, 90), maxVelocity: Vector2(45.0, 90), gravity: Vector2(0, 0.9)),
    9: BallSettings(initialVelocity: Vector2(0, 100), maxVelocity: Vector2(50.0, 100), gravity: Vector2(0, 1.0)),
  };
  final Map<int, ExtraBallSettings> extraBallConfig =  {
    1: ExtraBallSettings(initialVelocity: Vector2(0, 50), maxVelocity: Vector2(25.0, 50), gravity: Vector2(0, 0.2)),
    2: ExtraBallSettings(initialVelocity: Vector2(0, 55), maxVelocity: Vector2(27.5, 55), gravity: Vector2(0, 0.3)),
    3: ExtraBallSettings(initialVelocity: Vector2(0, 60), maxVelocity: Vector2(30.0, 60), gravity: Vector2(0, 0.4)),
    4: ExtraBallSettings(initialVelocity: Vector2(0, 65), maxVelocity: Vector2(32.5, 65), gravity: Vector2(0, 0.5)),
    5: ExtraBallSettings(initialVelocity: Vector2(0, 70), maxVelocity: Vector2(35.0, 70), gravity: Vector2(0, 0.6)),
    6: ExtraBallSettings(initialVelocity: Vector2(0, 75), maxVelocity: Vector2(37.5, 75), gravity: Vector2(0, 0.7)),
    7: ExtraBallSettings(initialVelocity: Vector2(0, 80), maxVelocity: Vector2(40.0, 80), gravity: Vector2(0, 0.8)),
    8: ExtraBallSettings(initialVelocity: Vector2(0, 90), maxVelocity: Vector2(45.0, 90), gravity: Vector2(0, 0.9)),
    9: ExtraBallSettings(initialVelocity: Vector2(0, 100), maxVelocity: Vector2(50.0, 100), gravity: Vector2(0, 1.0)),
  };

  final Map<int, PaddleSettings> paddleConfig = {
    1: PaddleSettings(speedMultiplier: 4.0),
    2: PaddleSettings(speedMultiplier: 4.5),
    3: PaddleSettings(speedMultiplier: 5.0),
    4: PaddleSettings(speedMultiplier: 5.5),
    5: PaddleSettings(speedMultiplier: 6.0),
    6: PaddleSettings(speedMultiplier: 6.5),
    7: PaddleSettings(speedMultiplier: 7.0),
    8: PaddleSettings(speedMultiplier: 7.5),
    9: PaddleSettings(speedMultiplier: 8.0),
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

  final Map<int, PowerUpSettings> powerUpConfig = {
    1: PowerUpSettings(velocity: Vector2(0, 50)),
    2: PowerUpSettings(velocity: Vector2(0, 55)),
    3: PowerUpSettings(velocity: Vector2(0, 60)),
    4: PowerUpSettings(velocity: Vector2(0, 65)),
    5: PowerUpSettings(velocity: Vector2(0, 70)),
    6: PowerUpSettings(velocity: Vector2(0, 75)),
    7: PowerUpSettings(velocity: Vector2(0, 80)),
    8: PowerUpSettings(velocity: Vector2(0, 85)),
    9: PowerUpSettings(velocity: Vector2(0, 90)),
  };

  Vector2 get powerUpVelocity{
    if (powerUpConfig[level] != null){
      return powerUpConfig[level]!.velocity;
    }
    return Vector2.zero();
  }

  Vector2 get initialVelocity{
    if (ballConfig[level] != null){
      return ballConfig[level]!.initialVelocity;
    }
    return Vector2.zero();
  }
  Vector2 get extraBallVelocity{
    if (extraBallConfig[level] != null){
      return extraBallConfig[level]!.initialVelocity;
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
  Vector2 get extraBallMaxVelocity{
    if (extraBallConfig[level] != null){
      return extraBallConfig[level]!.maxVelocity;
    }
    return Vector2.zero();
  }

  Vector2 get extraBallGravity{
    if (extraBallConfig[level] != null){
      return extraBallConfig[level]!.gravity;
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