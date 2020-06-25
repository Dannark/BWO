import 'dart:math';

import 'package:BWO/game_controller.dart';
import 'package:flutter/material.dart';

class WaterStarsEffect{
  Random r = Random();
  List<Rect> starsOnWater = List();
  double nextStarsTime = 0;
  double starsLifeTime = 8;
  Color blinkStarsInitialColor;
  double animSpeed = .5;

  Paint p = new Paint();

  Rect boxRect;

  WaterStarsEffect(this.boxRect){
    nextStarsTime = 5 + GameController.time + r.nextInt(30);
  }

  void blinkWaterEffect(Canvas c) {
    if (GameController.time > nextStarsTime) {
      nextStarsTime = 10 + GameController.time + r.nextInt(60);
      starsLifeTime = GameController.time+ 4;
      animSpeed = 0.4+r.nextDouble() * 0.4;
      starsOnWater = List();
      starsOnWater.clear();
      blinkStarsInitialColor = Colors.blue[50];

      int starsAmount = 1;//r.nextInt(1);

      for (int i = 0; i < starsAmount; i++) {
        double x = boxRect.left + (r.nextInt(boxRect.width.toInt()));
        double y = boxRect.top + (r.nextInt(boxRect.height.toInt()));

        starsOnWater.add(Rect.fromLTWH(x, y, 2, 2));
      }
    }
    if (GameController.time > starsLifeTime) {
      starsOnWater.clear();
    }

    for (var stars in starsOnWater) {
      double alpha = (blinkStarsInitialColor.alpha.toDouble()/255.0 - GameController.deltaTime * animSpeed).clamp(0.0, 1.0);
      blinkStarsInitialColor = Color.fromRGBO(
        blinkStarsInitialColor.red,
        blinkStarsInitialColor.green,
        blinkStarsInitialColor.blue,
        alpha,
      );
      p.color = blinkStarsInitialColor;
      
      c.drawRect(stars, p);
    }
  }
}