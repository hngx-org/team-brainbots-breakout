import 'dart:math';
import 'package:brainbots_breakout/src/config/user_config.dart';
import 'package:brainbots_breakout/src/game/managers/managers.dart';
import 'package:brainbots_breakout/src/game/sprites/extra_ball.dart';
import 'package:brainbots_breakout/src/game/sprites/power_up.dart';
import 'package:brainbots_breakout/src/game/sprites/sprites.dart';
import 'package:brainbots_breakout/src/game/world.dart';
import 'package:brainbots_breakout/src/reusables/utily/util.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Breakout extends FlameGame with HasCollisionDetection{
  final GameManager gameManager;
  final LevelManager levelManager;
  Breakout({
    required this.gameManager,
    required this.levelManager,
  });

  late Ball ball;
  ExtraBall? extraBall;
  late Paddle paddle;
  late PowerUp powerUp;
  late List<Brick> bricks;
  bool needBricks = false;

  final List<PowerUp> powerUpsToRemove = [];
  bool isExtraBall = false;

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
      ball.canMove = false;
      if (extraBall != null) {
        extraBall!.canMove = false;
      }
      paddle.canMove = false;
    }
    else{
      ball.canMove = true;
      if (extraBall != null) {
        extraBall!.canMove = true;
      }
      paddle.canMove = true;
    }

    
    //returns from update() if the game is not in a playing state
    if(gameManager.isGameOver || gameManager.isPaused || gameManager.isWin) return;

    bool isBallOffScreen = ball.position.y + ball.height >= size.y * 0.98;
    bool isExtraBallOffScreen = extraBall != null && extraBall!.position.y + extraBall!.height >= size.y * 0.98;

    if (isBallOffScreen && extraBall != null) {
      // Remove the main ball from the parent when it goes off the screen while there's an extra ball.
      ball.removeFromParent();
    }
    else if ( (extraBall != null && isExtraBallOffScreen) && (!isBallOffScreen)) {
      extraBall!.removeFromParent();
    }
    else if (isExtraBallOffScreen && (ball == null) ) {
      gameOver();
    }
    else if ((ball == null && isExtraBallOffScreen) ||
        ((!gameManager.isIntro && extraBall == null)  && isBallOffScreen)){
      gameOver();
    }else if (isBallOffScreen  ) {

    }

    bricks = bricks.where((element) => !element.isRemoved).toList(); // updates the bricks list to contain only bricks that havent been broken
    gameManager.score.value = (levelManager.numBricks - bricks.length) * levelManager.brickStrength; // calculates score based on number of bricks broken
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

    if (powerUp.isMounted) {
      for (final child in children) {
        if (child is PowerUp) {
          powerUpsToRemove.add(child);
          powerUp.onRemove();
          powerUp.removeFromParent();
        }
      }
    }
    if (powerUp.isMounted) {
      powerUpsToRemove.clear();
    }

    ball.velocity = levelManager.initialVelocity;
    ball.velocity.x = 0; //TODO:
    ball.velocity.y = ball.velocity.y.abs();
    ball.maxVelocity = levelManager.maxVelocity;
    ball.gravity = levelManager.gravity;
    ball.position = size/2 - ball.size/2;
//extra ball
    if (isMounted) {
      for (final child in children) {
        if (child is ExtraBall) {
          extraBall?.removeFromParent();
          extraBall?.onRemove();
        }
      }
    }
    Vector2 paddleSize = Vector2(100, 25);
    Vector2 paddlePosition = Vector2(
        size.x/2 - paddleSize.x/2,
        size.y * 0.9
    );
    double paddleSpeedMultiplier = levelManager.paddleSpeedMultiplier;
    if (paddle.isMounted) {
      paddle
        ..paddleSize = paddleSize
        ..paddlePosition = paddlePosition
        ..speedMultiplier = paddleSpeedMultiplier
        ..powerUpTypes.clear();
      add(paddle);
    }
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
    powerUp.velocity = Vector2(0, 0);
    if (powerUp.isMounted) {
      for (final child in children) {
        if (child is PowerUp) {
          powerUpsToRemove.add(child);
          powerUp.onRemove();
          powerUp.removeFromParent();
        }
      }
    }

    if (powerUp.isMounted) {
      powerUpsToRemove.clear();
    }
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

    ball = Ball(
      ballSize: ballSize,
      ballPosition: ballPosition,
      maxVelocity: maxVelocity,
      gravity: gravity, velocity: levelManager.initialVelocity,
    );
    ball.velocity = levelManager.initialVelocity;
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
      speedMultiplier: paddleSpeedMultiplier, powerUpTypes: []
    );
    add(paddle);
  }

  void resetPaddle(PowerUpType powerUpType){ // sets the size and position of the paddle
    Vector2 paddleSize = Vector2(100, 25);
    Vector2 paddlePosition = paddle.paddlePosition;
    double paddleSpeedMultiplier = levelManager.paddleSpeedMultiplier;

    paddle
      ..paddleSize = paddleSize
      ..paddlePosition = paddlePosition
      ..speedMultiplier = paddleSpeedMultiplier
      ..powerUpTypes.remove(powerUpType);

    add(paddle);
  }

  //on collision with paddle////////
  Future<void> setDoublePaddle() async {
      if (!paddle.powerUpTypes.contains(PowerUpType.enlarge)) {
        Vector2 paddleSize = Vector2(paddle.paddleSize.x + 60, 25);
        Vector2 paddlePosition = paddle.paddlePosition;
        double paddleSpeedMultiplier = levelManager.paddleSpeedMultiplier;

        paddle
          ..paddleSize = paddleSize
          ..paddlePosition = paddlePosition
          ..speedMultiplier = paddleSpeedMultiplier
          ..powerUpTypes.add(PowerUpType.enlarge);

        add(paddle);
      }
  }

  Future<void> setHalfPaddle() async {
      if (!paddle.powerUpTypes.contains(PowerUpType.shrink)) {
        Vector2 paddleSize;
        if (paddle.powerUpTypes.contains(PowerUpType.enlarge)) {
          paddleSize = Vector2(60, 25);
        }
        else{
          paddleSize = Vector2(paddle.paddleSize.x - 40, 25);
        }

        Vector2 paddlePosition = paddle.paddlePosition;
        double paddleSpeedMultiplier = levelManager.paddleSpeedMultiplier;

        paddle
          ..paddleSize = paddleSize
          ..paddlePosition = paddlePosition
          ..speedMultiplier = paddleSpeedMultiplier
          ..powerUpTypes.add(PowerUpType.shrink);

        add(paddle);
      }
  }

  void setExtraBall(){
    if(!isExtraBall) {
      isExtraBall = true;
        Vector2 ballSize = Vector2.all(20);
        Vector2 ballPosition = ball.ballPosition;
        Vector2 maxVelocity = levelManager.extraBallMaxVelocity;
        Vector2 gravity = levelManager.extraBallGravity;

        extraBall = ExtraBall(
          ballSize: ballSize,
          ballPosition: ballPosition,
          maxVelocity: maxVelocity,
          gravity: gravity, velocity:levelManager.extraBallVelocity,
        );
        add(extraBall!);
    }
  }


////////////////////////////////
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
      bool hasPowerUp = random.nextDouble() < 0.1;
      bricks.add(
         Brick(
          brickColor: BrickColor.values[random.nextInt(BrickColor.values.length - 1)],
          brickSize: brickSize,
          brickPosition: Vector2(xPosition, yPosition),
          strength: levelManager.brickStrength,
          isPowerUp: hasPowerUp
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
    setBall();
    setPaddle();
    initPowerUp();
    reset();
  }

  void initPowerUp() {
      final powerUpType = Util.getRandomPowerUpType();

      powerUp = PowerUp(powerUpSelected: powerUpType,
        velocity: levelManager.powerUpVelocity,
        powerUpSize: Vector2.all(1), powerUpPosition: Vector2.all(1),);
      powerUp.position = Vector2.all(1); // Set the position where the power-up should appear.

      add(powerUp);
  }

  void spawnPowerUp(Brick destroyedBrick) {
    if (destroyedBrick.isPowerUp) {
      // final powerUpType = Util.getRandomPowerUpType();
      const powerUpType = PowerUpType.extraBall;

      powerUp = PowerUp(powerUpSelected: powerUpType,
        velocity: levelManager.powerUpVelocity,
        powerUpSize: destroyedBrick.brickSize, powerUpPosition: destroyedBrick.brickPosition,);
      powerUp.position = destroyedBrick.position; // Set the position where the power-up should appear.

      powerUpsToRemove.add(powerUp);
      add(powerUp);
    }
  }

}
