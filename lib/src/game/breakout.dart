import 'dart:math';
import 'package:brainbots_breakout/src/data/user_model.dart';
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

  late UserModel user;
  late Ball ball;
  late Paddle paddle;
  late List<Brick> bricks;
  bool needBricks = false;

  @override
  Future<void> onLoad() async{
    super.onLoad();
    user = UserModel();
    initializeGameStart();
    overlays.add('gameOverlay');
  }

  @override
  Future<void> update(dt) async{
    super.update(dt);

    if(needBricks){
      arrangeBricks(levelManager.numBricks);
      needBricks = false;
    }
    paddle.canMove = true;

    if(!gameManager.isPlaying){
      ball.canMove = false;
      paddle.canMove = false;
    }
    else{
      ball.canMove = true;
      paddle.canMove = true;
    }
    
    if(gameManager.isGameOver || gameManager.isPaused || gameManager.isWin) return;
    
    if(ball.position.y + ball.height >= size.y * 0.98){
      gameOver();
    }

    bricks = bricks.where((element) => !element.isRemoved).toList();
    gameManager.score.value = (levelManager.numBricks - bricks.length) * levelManager.brickStrength;
    if(bricks.isEmpty){
      win();
    }
  }

  

  void start(){
    overlays.remove('introOverlay');
    gameManager.state = GameState.playing;
  }
  void pause(){
    pauseEngine();
    overlays.add('winOverlay');
  }

  void resume(){
    resumeEngine();
    overlays.remove('pauseMenuOverlay');
  }

  void reset(){
    overlays.remove('gameOverOverlay');
    overlays.remove('winOverlay');
    overlays.remove('pauseMenuOverlay');
    resumeEngine();
    gameManager.reset();
    ball.velocity = levelManager.initialVelocity;
    ball.maxVelocity = levelManager.maxVelocity;
    ball.gravity = levelManager.gravity;
    ball.position = size/2 - ball.size/2;
    paddle.position = Vector2(
      size.x/2 - paddle.size.x/2,
      size.y * 0.9
    );
    paddle.speedMultiplier = levelManager.paddleSpeedMultiplier;
    needBricks = true;
    gameManager.state = GameState.intro;
    overlays.add('introOverlay');
  }

  void win(){
    gameManager.state = GameState.win;
    print('you win');
    overlays.add('winOverlay');
  }

  void gameOver(){
    gameManager.state = GameState.gameOver;
    print('game over');
    overlays.add('gameOverOverlay');
  }

  void nextLevel(){
    if (levelManager.level + 1 < levelManager.maxLevel){
      levelManager.level += 1;
      if(user.levelsUnlocked.value < levelManager.level){
        user.levelsUnlocked.value = levelManager.level;
      }
      reset();
    } else {
      // TODO: show something when user has finished game
    }
  }

  void setBall(){
    Vector2 ballSize = Vector2.all(15);
    Vector2 ballPosition = size/2 - ballSize/2;
    Vector2 initialVelocity = levelManager.initialVelocity;
    Vector2 maxVelocity = levelManager.maxVelocity;
    Vector2 gravity = levelManager.gravity;

    ball = Ball(
      ballSize: ballSize,
      ballPosition: ballPosition,
      velocity: initialVelocity,
      maxVelocity: maxVelocity,
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
    Vector2 brickSize = Vector2(30, 10);
    var random = Random();
    double x = 0;
    double y = 75;
    double xSpace = 2;
    double ySpace = 2;
    bricks = [];
    for(var brickIndex = 0; brickIndex < numBricks; brickIndex ++){  
      bricks.add(
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
    addAll(bricks);
  }
  
  void initializeGameStart(){
    setBall();
    setPaddle();
    reset();
  }
}
