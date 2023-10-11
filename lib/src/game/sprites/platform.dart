import 'package:brainbots_breakout/src/game/breakout.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

abstract class Platform<T> extends SpriteGroupComponent<T>
    with HasGameRef<Breakout>, CollisionCallbacks{
  final hitbox = CircleHitbox();
  bool isMoving = false;

  Platform({
    super.position,
  }): super(
    size: Vector2.all(20),
    priority: 1
  );

  @override
  Future<void>? onLoad() async{
    await super.onLoad();
    await add(hitbox);
  }
}