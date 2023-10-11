
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:core';

enum Shape {rectangle, circle}
enum Surface {horizontal, vertical}

class ObjectVelocity{
  double x = 0;
  double y = 0;
}

class ObjectPosition{
  double x;
  double y;
  ObjectPosition({
    required this.x,
    required this.y
  });
}

class CollisionDetails{
  final int? brickIndex;
  final Surface surface;
  CollisionDetails({
    this.brickIndex,
    required this.surface
  });
}

abstract class GameObject{
  abstract double strength;
  abstract ObjectPosition position;
}


class Brick extends GameObject{
  double height;
  double width;
  Color color;
  @override double strength;
  @override ObjectPosition position;
 
  Brick({
    required this.height,
    required this.width,
    required this.color,
    required this.strength,
    required this.position,
  });
}


class Ball extends GameObject{
  ObjectVelocity velocity = ObjectVelocity();
  double radius;
  @override double strength = double.infinity;
  @override ObjectPosition position;
  Ball({
    required this.radius,
    required this.position,
  });
}


class Paddle extends GameObject{
  double height;
  double width;
  @override double strength = double.infinity;
  @override ObjectPosition position;
  Paddle({
    required this.height,
    required this.width,
    required this.position,
  });
}


class GameModel extends ChangeNotifier{

  Ball ball = Ball(
    radius: 0.02,
    position: ObjectPosition(x: 0, y: 0));

  Paddle paddle = Paddle(
    height: 0.03,
    width: 0.3,
    position: ObjectPosition(x: 0, y: 0.9));

  List<Brick> bricks = [];
  bool hasEnded = false;
  late Timer timer;

  void startGame(){
    ball.velocity.y = 0.01;
    ball.velocity.x = 0.005;
    timer = Timer.periodic(
      const Duration(milliseconds: 10),
      (timer) {
        ball.position.x += ball.velocity.x;
        ball.position.y += ball.velocity.y;

        var _wallCollision = wallCollision();
        var _paddleCollision = paddleCollision();

        if(_wallCollision != null){
          if(_wallCollision.surface == Surface.vertical){
            ball.velocity.x = -ball.velocity.x;
          }
          else{
            ball.velocity.y = -ball.velocity.y;
          }
        }
        if(_paddleCollision != null){
          ball.velocity.y = -ball.velocity.y;
        }
        
        
        if(isGameOver){
          ball.velocity.x = 0;
          ball.velocity.y = 0;
          gameOver();
          return;
        }
        notifyListeners();
      }
    );
  }
  void gameOver(){
    timer.cancel();
  }

  void movePaddle(double position){
    paddle.position.x = position;
    notifyListeners();
  }

  CollisionDetails? wallCollision(){
    if(ball.position.x.abs() >= 1){
      return CollisionDetails(surface: Surface.vertical);
    }
    if(ball.position.y <= -1){
      return CollisionDetails(surface: Surface.horizontal);
    }
    return null;
  }

  CollisionDetails? paddleCollision(){
    if(
      ball.position.y + ball.radius >= paddle.position.y - paddle.height/2
      && ball.position.x - ball.radius < paddle.position.x + paddle.width/2
      && ball.position.x + ball.radius > paddle.position.x - paddle.width/2
    ){
      return CollisionDetails(surface: Surface.vertical);
    }
    else{
      return null;
    }
  }

  bool get isGameOver {
    return ball.position.y >= 1;
  }

  // var ball = Ball(radius: radius, color: color, position: position)
  // var paddle = Paddle(height: height, width: width, color: color, position: position)
  // List<Brick> bricks = [];
  // StreamSubscription<CollisionDetails> collisionStream;

  // void removeBrick(Brick brick){
  //   bricks.remove(brick);
  //   notifyListeners();
  // }


  // CollisionDetails? collision(){
  //   for(var brick in bricks){
  //     double brickLeft = brick.position.x - brick.width/2;
  //     double brickRight = brick.position.x + brick.width/2;
  //     double brickTop = brick.position.y + brick.height/2;
  //     double brickBottom = brick.position.y - brick.height/2;

  //     double ballLeft = ball.position.x - ball.radius/2;
  //     double ballRight = ball.position.x + ball.radius/2;
  //     double ballTop = ball.position.y + ball.radius/2;
  //     double ballBottom = ball.position.y - ball.radius/2;

  //   //   if(ball.position.x.abs() > 1){
  //   //     return CollisionDetails(brickIndex: brickIndex, surface: surface)
  //   //   }
      
  //    }
  //    return null;
  // }
}