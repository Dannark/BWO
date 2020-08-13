import 'dart:math';

import 'package:flutter/material.dart';

import '../game_controller.dart';

class WaterStarsEffect {
  Random r = Random();
  List<Rect> starsOnWater = <Rect>[];
  double nextStarsTime = 0;
  double starsLifeTime = 8;
  Color blinkStarsInitialColor;
  double animSpeed = .5;

  Paint p = Paint();

  Rect boxRect;

  WaterStarsEffect(this.boxRect) {
    nextStarsTime = 5 + GameController.time + r.nextInt(30);
  }

  void blinkWaterEffect(Canvas c) {
    if (GameController.time > nextStarsTime) {
      nextStarsTime = 10 + GameController.time + r.nextInt(60);
      starsLifeTime = GameController.time + 4;
      animSpeed = 0.4 + r.nextDouble() * 0.4;
      starsOnWater = <Rect>[];
      starsOnWater.clear();
      blinkStarsInitialColor = Colors.blue[50];

      var starsAmount = 1; //r.nextInt(1);

      for (var i = 0; i < starsAmount; i++) {
        var x = boxRect.left + (r.nextInt(boxRect.width.toInt()));
        var y = boxRect.top + (r.nextInt(boxRect.height.toInt()));

        starsOnWater.add(Rect.fromLTWH(x, y, 2, 2));
      }
    }
    if (GameController.time > starsLifeTime) {
      starsOnWater.clear();
    }

    for (var stars in starsOnWater) {
      double alpha = (blinkStarsInitialColor.alpha.toDouble() / 255.0 -
              GameController.deltaTime * animSpeed)
          .clamp(0.0, 1.0);
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
