import 'package:brainbots_breakout/src/game/sprites/paddle.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum Surface {vertical, horiontal}

class Ball extends SpriteComponent with HasGameRef, CollisionCallbacks{

  Vector2 ballSize;
  Vector2 ballPosition;
  Vector2 velocity;
  Vector2 gravity;

  Ball({
    required this.ballSize,
    required this.ballPosition,
    required this.velocity,
    required this.gravity,
  });

  late ShapeHitbox hitbox;
  bool canMove = false;

  bool get isMoving{
    return canMove ? velocity == Vector2.zero(): false;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('ball.png');

    size = ballSize;
    position = ballPosition;

    hitbox = CircleHitbox();
    add(hitbox);
  }

  @override
  void update(dt){
    if(canMove){
      _handleWallCollision();
      velocity += gravity;
      position += velocity * dt;
      super.update(dt);
    }
  }

  @override
  void onCollision(Set<Vector2>intersectionPoints, PositionComponent other){
    super.onCollision(intersectionPoints, other);
    if ((intersectionPoints.first.x - intersectionPoints.last.x).abs() < 2){
      _rebound(Surface.vertical); 
    }
    else{
      _rebound(Surface.horiontal);
    }

    if (other is Paddle){
      if(other.direction == PaddleDirection.left){
        velocity.x -= 100;
      }
      else if(other.direction == PaddleDirection.right){
        velocity.x += 100;
      }
    }
  }

  void _handleWallCollision(){
    if(position.x <= 0 || (position.x + width) >= game.size.x){
      _rebound(Surface.vertical);
    }
    if(position.y <= 0 || (position.y + height) >= game.size.y){
      _rebound(Surface.horiontal);
    }
  }

  void _rebound(Surface surface){
    if(surface == Surface.vertical){
      velocity.x *= -1;
    }
    else{
      velocity.y *= -1;
    }
  }
}