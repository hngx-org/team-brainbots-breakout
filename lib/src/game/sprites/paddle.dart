import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';

enum PaddleDirection {left, center, right}
class Paddle extends SpriteComponent with HasGameRef, CollisionCallbacks, DragCallbacks{
  Vector2 paddleSize;
  Vector2 paddlePosition;
  double speedMultiplier;

  Paddle({
    required this.paddleSize,
    required this.paddlePosition,
    required this.speedMultiplier,
  });
  
  late ShapeHitbox hitbox;
  late PaddleDirection direction;
  late double paddleBoost;
  bool canMove = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('paddle.png');
    size = paddleSize;
    position = paddlePosition;

    direction = PaddleDirection.center;

    hitbox = RectangleHitbox();
    add(hitbox);
  }

  @override
  void onDragUpdate(DragUpdateEvent event){
    super.onDragUpdate(event);
    if(canMove){
      if(!(position.x + event.delta.x < 0) && !(position.x + width + event.delta.x > game.size.x)){
          position.x += event.delta.x;
        }
        paddleBoost = 2 * (event.devicePosition.x / game.size.x) - 1;
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
  }

  @override
  void onDragStart(DragStartEvent event){
    super.onDragStart(event);
  }

  @override
  void onDragEnd(DragEndEvent event){
    super.onDragEnd(event);
    direction = PaddleDirection.center;
  }
}