import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/sprites/ball.dart';
import 'package:brainbots_breakout/src/game/sprites/laser.dart';
import 'package:brainbots_breakout/src/game/sprites/power_up.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum BrickState {normal, cracked}
enum BrickColor
    {blue, brown, cyan, green, grey,lemon, orange, purple, red, yellow}

class Brick extends SpriteGroupComponent with HasGameRef<Breakout>, CollisionCallbacks{
  BrickColor brickColor;
  final Vector2 brickSize;
  final Vector2 brickPosition;
  double strength;
  final bool hasPowerUp;

  Brick({
    required this.brickColor,
    required this.brickSize,
    required this.brickPosition,
    required this.strength,
    required this.hasPowerUp,
  });
  late ShapeHitbox hitbox;
  late BrickState brickState;
  bool _hasCollided = false;
  bool isPowerUpBrickCracked = false;
  double storedBrickStrength = 0.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    Sprite normal = await game.loadSprite('game/bricks/${brickColor.name}.png');
    Sprite cracked = await game.loadSprite('game/bricks/${brickColor.name}_cracked.png');
    sprites = <BrickState, Sprite>{ // adds the two different sprites
      BrickState.normal: normal,
      BrickState.cracked: cracked,
    };
    current = BrickState.normal; // sets the default sprite

    size = brickSize;
    position = brickPosition;

    hitbox = RectangleHitbox();
    add(hitbox); // adds a hitbox for collision callbacks
  }

  @override
  Future<void> onCollision(Set<Vector2> intersectionPoints, PositionComponent other) async{
    if(other is Ball && !_hasCollided){ // the _hasCollided flag ensures that the onCollision is not called again till collision ends
      _hasCollided = true;
        removeFromParent();
        return;
    }
    if(other is Laser && !_hasCollided){ // the _hasCollided flag ensures that the onCollision is not called again till collision ends
      _hasCollided = true;
      // strength -= 0.5;
      if (strength <= 0){
        removeFromParent();
        return;
      }
      if(strength >= 0.1 && strength <= 1){
        if (hasPowerUp && !isPowerUpBrickCracked) {
          final powerUpType = game.gameManager.getRandomPowerUpType(game.levelManager.level);
          var powerUp = PowerUp(
            powerUpType: powerUpType,
            velocity: game.levelManager.powerUpVelocity,
            powerUpSize: size,
            powerUpPosition: position,
          );
          game.add(powerUp);

          isPowerUpBrickCracked = true;
        }
        current = BrickState.cracked;
        return;
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  Future<void> onCollisionEnd(PositionComponent other) async {
    if(_hasCollided){
      game.gameManager.score.value += 1;
      _hasCollided = false;
    }
    super.onCollisionEnd(other);
  }

  @override
  void onRemove(){
    super.onRemove();
    if (hasPowerUp) {
      final powerUpType = game.gameManager.getRandomPowerUpType(game.levelManager.level);
      var powerUp = PowerUp(
        powerUpType: powerUpType,
        velocity: game.levelManager.powerUpVelocity,
        powerUpSize: size,
        powerUpPosition: position,
      );
      game.add(powerUp);
    }
  }
}