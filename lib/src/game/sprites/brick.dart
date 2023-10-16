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
  bool isPowerUp;

  Brick({
    required this.brickColor,
    required this.brickSize,
    required this.brickPosition,
    required this.strength,
    required this.isPowerUp,
  });
  late ShapeHitbox hitbox;
  late BrickState brickState;
  bool _hasCollided = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    Sprite normal = await gameRef.loadSprite('game/bricks/${brickColor.name}.png');
    Sprite cracked = await gameRef.loadSprite('game/bricks/${brickColor.name}_cracked.png');
    sprites = <BrickState, Sprite>{ // adds the two different sprites
      BrickState.normal: normal,
      BrickState.cracked: cracked,
    };
    current = BrickState.normal; // sets the default sprite

    size = brickSize;
    position = brickPosition;

    hitbox = RectangleHitbox();
    add(hitbox); // adds a hitbox for collision callbacks
  }

  @override
  Future<void> onCollision(Set<Vector2> intersectionPoints, PositionComponent other) async{
    if(other is Ball && !_hasCollided){ // the _hasCollided flag ensures that the onCollision is not called again till collision ends
      _hasCollided = true;
      strength -= 1;
      if(strength == 1){
        current = BrickState.cracked;
        return;
      }
      if (strength == 0){
        removeFromParent();
        if (isPowerUp) {
          gameRef.spawnPowerUp(this); // Call spawnPowerUp when a brick with isPowerUp set to true is destroyed.
        }
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  Future<void> onCollisionEnd(PositionComponent other) async {
    if(_hasCollided){
      _hasCollided = false;
    }
    super.onCollisionEnd(other);
  }
}