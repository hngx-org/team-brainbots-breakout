import 'package:brainbots_breakout/src/game/sprites/power_up.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class Paddle extends SpriteComponent with HasGameRef, CollisionCallbacks, DragCallbacks{
  Vector2 paddleSize;
  Vector2 paddlePosition;
  double speedMultiplier;
  List <PowerUpType> powerUpTypes;

  Paddle({
    required this.paddleSize,
    required this.powerUpTypes,
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
    if (canMove) {
      // Calculate the new position based on the drag event's delta values
      final newPositionX = position.x + event.delta.x;

      // Ensure the new position stays within the bounds of the game screen
      if (newPositionX >= 0 && newPositionX + width <= game.size.x) {
        position.x = newPositionX;
        paddlePosition.x = newPositionX;
      }

      // Calculate and update the paddle boost
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
  @override
  Future<void> onMount() async {
    super.onMount();
    sprite = await gameRef.loadSprite('paddle.png');
    size = paddleSize;
    position = paddlePosition;
    paddleBoost = 0;
    hitbox = RectangleHitbox();
    add(hitbox);
  }
}