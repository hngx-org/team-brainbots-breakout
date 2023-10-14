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
    sprite = await gameRef.loadSprite('paddle.png'); // adds the paddle sprite to the game
    size = paddleSize;
    position = paddlePosition;
    paddleBoost = 0;
    hitbox = RectangleHitbox();
    add(hitbox); // adds a hitbox that would enable collision callbacks
  }

  @override
  void onDragUpdate(DragUpdateEvent event){
    super.onDragUpdate(event);
    if(canMove){ // adds a paddle boost while the user is dragging the paddle to give the ball momentum
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
    paddleBoost = 0; // reset the paddle boost to 0 when dragging is done
  }
}