import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/sprites/paddle.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

enum PowerUpType {
  doubleSize,
  halfSize,
  extraBall,
  superBall,
  lazers,
  slowDown,
  speedUp,
  none
}

class PowerUp extends SpriteComponent with HasGameRef<Breakout>, CollisionCallbacks {
  PowerUpType powerUpSelected;
  Vector2 velocity;
  Vector2 powerUpSize;
  Vector2 powerUpPosition;

  PowerUp({
    required this.powerUpSelected,
    required this.powerUpSize,
    required this.powerUpPosition,
    required this.velocity,
  });

  late ShapeHitbox hitbox;
  bool canMove = false;
  bool _hasCollided = false;

  bool get isMoving{
    return canMove ? velocity == Vector2.zero(): false;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    if(powerUpSelected != PowerUpType.none) {
      final spriteAssetPath = '${powerUpSelected
          .toString()
          .split('.')
          .last}.png';
      sprite = await gameRef.loadSprite(spriteAssetPath);

      size = powerUpSize;
      position = powerUpPosition;

        hitbox = RectangleHitbox();

      add(hitbox);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other ){
    if(!_hasCollided){ // ensures the onCollision callback isnt called again till onCollisionEnds
      _hasCollided = true;
    if (other is Paddle) {
      applyPowerUp(game);
      if(isMounted) {
        removeFromParent();
      }
    }}
    super.onCollision(intersectionPoints, other);
  }
  @override
  void onCollisionEnd(PositionComponent other){
    if(_hasCollided){
      _hasCollided = false;
    }
    super.onCollisionEnd(other);
  }


  void applyPowerUp(Breakout game) {
    // Handle power-up effects here based on the powerUpType.
    switch (powerUpSelected) {
      case PowerUpType.doubleSize:
        gameRef.setDoublePaddle();
        break;
      case PowerUpType.halfSize:
        gameRef.setHalfPaddle();
        break;
      case PowerUpType.extraBall:
        gameRef.setExtraBall();
        break;
      case PowerUpType.superBall:
      // TODO: Implement the superBall power-up effect.
        break;
      case PowerUpType.lazers:
      // TODO: Implement the lazers power-up effect.
        break;
      case PowerUpType.slowDown:
      // TODO: Implement the slowDown power-up effect.
        break;
      case PowerUpType.speedUp:
      // TODO: Implement the speedUp power-up effect.
        break;
      case PowerUpType.none:
        // TODO: Handle this case.
    }
  }

  @override
  void update(double dt) {
      position.y += velocity.y * dt;
      super.update(dt);
  }

  @override
  void onRemove() {
    super.onRemove();
    game = null;
  }
}
