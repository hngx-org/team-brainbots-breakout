import 'package:brainbots_breakout/src/game/managers/managers.dart';
import 'package:brainbots_breakout/src/game/sprites/paddle.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum Surface {vertical, horiontal}

class Ball extends SpriteComponent with HasGameRef, CollisionCallbacks{

  GameManager gameManager;
  LevelManager levelManager;
  Ball({
    required this.gameManager,
    required this.levelManager,
  });

  late Vector2 _velocity;
  late Vector2 _gravity;
  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('ball.png');
    width *= 0.2;
    height *= 0.2;
    
    hitbox = CircleHitbox();
    add(hitbox);
  }

  @override
  void update(dt){
    //TODO: if there are no bricks left go to win screen
    if(gameManager.isGameOver) return;
    if(gameManager.isIntro) reset();

    wallRebound();
    if ((position.y + height) >= game.size.y * 0.925){
      gameOver();
    }
    _velocity += _gravity * dt;
    position += _velocity * dt;
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2>intersectionPoints, PositionComponent other){
    super.onCollision(intersectionPoints, other);
    if ((intersectionPoints.first.x - intersectionPoints.last.x).abs() < 2){ // horizontal collision
      rebound(Surface.vertical); 
    }
    else{ // vertical collision
      rebound(Surface.horiontal);
    }
    if (other is Paddle){
      // gameManager.score.value += 1;
      // print(gameManager.score.value);
      // print('$runtimeType collided with ${other.runtimeType}');
    }
    // TODO: handle collision for bricks
  }

  void wallRebound(){
    if(position.x <= 0 || (position.x + width) >= game.size.x){
      rebound(Surface.vertical);
    }
    if(position.y <= 0 || (position.y + height) >= game.size.y){
      rebound(Surface.horiontal);
    }
  }

  void rebound(Surface surface){
    if(surface == Surface.vertical){
      _velocity.x *= -1;
    }
    else{
      _velocity.y *= -1;
    }
  }

  void reset(){
    x = game.size.x/2 - width/2;
    y = game.size.y/2 - height/2;

    _velocity = levelManager.ballSpeed;
    _gravity = levelManager.gravity;
    gameManager.state = GameState.playing;
  }

  void gameOver(){
    gameManager.state = GameState.gameOver;
    // TODO: show game over screen
  }
}