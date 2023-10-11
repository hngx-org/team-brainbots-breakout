import 'package:brainbots_breakout/src/game/managers/managers.dart';
import 'package:brainbots_breakout/src/game/sprites/sprites.dart';
import 'package:flame/game.dart';

class Breakout extends FlameGame with HasCollisionDetection{
  final GameManager gameManager;
  final LevelManager levelManager;
  Breakout({
    required this.gameManager,
    required this.levelManager
  });

  late Ball ball;
  late Paddle paddle;
  late Brick testBrick;

  @override
  Future<void> onLoad() async{
    initializeGameStart();
    super.onLoad();
  }

  void setObjects(){
    ball = Ball(
      gameManager: gameManager,
      levelManager: levelManager
    );
    paddle = Paddle(
      gameManager: gameManager,
      levelManager: levelManager,
    );
    testBrick = Brick(
      brickColor: BrickColor.blue,
      brickState: BrickState.normal,
      brickPosition: Vector2(size.x/2, size.y*0.1) );

    add(ball);
    add(paddle);
    add(testBrick);
  }
  
  void initializeGameStart(){
    setObjects();
  }
}