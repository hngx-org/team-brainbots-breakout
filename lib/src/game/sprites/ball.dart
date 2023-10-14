import 'dart:math';
import 'package:brainbots_breakout/src/config/user_config.dart';
import 'package:brainbots_breakout/src/game/sprites/sprites.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

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
  late AudioPool _brickCollisionSound;
  late AudioPool _paddleCollisionSound;
  late double _dt;

  bool canMove = false;
  bool muted = !userConfig.sfxOn.value;
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
    _brickCollisionSound = await FlameAudio.createPool(
      'sfx/brick_collision.mp3',
      maxPlayers: 1
    );
    _paddleCollisionSound = await FlameAudio.createPool(
      'sfx/paddle_collision.mp3',
      maxPlayers: 1
    );
    userConfig.sfxOn.addListener(() {
      muted = !userConfig.sfxOn.value;
    });
    // Using this custom value of _dt ensures that v * dt will never be greater than half 
    // the height of the smallest object in the game (Brick) when the ball is moving at max speed(100).
    // This ensures that onCollision will always be called even when frame rate is very low
    _dt = (game.size.y/(8*3) / 2) / 100;
  }

  @override
  void update(dt){
    if(canMove){
      if((size + position + velocity * _dt).x >= game.size.x || (position + velocity * _dt).x <= 0){
        _reflect(Surface.vertical);
      }
      if((size + position + velocity * _dt).y >= game.size.y || (position + velocity * _dt).y <= 0){
        _reflect(Surface.horiontal);
      }
      // velocity += gravity;
      position += velocity * _dt;
      super.update(dt);
    }
  }

  @override
  void onCollision(Set<Vector2>intersectionPoints, PositionComponent other){
    if(!_hasCollided){
      _hasCollided = true;
      if(other is Paddle){
        _rebound(intersectionPoints, other);
        if(!muted){
          _paddleCollisionSound.start(volume: 0.5);
        }
        if ((velocity.x + other.paddleBoost).isNegative){
          velocity.x = max(-maxVelocity.x, (velocity.x + other.paddleBoost));
        } else {
          velocity.x = min(maxVelocity.x, (velocity.x + other.paddleBoost));
        }
        
      } else if (other is Brick){
        _rebound(intersectionPoints, other);
        if(!muted){
          _brickCollisionSound.start(volume: 0.5);
        }
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
    final isTop = (ip.y - other.position.y).abs() < 5;
    final isBottom = (ip.y - (other.position.y + other.size.y)).abs() < 5;
    final isLeft = (ip.x - other.position.x).abs() < 5;
    final isRight = (ip.x - (other.position.x + other.size.x)).abs() < 5;
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