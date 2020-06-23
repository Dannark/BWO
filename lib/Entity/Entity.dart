import 'package:BWO/game_controller.dart';
import 'package:flutter/material.dart';

abstract class Entity{
  int posX;
  int posY;

  double x,y;
  double width = 16;
  double height = 16;

  Rect colisionBox;
  double worldSize;

  Paint p = new Paint();

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
  
  void updatePhysics(){
    posX = x ~/ worldSize;
    posY = y ~/ worldSize;

    colisionBox = Rect.fromLTWH(x-(width/2), y-height, width, height);
  }

  void moveWithPhysics(double xSpeed, double ySpeed){
    x -= xSpeed * GameController.deltaTime * 50;
    y -= ySpeed * GameController.deltaTime * 50;
  }
}
