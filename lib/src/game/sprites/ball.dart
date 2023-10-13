import 'dart:math';
import 'package:brainbots_breakout/src/game/sprites/sprites.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum Surface {vertical, horiontal}

class Ball extends SpriteComponent with HasGameRef, CollisionCallbacks{

  Vector2 ballSize;
  Vector2 ballPosition;
  Vector2 velocity;
  Vector2 maxVelocity;
  Vector2 gravity;

  Ball({
    required this.ballSize,
    required this.ballPosition,
    required this.velocity,
    required this.maxVelocity,
    required this.gravity,
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
    sprite = await gameRef.loadSprite('ball.png');

    size = ballSize;
    position = ballPosition;

    hitbox = CircleHitbox();
    add(hitbox);
  }

  @override
  void update(dt){
    if(canMove){
      if((size + position + velocity * dt).x >= game.size.x || (position + velocity * dt).x <= 0){
        _reflect(Surface.vertical);
      }
      if((size + position + velocity * dt).y >= game.size.y || (position + velocity * dt).y <= 0){
        _reflect(Surface.horiontal);
      }
      // velocity += gravity;
      position += velocity * dt;
      super.update(dt);
    }
  }

  @override
  void onCollision(Set<Vector2>intersectionPoints, PositionComponent other){
    if(!_hasCollided){
      _hasCollided = true;
      if(other is Paddle){
        _rebound(intersectionPoints, other);
        if ((velocity.x + other.paddleBoost).isNegative){
          velocity.x = max(-maxVelocity.x, (velocity.x + other.paddleBoost));
        } else {
          velocity.x = min(maxVelocity.x, (velocity.x + other.paddleBoost));
        }
        
      } else if (other is Brick){
        _rebound(intersectionPoints, other);
      }

    }
    super.onCollision(intersectionPoints, other);
  }

  void _rebound(Set<Vector2> ip, PositionComponent other){
     if(ip.length == 1){
      sideReflection(ip.first, other);
    } else {
      final ipList = ip.toList();
      final avg = (ipList[0] + ipList[1]) / 2;
      if(ipList[0].x == ipList[1].x || ipList[0].y == ipList[1].y){
        sideReflection(avg, other);
      } else {
        cornerReflection(other, avg);
      }
    }
  }


  void sideReflection(Vector2 ip, PositionComponent other) {
    final isTop = ip.y == other.position.y;
    final isBottom = ip.y == other.position.y + other.size.y;
    final isLeft = ip.x == other.position.x;
    final isRight = ip.x == other.position.x + other.size.x;
    if (isTop || isBottom) {
      _reflect(Surface.horiontal);
    } else if (isLeft || isRight) {
      _reflect(Surface.vertical);
    }
  }

  void cornerReflection(PositionComponent other, Vector2 avg) {
    _reflect(Surface.vertical);
    _reflect(Surface.horiontal);
  }

  @override
  void onCollisionEnd(PositionComponent other){
    if(_hasCollided){
      _hasCollided = false;
    }
    super.onCollisionEnd(other);
  }

  void _reflect(Surface surface){
    if(surface == Surface.vertical){
      velocity.x *= -1;
    }
    else{
      velocity.y *= -1;
    }
  }
}