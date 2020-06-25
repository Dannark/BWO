import 'package:BWO/Effects/RippleWaterEffect.dart';
import 'package:BWO/Effects/WalkEffect.dart';
import 'package:BWO/Entity/Player.dart';
import 'package:BWO/Map/tree.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

abstract class Entity{
  int posX;
  int posY;

  double x,y;
  var mapHeight = 1;
  double width = 16;
  double height = 16;

  Rect colisionBox;
  double worldSize;

  Paint p = new Paint();

  Offset velocity = Offset.zero;

  Sprite shadown = new Sprite("shadown.png");
  Sprite shadown_large = new Sprite("shadown_large.png");
  RippleWaterEffect _rippleWaterEffect = RippleWaterEffect();
  WalkEffect _walkEffect = WalkEffect();

  Entity(this.x, this.y){
    worldSize = GameController.worldSize.toDouble();

    updatePhysics();
  }

  void draw(Canvas c){
    print("drawning wrongly");
  }
  void debugDraw(Canvas c){
    p.color = Colors.red;
    p.strokeWidth = 1;
    p.style = PaintingStyle.stroke;
    c.drawRect(colisionBox, p);
  }

  void drawEffects(Canvas c){
    _drawShadown(c);
    if(this is Player){
      _rippleWaterEffect.draw(c, x, y, mapHeight);
      _walkEffect.draw(c, x, y, mapHeight, velocity);
    }
  }

  void _drawShadown(Canvas c){
    if(this is Tree){
      shadown_large.renderScaled(c, Position(x-25,y-20), scale: 3);
    }
    else{
      shadown.renderScaled(c, Position(x-15,y-20), scale: 3);
    }
  }
  
  void updatePhysics(){
    posX = x ~/ worldSize;
    posY = y ~/ worldSize;

    colisionBox = Rect.fromLTWH(x-(width/2), y-height, width, height);
  }

  void moveWithPhysics(double xSpeed, double ySpeed){
    x -= xSpeed * GameController.deltaTime * 50;
    y -= ySpeed * GameController.deltaTime * 50;

    velocity = Offset(xSpeed, ySpeed);
  }
}
