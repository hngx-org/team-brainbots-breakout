import 'dart:async';
import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/sprites/laser.dart';
import 'package:brainbots_breakout/src/game/sprites/power_up.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart' hide Timer;
import 'package:flame/events.dart';

enum PaddleType {normal, laser, magnet}
class Paddle extends SpriteAnimationGroupComponent with HasGameRef<Breakout>, CollisionCallbacks, DragCallbacks{
  final Vector2 paddleSize;
  final Vector2 paddlePosition;
  double speedMultiplier;

  Paddle({
    required this.paddleSize,
    required this.paddlePosition,
    required this.speedMultiplier,
  });
  
  late ShapeHitbox hitbox;
  late double paddleBoost;
  bool canMove = false;
  bool _isEnlarged = false;
  bool _isShrinked = false;
  bool _shouldActivateLaser = false;
  bool _shouldActivateMagnet = false;
  late Timer _laserTimer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    SpriteAnimation normal = SpriteAnimation.spriteList(
      await _loadNormalSprites(),
      stepTime: 0.2
    );
    SpriteAnimation laser = SpriteAnimation.spriteList(
      await _loadLaserSprites(),
      stepTime: 0.2
    );
    SpriteAnimation magnet = SpriteAnimation.spriteList(
      await _loadMagnetSprites(),
      stepTime: 0.2
    );

    animations = {
      PaddleType.normal: normal,
      PaddleType.laser: laser,
      PaddleType.magnet: magnet,
    };
    current = PaddleType.normal;

    size = paddleSize;
    position = paddlePosition;
    paddleBoost = 0;
    hitbox = RectangleHitbox();
    add(hitbox);

    _laserTimer = Timer.periodic(Duration.zero, (timer) { });
  }

  @override
  void update(dt){
    super.update(dt);
    if(_shouldActivateLaser){
      _shouldActivateLaser = false;
      current = PaddleType.laser;
    }
    if(_shouldActivateMagnet){
      _shouldActivateMagnet = false;
      current = PaddleType.magnet;
    }
  }

  Future<List<Sprite>> _loadNormalSprites() async {
    return Future.wait([
      Sprite.load('game/paddles/default.png')
    ]);
  }

  Future<List<Sprite>> _loadLaserSprites() async {
    return Future.wait([
      Sprite.load('game/paddles/laser_1.png'),
      Sprite.load('game/paddles/laser_2.png'),
      Sprite.load('game/paddles/laser_3.png'),
    ]);
  }

  Future<List<Sprite>> _loadMagnetSprites() async {
    return Future.wait([
      Sprite.load('game/paddles/magnet_1.png'),
      Sprite.load('game/paddles/magnet_2.png'),
      Sprite.load('game/paddles/magnet_3.png'),
    ]);
  }

  @override
  void onDragUpdate(DragUpdateEvent event){
    super.onDragUpdate(event);
    if (canMove) {
      final newPositionX = position.x + event.delta.x;

      if (newPositionX >= 0 && newPositionX + width <= game.size.x) {
        position.x = newPositionX;
        paddlePosition.x = newPositionX;
      }

      paddleBoost = event.delta.x * speedMultiplier;
    }
  }

  @override
  void onDragEnd(DragEndEvent event){
    super.onDragEnd(event);
    paddleBoost = 0;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other){
    if(other is PowerUp){
      if(other.powerUpType == PowerUpType.laser){
        _applyLaserPowerUp();
      }
      if(other.powerUpType == PowerUpType.magnet){
        _applyMagnetPowerUp();
      }
      if(other.powerUpType == PowerUpType.enlarge){
        _applyEnlargePowerUp();
      }
      if(other.powerUpType == PowerUpType.shrink){
        _applyShrinkPowerUp();
      }
      if(other.powerUpType == PowerUpType.slow){
        _applySlowBallPowerUp();
      }
      if(other.powerUpType == PowerUpType.fast){
        _applyFastBallPowerUp();
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  void _applyLaserPowerUp(){
    if(!(_shouldActivateLaser || current != PaddleType.normal)){
      _shouldActivateLaser = true;
      Future.delayed(
        game.levelManager.powerUpDuration,
        (){
          if(isMounted){
            current = PaddleType.normal;
          }
        }
      );
      _spawnLasers();
    }
  }
  
  void _applyMagnetPowerUp(){
    if(!(_shouldActivateMagnet || current != PaddleType.normal)){
      _shouldActivateMagnet = true;
      Future.delayed(
        game.levelManager.powerUpDuration,
        (){
          if(isMounted){
            current = PaddleType.normal;
          }
        }
      );
    }
  }

  void _spawnLasers(){
    _laserTimer = Timer.periodic(
      const Duration(milliseconds: 500), 
      (timer){
        if(current == PaddleType.laser){
          Vector2 laserSize = Vector2(7.6, 16.4);
          game.addAll([
            Laser(
              initialPosition: Vector2(
                x,
                y - laserSize.y
              ),
              laserSize: laserSize,
              velocity: Vector2(0, -40),
              damage: 0.1
            ),
            Laser(
              initialPosition: Vector2(
                x + width - laserSize.x,
                y - laserSize.y
              ),
              laserSize: laserSize,
              velocity: Vector2(0, -40),
              damage: 0.1
            ),
          ]);
        }
        else {
          timer.cancel();
        }
      }
    );
  }

  void _applyEnlargePowerUp(){
    double increment = 60;
    if(!_isEnlarged){
      _isEnlarged = true;
      if((position.x - increment/2).isNegative){
        position.x = 0;
      }
      else if((position.x - increment/2) + (width + increment) >= game.size.x){
        position.x = game.size.x - (width + increment);
      }
      else{
        position.x -= increment/2;
      }
      size.x += increment;
      Future.delayed(
        game.levelManager.powerUpDuration,
        (){
          if(isMounted){
            size.x -= increment;
            position.x += increment/2;
            _isEnlarged = false;
          }
        }
      );
    }
  }
  
  void _applyShrinkPowerUp(){
    double decremnet = 60;
    if(!_isShrinked){
      _isShrinked = true;
      size.x -= decremnet;
      position.x += decremnet/2;
      Future.delayed(
        game.levelManager.powerUpDuration,
        (){
          if(isMounted){
            if((position.x - decremnet/2).isNegative){
              position.x = 0;
            }
            else if((position.x - decremnet/2) + (width + decremnet) >= game.size.x){
              position.x = game.size.x - (width + decremnet);
            }
            else{
              position.x -= decremnet/2;
            }
            size.x += decremnet;
            _isShrinked = false;
          }
        }
      );
    }
  }


  Future<void> _applySlowBallPowerUp() async{
    Vector2 maxVelocity;
    Vector2 velocity;
    for (var ball in game.balls) {
      maxVelocity = Vector2(ball.maxVelocity.x - 15, ball.maxVelocity.y - 25,);
      velocity = ball.velocity;

      ball
        ..maxVelocity = maxVelocity
        ..velocity = velocity;

      add(ball);
    }
  }

  Future<void> _applyFastBallPowerUp() async{
    Vector2 maxVelocity;
    Vector2 velocity;
    for (var ball in game.balls) {
      maxVelocity = Vector2(ball.maxVelocity.x + 15, ball.maxVelocity.y + 25,);
      velocity = ball.velocity;

      ball
        ..maxVelocity = maxVelocity
        ..velocity = velocity;

      add(ball);
    }
  }

  @override
  void onRemove(){
    _laserTimer.cancel();
  }
}