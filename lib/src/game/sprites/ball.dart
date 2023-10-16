import 'dart:math';
import 'package:brainbots_breakout/src/config/user_config.dart';
import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/sprites/power_up.dart';
import 'package:brainbots_breakout/src/game/sprites/sprites.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

enum Surface {vertical, horiontal}

class Ball extends SpriteComponent with HasGameRef<Breakout>, CollisionCallbacks{

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
  bool _hasCollided = false;
  int doubleSizePUCount = 0;
  int halfSizePUCount = 0;


  bool get isMoving{
    return canMove ? velocity == Vector2.zero(): false;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('game/ball.png'); // adds the ball to the game using the game reference

    size = ballSize;
    position = ballPosition;

    hitbox = CircleHitbox();
    add(hitbox); // adds a circle hitbox for collision callbacks
    _brickCollisionSound = await FlameAudio.createPool(
      'sfx/brick_collision.mp3',
      maxPlayers: 1,
    );
    _paddleCollisionSound = await FlameAudio.createPool(
      'sfx/paddle_collision.mp3',
      maxPlayers: 1
    );
    // Using this custom value of _dt ensures that v * dt will never be greater than half
    // the height of the smallest object in the game (Brick) when the ball is moving at max speed(100).
    // This ensures that onCollision will always be called even when frame rate is very low
    _dt = (game.size.y/(8*3) / 2) / 100;
  }

  @override
  void update(dt){
    if(canMove){
      if((size + position + velocity * _dt).x >= game.size.x || (position + velocity * _dt).x <= 0){ // checks for collision with vertical walls
        _reflect(Surface.vertical);
      }
      if((size + position + velocity * _dt).y >= game.size.y || (position + velocity * _dt).y <= 0){ // checks for collision with horizontal walls
        _reflect(Surface.horiontal);
      }
      // velocity += gravity;
      position += velocity * _dt;
      ballPosition += velocity * _dt;
      super.update(dt);
    }
  }

  @override
  void onCollision(Set<Vector2>intersectionPoints, PositionComponent other){
    if(!_hasCollided){ // ensures the onCollision callback isnt called again till onCollisionEnds
      _hasCollided = true;
      if(other is Paddle){
        _rebound(intersectionPoints, other);
        if(userConfig.sfxOn.value){
          _paddleCollisionSound.start();
        }
        if ((velocity.x + other.paddleBoost).isNegative){ // adds momentum from paddle and ensures it doesnt make the ball exceed its max velocity
          velocity.x = max(-maxVelocity.x, (velocity.x + other.paddleBoost));
        } else {
          velocity.x = min(maxVelocity.x, (velocity.x + other.paddleBoost));
        }

      }
      else if (other is Brick){
        if (gameRef.paddle.powerUpTypes.contains(PowerUpType.enlarge)) {
          doubleSizePUCount += 1;
          print('double count $doubleSizePUCount');
          if(doubleSizePUCount == 3){
            doubleSizePUCount = 0;
            gameRef.resetPaddle(PowerUpType.enlarge);
          }
        }
        else if (gameRef.paddle.powerUpTypes.contains(PowerUpType.shrink)) {
          halfSizePUCount += 1;
          print('half count $halfSizePUCount');
          if(halfSizePUCount == 3){
            halfSizePUCount = 0;
            gameRef.resetPaddle(PowerUpType.shrink);
          }
        }
        _rebound(intersectionPoints, other);
        if(userConfig.sfxOn.value){
          _brickCollisionSound.start();
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

  // for reflection on vertical or horizontal sides
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

  // for reflection on corners
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

  // reflects the direction of the ball based on the collision surface
  void _reflect(Surface surface){
    if(surface == Surface.vertical){
      velocity.x *= -1;
    }
    else{
      velocity.y *= -1;
    }
  }
}
