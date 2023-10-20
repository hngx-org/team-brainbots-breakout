import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:flame/components.dart';

class BallSettings{
  final Vector2 initialVelocity;
  final Vector2 maxVelocity;
  final Vector2 gravity;
  BallSettings({
    required this.initialVelocity,
    required this.maxVelocity,
    required this.gravity,
  });
}

class PaddleSettings{
  final double speedMultiplier;
  PaddleSettings({required this.speedMultiplier});
}

class BrickSettings{
  final double strength;
  final int patternCount;
  BrickSettings({required this.strength, required this.patternCount});
}

class PowerUpSettings {
  final Vector2 velocity;
  final Duration duration;

  PowerUpSettings({
    required this.velocity,
    required this.duration
  });
}

class LevelManager extends Component with HasGameRef<Breakout>{
  int level;
  final int maxLevel = 9;
  LevelManager({this.level = 1});

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
    1: BrickSettings(strength: 2, patternCount: 49),
    2: BrickSettings(strength: 2, patternCount: 50),
    3: BrickSettings(strength: 2, patternCount: 60),
    4: BrickSettings(strength: 2, patternCount: 70),
    5: BrickSettings(strength: 2, patternCount: 80),
    6: BrickSettings(strength: 2, patternCount: 90),
    7: BrickSettings(strength: 2, patternCount: 100),
    8: BrickSettings(strength: 2, patternCount: 110),
    9: BrickSettings(strength: 2, patternCount: 120),
  };

  final Map<int, BallSettings> ballConfig =  {
    1: BallSettings(initialVelocity: Vector2(0, 50), maxVelocity: Vector2(25.0, 60), gravity: Vector2(0, 0.2)),
    2: BallSettings(initialVelocity: Vector2(0, 55), maxVelocity: Vector2(27.5, 65), gravity: Vector2(0, 0.3)),
    3: BallSettings(initialVelocity: Vector2(0, 60), maxVelocity: Vector2(30.0, 70), gravity: Vector2(0, 0.4)),
    4: BallSettings(initialVelocity: Vector2(0, 65), maxVelocity: Vector2(32.5, 75), gravity: Vector2(0, 0.5)),
    5: BallSettings(initialVelocity: Vector2(0, 70), maxVelocity: Vector2(35.0, 80), gravity: Vector2(0, 0.6)),
    6: BallSettings(initialVelocity: Vector2(0, 75), maxVelocity: Vector2(37.5, 85), gravity: Vector2(0, 0.7)),
    7: BallSettings(initialVelocity: Vector2(0, 80), maxVelocity: Vector2(40.0, 90), gravity: Vector2(0, 0.8)),
    8: BallSettings(initialVelocity: Vector2(0, 90), maxVelocity: Vector2(45.0, 95), gravity: Vector2(0, 0.9)),
    9: BallSettings(initialVelocity: Vector2(0, 100), maxVelocity: Vector2(50.0, 120), gravity: Vector2(0, 1.0)),
  };
  final Map<int, PowerUpSettings> powerUpConfig = {
    1: PowerUpSettings(velocity: Vector2(0, 50), duration: const Duration(seconds: 15)),
    2: PowerUpSettings(velocity: Vector2(0, 55), duration: const Duration(seconds: 15)),
    3: PowerUpSettings(velocity: Vector2(0, 60), duration: const Duration(seconds: 8)),
    4: PowerUpSettings(velocity: Vector2(0, 65), duration: const Duration(seconds: 8)),
    5: PowerUpSettings(velocity: Vector2(0, 70), duration: const Duration(seconds: 8)),
    6: PowerUpSettings(velocity: Vector2(0, 75), duration: const Duration(seconds: 8)),
    7: PowerUpSettings(velocity: Vector2(0, 80), duration: const Duration(seconds: 8)),
    8: PowerUpSettings(velocity: Vector2(0, 85), duration: const Duration(seconds: 8)),
    9: PowerUpSettings(velocity: Vector2(0, 90), duration: const Duration(seconds: 8)),
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

  double get brickStrength{
    if (brickConfig[level] != null){
      return brickConfig[level]!.strength;
    }
    return 0;
  }

  int get numPatterns{
    if (brickConfig[level] != null){
      return brickConfig[level]!.patternCount;
    }
    return 0;
  }

  Vector2 get powerUpVelocity{
    if (powerUpConfig[level] != null){
      return powerUpConfig[level]!.velocity;
    }
    return Vector2.zero();
  }

  Duration get powerUpDuration{
    if(powerUpConfig[level] != null){
      return powerUpConfig[level]!.duration;
    }
    return const Duration(seconds: 0);
  }
}