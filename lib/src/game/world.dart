import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:flame/components.dart';

class Stars extends SpriteComponent with HasGameRef<Breakout>{
  @override
  Future<void> onLoad() async{
    sprite = await gameRef.loadSprite(
      'Stars Small_2.png'
    );
    size = gameRef.size;
    position = Vector2.zero();
    priority = 0;
  }
}