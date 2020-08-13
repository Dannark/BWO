import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../game_controller.dart';

class RippleWaterEffect {
  double animSpeed = 1;
  double timeinFuture = 0;

  List<Ripple> rippleEffects = <Ripple>[];

  RippleWaterEffect() {
    timeinFuture = GameController.time + 5;
  }

  void draw(Canvas c, double x, double y, int height) {
    if (GameController.time > timeinFuture && height < 107) {
      timeinFuture = GameController.time + .3;

      rippleEffects.add(Ripple(x, y));
    }

    for (var effect in rippleEffects) {
      effect.draw(c, animSpeed);
    }

    rippleEffects.removeWhere((element) => element.isAlive() == false);
  }
}

class Ripple {
  double x, y;
  double _scale = 1.5;
  double alpha = 0;
  double lifeTime = 0;

  Paint p = Paint();

  Sprite ripple = Sprite("effects/ripple.png");

  Ripple(this.x, this.y) {
    lifeTime = GameController.time + 4;
  }

  void draw(Canvas c, double animSpeed) {
    alpha = lerpDouble(alpha, 4, GameController.deltaTime * animSpeed);
    _scale = alpha;
    p.color = Color.fromRGBO(255, 255, 255, 1 - (alpha.clamp(0, 3) / 3));

    var halfwidth = (16 * _scale) / 2;
    var halfheight = (16 * _scale) / 2;

    ripple.renderScaled(c, Position(x - halfwidth, y - halfheight),
        scale: _scale, overridePaint: p);
  }

  bool isAlive() {
    return GameController.time < lifeTime;
  }
}
