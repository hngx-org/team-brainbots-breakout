import 'dart:math';
import 'package:brainbots_breakout/src/config/user_config.dart';
import 'package:brainbots_breakout/src/game/managers/managers.dart';
import 'package:brainbots_breakout/src/game/sprites/sprites.dart';
import 'package:brainbots_breakout/src/game/world.dart';
import 'package:flame/game.dart';

class Breakout extends FlameGame with HasCollisionDetection{
  final GameManager gameManager;
  final LevelManager levelManager;
  Breakout({
    required this.gameManager,
    required this.levelManager,
  });

  List<Ball> balls = [];
  late Paddle paddle;
  late List<Brick> bricks;
  bool needBricks = false;

  @override
  Future<void> onLoad() async{
    super.onLoad();
    initializeGameStart();
    add(Stars());
    overlays.add('gameOverlay');
  }

  @override
  Future<void> update(dt) async{
    super.update(dt);

    if(needBricks){ // if no bricks are left, arrange new bricks
      arrangeBricks(levelManager.numBricks);
      needBricks = false;
    }
    paddle.canMove = true;

    if(!gameManager.isPlaying){ // freezes the ball and paddle if the game is not in a playing state
      for (var ball in balls) {
        ball.canMove = false;
      }
      paddle.canMove = false;
    }
    else{
      for (var ball in balls) {
        ball.canMove = true;
      }
      paddle.canMove = true;
    }
    
    //returns from update() if the game is not in a playing state
    if(gameManager.isGameOver || gameManager.isPaused || gameManager.isWin) return;

    for(Ball ball in balls){
      if(ball.position.y + ball.height >= size.y * 0.98){
        ball.removeFromParent();
      }
    }

    balls = balls.where((element) => !element.isRemoved).toList();
    if (balls.isEmpty) {
      gameOver();
    }

    bricks = bricks.where((element) => !element.isRemoved).toList(); // updates the bricks list to contain only bricks that havent been broken
    gameManager.score.value = ((levelManager.numBricks - bricks.length) * levelManager.brickStrength).floor(); // calculates score based on number of bricks broken
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
    overlays.add('pauseMenuOverlay');
  }

  void resume(){
    resumeEngine();
    overlays.remove('pauseMenuOverlay');
  }

  void reset(){ // resets the game config
    overlays.remove('gameOverOverlay');
    overlays.remove('winOverlay');
    overlays.remove('pauseMenuOverlay');
    resumeEngine();
    gameManager.reset(); // resets the score

    removeAll(balls);
    setBall();
    remove(paddle);
    setPaddle();
    balls[0].velocity = levelManager.initialVelocity
      ..x = 0;
    needBricks = true;
    gameManager.state = GameState.intro;
    overlays.add('introOverlay');
  }

  void win(){
    gameManager.state = GameState.win;
    if(levelManager.level + 1 <= levelManager.maxLevel){ // unlocks a new level if there are more available levels
      if(userConfig.levelsUnlocked.value < levelManager.level + 1){
        userConfig.levelsUnlocked.value = levelManager.level + 1;
      }
    }
    overlays.add('winOverlay');
  }

  void gameOver(){
    gameManager.state = GameState.gameOver;
    overlays.add('gameOverOverlay');
  }

  void nextLevel(){
    if (levelManager.level + 1 < levelManager.maxLevel){ // goes to the next level if there is a next level
      levelManager.level += 1;
      reset();
    } else {
      // TODO: show something when user has finished all the levels
    }
  }

  void setBall(){ // sets the size, position and velocity of the ball at the start of the game
    Vector2 ballSize = Vector2.all(20);
    Vector2 ballPosition = size/2 - ballSize/2;
    Vector2 maxVelocity = levelManager.maxVelocity;
    Vector2 gravity = levelManager.gravity;

    var ball = Ball(
      ballSize: ballSize,
      ballPosition: ballPosition,
      maxVelocity: maxVelocity,
      gravity: gravity,
      initialVelocity: levelManager.initialVelocity,
    );
    ball.velocity = levelManager.initialVelocity;

    balls.clear();

    // Add the ball to the list
    balls.add(ball);
    add(ball);
  }

  void setPaddle(){ // sets the size and position of the paddle
    Vector2 paddleSize = Vector2(100, 25);
    Vector2 paddlePosition = Vector2(
      size.x/2 - paddleSize.x/2,
      size.y * 0.9
    );
    double paddleSpeedMultiplier = levelManager.paddleSpeedMultiplier;

    paddle = Paddle(
      paddleSize: paddleSize,
      paddlePosition: paddlePosition,
      speedMultiplier: paddleSpeedMultiplier,
    );
    add(paddle);
  }

  void addExtraBall(){
    Vector2 ballSize = Vector2.all(20);
    Vector2 ballPosition = Vector2(
      paddle.paddlePosition.x,
      paddle.paddlePosition.y - 100,
    );
    Vector2 maxVelocity = levelManager.maxVelocity;
    Vector2 gravity = levelManager.gravity;
    Vector2 velocity = Vector2(0, -50);

    var extraBall = Ball(
      ballSize: ballSize,
      ballPosition: ballPosition,
      maxVelocity: maxVelocity,
      gravity: gravity,
      initialVelocity: velocity,
    );
    balls.add(extraBall);

    add(extraBall);
  }

  void arrangeBricks(int numBricks){ // lays out the bricks on the screen
    const int n = 7;
    double xSpace = 2;
    double ySpace = 2;
    double brickWidth = (size.x - ((n+1) * xSpace)) / n; // ensures [n] bricks in a row every time
    double brickHeight = brickWidth / 3; // maintains 3 : 1 aspect ratio
    Vector2 brickSize = Vector2(brickWidth, brickHeight);
    var random = Random();
    double xPosition = 2;
    double yPosition = 75;
    
    bricks = [];
    for(var brickIndex = 0; brickIndex < numBricks; brickIndex ++){
      bool hasPowerUp = random.nextDouble() < 1;
      bricks.add(
         Brick(
          brickColor: BrickColor.values[random.nextInt(BrickColor.values.length - 1)],
          brickSize: brickSize,
          brickPosition: Vector2(xPosition, yPosition),
          strength: levelManager.brickStrength,
          hasPowerUp: hasPowerUp
        )
      );
      xPosition += brickSize.x + xSpace;

      if(xPosition + brickSize.y > size.x){
        yPosition += brickSize.y + ySpace;
        xPosition = 2;
      }
    }
    addAll(bricks);
  }
  
  void initializeGameStart(){ // called only at the start of the game in onLoad();
    // setBall();
    setPaddle();
    reset();
  }
}
