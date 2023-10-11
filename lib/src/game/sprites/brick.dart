import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum BrickState {normal, cracked}
enum BrickColor
    {blue, brown, cyan, green, grey,lemon, orange, purple, red, yellow}

class Brick extends SpriteComponent with HasGameRef<Breakout>, CollisionCallbacks{
  BrickState brickState;
  BrickColor brickColor;
  Vector2 brickPosition;
  Brick({
    required this.brickColor,
    required this.brickState,
    required this.brickPosition,
  });
  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    var path = switch(brickState){
      BrickState.normal => 'tile_${brickColor.name}.png',
      BrickState.cracked => 'tile_${brickColor.name}_cracked.png'
    };
    sprite = await gameRef.loadSprite(path);
    width *= 0.2;
    height *= 0.2;
    position = brickPosition;
    hitbox = RectangleHitbox();
    add(hitbox);
  }
}