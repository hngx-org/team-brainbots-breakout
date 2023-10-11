import 'package:brainbots_breakout/src/game/managers/managers.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

enum PaddleDirection {left, center, right}
class Paddle extends SpriteComponent with HasGameRef, CollisionCallbacks, DragCallbacks{
  GameManager gameManager;
  LevelManager levelManager;

  Paddle({
    required this.gameManager,
    required this.levelManager,
  });
  
  late ShapeHitbox hitbox;
  late PaddleDirection direction;
  // late double paddleBoost;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    direction = PaddleDirection.center;
    sprite = await gameRef.loadSprite(
      'paddle.png',
    );
    width *= 0.2;
    height *= 0.2;
    position = Vector2(
      game.size.x * 0.5 - width/2,
      game.size.y * 0.9
    );
    hitbox = RectangleHitbox();
    add(hitbox);
  }

  @override
  void onDragUpdate(DragUpdateEvent event){
    super.onDragUpdate(event);
    if(!(position.x + event.delta.x < 0) && !(position.x + width + event.delta.x > game.size.x)){
      position.x += event.delta.x;
    }
    // paddleBoost = 2 * (event.devicePosition.x / game.size.x) - 1;
    // print(paddleBoost);
    if(event.delta.x < 0){
      direction = PaddleDirection.left;
    }
    else if(event.delta.x > 0){
      direction = PaddleDirection.right;
    }
    else{
      direction = PaddleDirection.center;
    }
  }

  @override
  void onDragStart(DragStartEvent event){
    super.onDragStart(event);
    if(!gameManager.isPlaying){
      gameManager.state = GameState.intro;
    }
  }

  @override
  void onDragEnd(DragEndEvent event){
    super.onDragEnd(event);
    direction = PaddleDirection.center;
  }
}