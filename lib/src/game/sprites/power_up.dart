import 'package:brainbots_breakout/src/game/breakout.dart';
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
  };
}

class PowerUp extends SpriteComponent with HasGameRef<Breakout>, CollisionCallbacks {
  PowerUpType powerUpType;
  Vector2 velocity;
  Vector2 powerUpSize;
  Vector2 powerUpPosition;

  PowerUp({
    required this.powerUpType,
    required this.powerUpSize,
    required this.powerUpPosition,
    required this.velocity,
  });

  late ShapeHitbox hitbox;
  bool _hasCollided = false;


  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteAssetPath = _getPowerupPath(powerUpType);
    sprite = await game.loadSprite(spriteAssetPath);

    size = powerUpSize;
    position = powerUpPosition;

    hitbox = RectangleHitbox();

    add(hitbox);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other ){
    if(!_hasCollided){
      _hasCollided = true;
      if (other is Paddle) {
        if(isMounted) {
          _applyPowerUp();
          removeFromParent();
        }
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other){
    if(_hasCollided){
      _hasCollided = false;
    }
    super.onCollisionEnd(other);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += velocity.y * dt;
    if(!(game.gameManager.isPlaying || game.gameManager.isPaused)){
      removeFromParent(); // removes the powerup when game is over
    }
    if(position.y + height >= game.size.y * 0.98){
      removeFromParent(); // removes the powerup when its below the paddle
    }
  }

  void _applyPowerUp() {
    // Handle power-up effects here based on the powerUpType.
    switch (powerUpType) {
      case PowerUpType.enlarge:
        break;
      case PowerUpType.shrink:
        break;
      case PowerUpType.extraBall:
        game.addExtraBall();
        break;
      case PowerUpType.fireBall:
      // TODO: Implement the superBall power-up effect.
        break;
      case PowerUpType.laser:
        break;
      case PowerUpType.magnet:
        break;
      case PowerUpType.slow:
      // TODO: Implement the slowDown power-up effect.
        break;
      case PowerUpType.fast:
      // TODO: Implement the speedUp power-up effect.
        break;
    }
  }
}
