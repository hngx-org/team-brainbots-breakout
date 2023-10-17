import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/sprites/sprites.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Laser extends SpriteComponent with HasGameRef<Breakout>, CollisionCallbacks{
  final Vector2 initialPosition;
  final Vector2 laserSize;
  final Vector2 velocity;
  final double damage;
  Laser({
    required this.initialPosition,
    required this.laserSize,
    required this.velocity,
    required this.damage
  });
  late double _dt;
  late ShapeHitbox hitbox;
  @override
  void onLoad() async{
    sprite = await  game.loadSprite('game/laser.png');
    position = initialPosition;
    size = laserSize;
    _dt = (game.size.y/(8*3) / 2) / 100;

    hitbox = RectangleHitbox();
    add(hitbox);
  }
  @override
  void update(dt){
    super.update(dt);
    position += velocity * _dt;
    if(position.y < 0){
      removeFromParent();
    }
  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other){
    super.onCollision(intersectionPoints, other);
    if(other is Brick){
      removeFromParent();
    }
  }
}