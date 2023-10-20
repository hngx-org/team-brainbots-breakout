import 'dart:async';
import 'dart:math';
import 'package:brainbots_breakout/src/config/user_config.dart';
import 'package:brainbots_breakout/src/game/managers/managers.dart';
import 'package:brainbots_breakout/src/game/sprites/laser.dart';
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
  late Ball? magnetizedBall;
  List <Laser> lasers =  [];
  late List<Brick> bricks;
  bool needBricks = false;
  bool isSlowBall = false;
  bool isFastBall = false;
  bool isPaddleMagnetic = false;
  Vector2 savedBallPosition = Vector2.zero();
  int extraBallsOnScreen = 0;

  late Timer? gameTimer;


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

    userConfig.totalGameTime.value += gameManager.score.value;

    for(Laser laser in lasers){
      if(!gameManager.isPlaying){
        laser.removeFromParent();
      }
    }

    if(needBricks){ // if no bricks are left, arrange new bricks
      arrangeBricks(levelManager.numPatterns);
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

    if(balls.length == 3){

      extraBallsOnScreen = 0;
    }

    bricks = bricks.where((element) => !element.isRemoved).toList(); // updates the bricks list to contain only bricks that havent been broken
    if(bricks.isEmpty){
      win();
    }

    if (isPaddleMagnetic) {
      if (magnetizedBall != null) {
        magnetizedBall!.position =
            Vector2(paddle.position.x, paddle.position.y - magnetizedBall!.size.y - 1);
      }
    }
  }

  void start(){
    overlays.remove('introOverlay');
    gameManager.state = GameState.playing;
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      gameManager.time.value++; // Increment time by 1 second
    });
  }
  void pause(){
    pauseEngine();
    if (gameManager.isPaused) {
      gameTimer!.cancel();
    }
    overlays.add('pauseMenuOverlay');
  }

  void resume(){
    resumeEngine();
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      gameManager.time.value++; // Increment time by 1 second
    });
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
    gameTimer!.cancel();
    overlays.add('winOverlay');
  }

  void gameOver(){
    gameManager.state = GameState.gameOver;
    gameTimer!.cancel();
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

  void arrangeBricks(int numPatterns) {
    const int n = 7;
    double xSpace = 2;
    double ySpace = 2;
    double brickWidth = (size.x - ((n + 1) * xSpace)) / n;
    double brickHeight = brickWidth / 3;
    Vector2 brickSize = Vector2(brickWidth, brickHeight);
    var random = Random();
    double xPosition = 2;
    double yPosition = 75;

    // Define the pattern of bricks
    gameManager.generatePatternsByLevel();

    // Access the patterns for a specific level
    int levelToAccess = levelManager.level;
    List<List<int>> pattern = gameManager.patternsByLevel[levelToAccess - 1]!;

    int rowIndex = 0;

    bricks = [];
    for (var brickIndex = 0; brickIndex < numPatterns; brickIndex++) {
      // Adjust brick position according to the pattern
      if (pattern[rowIndex][brickIndex % n] == 1) {
        bool hasPowerUp = random.nextDouble() < 0.8;

        bricks.add(
            Brick(
              brickColor: BrickColor.values[random.nextInt(BrickColor.values.length - 1)],
              brickSize: brickSize,
              brickPosition: Vector2(xPosition, yPosition),
              strength: levelManager.brickStrength,
              hasPowerUp: hasPowerUp,
            )
        );
      }

      xPosition += brickSize.x + xSpace;

      if (xPosition + brickSize.x > size.x) {
        yPosition += brickSize.y + ySpace;
        xPosition = 2;
        rowIndex++;
      }
    }

    addAll(bricks);
  }

  //ball power up area
  void addExtraBall(){
    if (extraBallsOnScreen <= 2) {
      extraBallsOnScreen += 1;
      overlays.add('extraBallOverlay', );
      Future.delayed(const Duration(milliseconds: 800)).then((value) => overlays.remove('extraBallOverlay', ));
      Vector2 ballSize = Vector2.all(20);
      Vector2 ballPosition = Vector2(
        paddle.paddlePosition.x,
        paddle.paddlePosition.y - 50,
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
  }

  void applySlowBallPowerUp() {
    Vector2 velocity;
    if (!isSlowBall) {
      overlays.add('slowBallOverlay', );
      Future.delayed(const Duration(milliseconds: 800)).then((value) => overlays.remove('slowBallOverlay', ));
      isSlowBall = true;
      for (var ball in balls) {
        velocity = ball.velocity / 1.8;

        ball.velocity = velocity;

        add(ball);
      }
      Future.delayed(
          levelManager.powerUpDuration,
              (){
            if(isMounted){
              for (var ball in balls) {
                velocity = ball.velocity * 1.8;

                ball.velocity = velocity;

                add(ball);
              }
              isSlowBall = false;
            }
          }
      );
    }
  }

  void applyFastBallPowerUp() {
    Vector2 velocity;
    if (!isFastBall) {
      overlays.add('fastBallOverlay', );
      Future.delayed(const Duration(milliseconds: 800)).then((value) => overlays.remove('fastBallOverlay', ));
      isFastBall = true;
      for (var ball in balls) {
        velocity = ball.velocity * 1.8;
        ball.velocity = velocity;

        add(ball);
      }
      Future.delayed(
          levelManager.powerUpDuration,
              (){
            if(isMounted){
              for (var ball in balls) {
                velocity = ball.velocity / 1.8;

                ball.velocity = velocity;

                add(ball);
              }
              isFastBall = false;
            }
          }
      );
    }
  }

  //end of ball power up area

  void initializeGameStart(){
    setPaddle();
    reset();
  }


}
