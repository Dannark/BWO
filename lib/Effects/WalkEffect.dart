import 'dart:math';
import 'dart:ui';

import 'package:BWO/Effects/Effect.dart';
import 'package:BWO/Map/ground.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/animation.dart' as anim;
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';

class WalkEffect {
  double animSpeed = 1;
  double timeInFuture = 0;
  double timeInFutureForGrass = 0;
  List<Smoke> smokeEffects = List();

  double timeInFutureForSoundSteps = 0;

  List<GrassFX> grassAnimList = [];

  WalkEffect() {
    timeInFuture = GameController.time + 5;
    timeInFutureForGrass = GameController.time + 5;
  }

  void draw(Canvas c, double x, double y, int height, Offset walkSpeed) {
    var velocity = max(walkSpeed.dx.abs(), walkSpeed.dy.abs());

    if (velocity > 0) {
      height < Ground.WATER
          ? playStepSFX(velocity, "swim_1.mp3", .8, interval: .9)
          : null;
      height >= Ground.WATER && height <= Ground.LOW_WATER - 9
          ? playStepSFX(velocity, "footstep_water_splash.mp3", .3)
          : null;
      height >= Ground.WATER + 9 && height <= Ground.LOW_WATER
          ? playStepSFX(velocity, "footstep_water_splash2.mp3", .4)
          : null;
      height >= Ground.LOW_SAND && height <= Ground.SAND
          ? addSmokeFX(velocity, x, y)
          : null;
      height >= Ground.LOW_SAND && height <= Ground.SAND
          ? playStepSFX(velocity, "footstep_sand_beech.mp3", .3)
          : null;
      height >= Ground.SAND && height <= Ground.LOW_GRASS
          ? playStepSFX(velocity, "footstep_grass2.mp3", .03)
          : null;
      height >= Ground.LOW_GRASS
          ? playStepSFX(velocity, "footstep_grass1.mp3", .2)
          : null;
      height > Ground.LOW_GRASS ? addGrassFX(velocity, x, y) : null;
    }

    for (var effect in smokeEffects) {
      effect.draw(c, animSpeed);
    }

    for (var grassAnim in grassAnimList) {
      grassAnim.draw(c);
    }

    smokeEffects.removeWhere((element) => element.isAlive() == false);
    grassAnimList.removeWhere((element) => element.isAlive() == false);
  }

  void addGrassFX(velocity, x, y) {
    if (GameController.time > timeInFutureForGrass) {
      var delay = .11 + ((1 - (velocity / 3)) * 0.5);
      timeInFutureForGrass = GameController.time + delay;

      grassAnimList.add(GrassFX(x, y));
    }
  }

  void addSmokeFX(velocity, x, y) {
    if (GameController.time > timeInFuture) {
      var delay = .11 + ((1 - (velocity / 3)) * 0.5);

      timeInFuture = GameController.time + delay;

      smokeEffects.add(Smoke(x, y));
      smokeEffects.add(Smoke(x, y));
      smokeEffects.add(Smoke(x, y));
    }
  }

  void playStepSFX(velocity, audioName, volume, {interval = .25}) {
    if (GameController.time > timeInFutureForSoundSteps) {
      var delay = interval + ((1 - (velocity / 3)) * 0.6);

      timeInFutureForSoundSteps = GameController.time + delay;
      //Flame.audio.play(audioName, volume: volume);
    }
  }
}

class GrassFX {
  double x, y;
  anim.Animation grassAnim;
  Paint p = Paint();

  GrassFX(this.x, this.y) {
    grassAnim = anim.Animation.sequenced('effects/walk_grass.png', 6,
        textureWidth: 16, textureHeight: 16, loop: false, stepTime: 0.1);
    p.color = Color.fromRGBO(255, 255, 255, .75);
  }

  void draw(Canvas c) {
    grassAnim.update(GameController.deltaTime);
    grassAnim
        .getSprite()
        .renderPosition(c, Position(x - 7, y - 8), overridePaint: p);
  }

  bool isAlive() {
    return grassAnim.isLastFrame == false;
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
