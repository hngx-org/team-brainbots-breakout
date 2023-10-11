import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:brainbots_breakout/src/game/sprites/ball.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum BrickState {normal, cracked}
enum BrickColor
    {blue, brown, cyan, green, grey,lemon, orange, purple, red, yellow}

class Brick extends SpriteGroupComponent with HasGameRef<Breakout>, CollisionCallbacks{
  BrickColor brickColor;
  Vector2 brickSize;
  Vector2 brickPosition;
  int strength;

  Brick({
    required this.brickColor,
    required this.brickSize,
    required this.brickPosition,
    required this.strength,
  });
  late ShapeHitbox hitbox;
  late BrickState brickState;


  @override
  Future<void> onLoad() async {
    super.onLoad();
    _loadBricks();
    current = BrickState.normal;
    size = brickSize;
    position = brickPosition;

    hitbox = RectangleHitbox();
    add(hitbox);
  }

  Future<void> _loadBricks() async {
    Sprite normal = await gameRef.loadSprite('tile_${brickColor.name}.png');
    Sprite cracked = await gameRef.loadSprite('tile_${brickColor.name}_cracked.png');
    sprites = <BrickState, Sprite>{
      BrickState.normal: normal,
      BrickState.cracked: cracked,
    };
  }

  @override
  Future<void> onCollision(Set<Vector2> intersectionPoints, PositionComponent other) async{
    super.onCollision(intersectionPoints, other);
    if(other is Ball){
      strength -= 1;
      if(strength == 1){
        current = BrickState.cracked;
      }
      if (strength == 0){
        removeFromParent();
      }
    }
  }
}