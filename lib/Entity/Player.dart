import 'dart:ui';

import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Entity/Frame.dart';
import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

class Player extends Entity {

  TextConfig config = TextConfig(fontSize: 12.0, color: Colors.white);

  double xSpeed;
  double ySpeed;

  int accelerationSpeed = 3;
  double maxSpeed = 4;

  double defaultY = 6.9; //angle standing up

  Paint boxPaint = Paint();
  Rect boxRect;

  Frame frame;

  double x = 0,y = 0;

  int worldSize;

  Player(int posX, int posY, this.worldSize) : super(posX, posY) {
    accelerometerEvents.listen((AccelerometerEvent event) {
      //defaultY = defaultY == 0? event.y: defaultY; 

      xSpeed = (event.x * accelerationSpeed).clamp(-maxSpeed, maxSpeed).toDouble();
      ySpeed = ((event.y - defaultY) * -accelerationSpeed).clamp(-maxSpeed, maxSpeed)
          .toDouble();
    });

    frame = Frame(
      posX,
      posY,
      7,
      worldSize,
      PixelGroup([
        [0, 3, 3, 3, 0],
        [0, 4, 3, 4, 0],
        [0, 3, 3, 3, 0],
        [3, 2, 2, 2, 3],
        [3, 2, 2, 2, 3],
        [0, 1, 0, 1, 0],
      ], {
        0: null,
        1: Color.fromARGB(255, 0, 0, 0),
        2: Color.fromARGB(255, 185, 122, 87),
        3: Color.fromARGB(255, 248, 235, 218),
        4: Color.fromARGB(255, 0, 0, 0),
      }, "forward"),
    );
  }

  void draw(Canvas c) {
    x -= xSpeed;
    y -= ySpeed;

    frame.draw(c, x, y);

    
    config.render(c, "Player", Position(x+4, y-40), anchor: Anchor.bottomCenter);

    posX = x ~/ worldSize;
    posY = y ~/ worldSize;
  }
}