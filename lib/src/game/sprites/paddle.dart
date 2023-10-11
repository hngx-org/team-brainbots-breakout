import 'package:brainbots_breakout/src/game/managers/game_manager.dart';
import 'package:brainbots_breakout/src/game/managers/managers.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class Paddle extends SpriteComponent with HasGameRef, CollisionCallbacks, DragCallbacks{
  GameManager gameManager;
  LevelManager levelManager;

  Paddle({
    required this.gameManager,
    required this.levelManager,
  });
  
  late ShapeHitbox hitbox;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
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
  }
  @override
  void onDragStart(DragStartEvent event){
    super.onDragStart(event);
    if(!gameManager.isPlaying){
      gameManager.state = GameState.intro;
    }
  }
}