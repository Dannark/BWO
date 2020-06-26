import 'dart:math';
import 'dart:ui';

import 'package:BWO/Effects/Effect.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class WalkEffect {
  double animSpeed = 1;
  double timeInFuture = 0;
  List<Smoke> smokeEffects = List();

  double timeInFutureForSoundSteps = 0;

  WalkEffect() {
    timeInFuture = GameController.time + 5;
  }

  void draw(Canvas c, double x, double y, int height, Offset walkSpeed) {
    var velocity = (walkSpeed.dx.abs() + walkSpeed.dy.abs()).clamp(0, 3);

    if (height > 110 && velocity > 0) {
      if (GameController.time > timeInFuture) {
        var delay = .11 + ((1 - (velocity / 3)) * 0.5);

        timeInFuture = GameController.time + delay;

        smokeEffects.add(Smoke(x, y));
        smokeEffects.add(Smoke(x, y));
        smokeEffects.add(Smoke(x, y));
      }

      playFootSteps(velocity);
    }

    for (var effect in smokeEffects) {
      effect.draw(c, animSpeed);
    }

    smokeEffects.removeWhere((element) => element.isAlive() == false);
  }

  void playFootSteps(velocity) {
    if (GameController.time > timeInFutureForSoundSteps) {
      var delay = .2 + ((1 - (velocity / 3)) * 0.5);

      timeInFutureForSoundSteps = GameController.time + delay;
        Flame.audio.play("footstep_grass1.mp3", volume: .25);
    }
  }
}

class Smoke {
  double x, y;
  double _scale = 0;
  double lifeTime = 0;

  Paint p = Paint();

  Rect r;
  Rect box;

  Offset direction = Offset(0, 0);

  Smoke(this.x, this.y) {
    lifeTime = GameController.time + .6;

    p.color = Colors.amber[100];

    r = Rect.fromLTWH(x, y - 2, 5, 5);

    var dirX = (Random().nextInt(10) - 5).toDouble() / 10;
    var dirY = (Random().nextInt(10) - 5).toDouble() / 10;
    direction = Offset(dirX, dirY - 1);
  }

  void draw(Canvas c, double animSpeed) {
    _scale = lerpDouble(_scale, 20, GameController.deltaTime * animSpeed);

    p.color = Color.lerp(p.color, Color.fromRGBO(150, 150, 100, 0),
        GameController.deltaTime * animSpeed * 5);

    r = Rect.fromLTWH(
      r.left + direction.dx * animSpeed * .7,
      r.top + direction.dy * animSpeed * .7,
      2 + _scale,
      2 + _scale,
    );
    if (GameController.time > lifeTime - .5) {
      c.drawRect(r, p);
    }
  }

  bool isAlive() {
    return GameController.time < lifeTime;
  }
}
