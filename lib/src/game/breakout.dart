import 'dart:math';

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

  @override
  Future<void> update(dt) async{
    super.update(dt);
    if(!children.any((element) => element is Ball)){
      gameManager.state = GameState.gameOver;
    }
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
    add(ball);
    add(paddle);
  }

  void arrangeBricks(double numBricks){
    Vector2 brickSize = Vector2(75, 25);
    var random = Random();
    double x = 0;
    double y = 40;
    double xSpace = 5;
    double ySpace = 5;

    for(var brickIndex = 0; brickIndex < numBricks; brickIndex ++){  
      add(
         Brick(
          levelManager: levelManager,
          brickColor: BrickColor.values[random.nextInt(BrickColor.values.length - 1)],
          brickSize: brickSize,
          brickPosition: Vector2(x, y)
        )
      );
      x += brickSize.x + xSpace;

      if(x + brickSize.y > size.x){
        y += brickSize.y + ySpace;
        x = 0;
      }
    }
  }
  
  void initializeGameStart(){
    setObjects();
    arrangeBricks(10);
  }
}