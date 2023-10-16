import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/managers/managers.dart';
import 'package:brainbots_breakout/src/game/sprites/paddle.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

enum PowerUpType {
  enlarge,
  shrink,
  extraBall,
  fireBall,
  laser,
  magnet,
  slow,
  fast,
  none
}
String _getPowerupPath(PowerUpType type){
  return switch(type){
    PowerUpType.enlarge => 'game/powerups/enlarge.png',
    PowerUpType.shrink => 'game/powerups/shrink.png',
    PowerUpType.extraBall => 'game/powerups/extra_ball.png',
    PowerUpType.fireBall => 'game/powerups/fire_ball.png',
    PowerUpType.laser => 'game/powerups/laser.png',
    PowerUpType.magnet => 'game/powerups/magnet.png',
    PowerUpType.slow => 'game/powerups/slow.png',
    PowerUpType.fast => 'game/powerups/fast.png',
    PowerUpType.none => '',
  };
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
      final spriteAssetPath = _getPowerupPath(powerUpSelected);
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
      case PowerUpType.enlarge:
        gameRef.setDoublePaddle();
        break;
      case PowerUpType.shrink:
        gameRef.setHalfPaddle();
        break;
      case PowerUpType.extraBall:
        gameRef.setExtraBall();
        break;
      case PowerUpType.fireBall:
      // TODO: Implement the superBall power-up effect.
        break;
      case PowerUpType.laser:
      // TODO: Implement the lazers power-up effect.
        break;
      case PowerUpType.magnet:
      // TODO: Implement the magnet power-up effect.
        break;
      case PowerUpType.slow:
      // TODO: Implement the slowDown power-up effect.
        break;
      case PowerUpType.fast:
      // TODO: Implement the speedUp power-up effect.
        break;
      case PowerUpType.none:
        // TODO: Handle this case.
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += velocity.y * dt;
    if(gameRef.gameManager.state == GameState.gameOver){
      removeFromParent(); // removes the powerup when game is over
    }
  }
}
