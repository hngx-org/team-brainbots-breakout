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

  @override
  Future<void> onLoad() async{
    initializeGameStart();
    ball.canMove = true;
    paddle.canMove = true;
    super.onLoad();
  }

  @override
  Future<void> update(dt) async{
    super.update(dt);

    // if(gameManager.state == GameState.win){
    //   win();
    // }
    if(!children.any((element) => element is Brick)){
      gameManager.state = GameState.win;
    }
  }
  // void win(){
  //   print('you won');
  //   // ball.canMove = false;
  //   // paddle.canMove = false;
  // }
  // void reset(){
  //   gameManager.state = GameState.intro; 
  //   arrangeBricks(levelManager.numBricks);
  // }
  void setBall(){
    Vector2 ballSize = Vector2.all(25);
    Vector2 ballPosition = size/2 - ballSize/2;
    Vector2 initialVelocity = levelManager.initialVelocity;
    Vector2 gravity = levelManager.gravity;

    ball = Ball(
      ballSize: ballSize,
      ballPosition: ballPosition,
      velocity: initialVelocity,
      gravity: gravity,
    );
    add(ball);
  }

  void setPaddle(){
    Vector2 paddleSize = Vector2(100, 25);
    Vector2 paddlePosition = Vector2(
      size.x/2 - paddleSize.x/2,
      size.y * 0.9
    );
    double paddleSpeedMultiplier = levelManager.paddleSpeedMultiplier;

    paddle = Paddle(
      paddleSize: paddleSize,
      paddlePosition: paddlePosition,
      speedMultiplier: paddleSpeedMultiplier
    );
    add(paddle);
  }

  void arrangeBricks(int numBricks){
    Vector2 brickSize = Vector2(75, 25);
    var random = Random();
    double x = 0;
    double y = 75;
    double xSpace = 5;
    double ySpace = 5;

    for(var brickIndex = 0; brickIndex < numBricks; brickIndex ++){  
      add(
         Brick(
          brickColor: BrickColor.values[random.nextInt(BrickColor.values.length - 1)],
          brickSize: brickSize,
          brickPosition: Vector2(x, y),
          strength: levelManager.brickStrength
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
    setBall();
    setPaddle();
    arrangeBricks(levelManager.numBricks);
  }
}