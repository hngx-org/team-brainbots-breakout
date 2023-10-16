import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:flame/components.dart';

class Stars extends SpriteComponent with HasGameRef<Breakout>{
  @override
  Future<void> onLoad() async{
    sprite = await gameRef.loadSprite(
      'others/stars_background.png'
    );
    size = gameRef.size;
    position = Vector2.zero();
    // setting priority to zero ensures that this sprite is rendered behind the others
    // the priority of the others have been set to 1
    priority = 0; 

  }
}