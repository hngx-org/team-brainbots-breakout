import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

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
  late double paddleBoost;
  bool canMove = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('paddle.png');
    size = paddleSize;
    position = paddlePosition;
    paddleBoost = 0;
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
        paddleBoost = event.delta.x * speedMultiplier;
    }
  }

  @override
  void onDragStart(DragStartEvent event){
    super.onDragStart(event);
  }

  @override
  void onDragEnd(DragEndEvent event){
    super.onDragEnd(event);
    paddleBoost = 0;
  }
}