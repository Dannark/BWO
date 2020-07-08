import 'dart:math';

import 'package:BWO/Entity/Enemys/IAController.dart';
import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Utils/OnAnimationEnd.dart';
import 'package:BWO/Utils/SpriteController.dart';
import 'package:BWO/game_controller.dart';
import 'package:flutter/material.dart';

class Enemy extends Entity implements OnAnimationEnd {
  MapController map;
  IAController iaController;
  double respawnTime = 0;

  Enemy(double x, double y, this.map, String spriteFolder) : super(x, y) {
    _loadSprites(spriteFolder);
    shadownSize = 1.2;

    iaController = IAController(this);
  }

  SpriteController walkSprites;
  SpriteController attackSprites;
  SpriteController currentSprite;

  void draw(Canvas c) {
    if (isActive == false) {
      return;
    }
    mapHeight = map.map[posY][posX][0].height;

    var maxWalkSpeed = 2;
    var walkSpeed = max(xSpeed.abs(), ySpeed.abs());
    var deltaSpeed = (walkSpeed / maxWalkSpeed);
    var animSpeed = 0.07 + (0.1 - (deltaSpeed * 0.1));

    if (currentSprite != null) {
      bool stopAnimWhenIdle = true;
      if (currentSprite.folder.contains("attack")) {
        stopAnimWhenIdle = false;
        animSpeed = 0.07;
      }

      currentSprite.draw(
          c, x, y, xSpeed, ySpeed, animSpeed, stopAnimWhenIdle, mapHeight);
    }
    debugDraw(c);
  }

  @override
  void update() {
    super.update();
    iaController.update();
    slowSpeedWhenItSinks(mapHeight);
    moveWithPhysics();
    updatePhysics();
    die();
  }

  void die() {
    if (status.isAlive() == false) {
      if (isActive) {
        respawnTime = GameController.time + 10;
        isActive = false;
      }
      if (GameController.time > respawnTime) {
        isActive = true;
        status.refillStatus();
      }
    }
  }

  void _loadSprites(spriteFolder) {
    Rect _viewPort = Rect.fromLTWH(0, 0, 16, 16);
    Offset _pivot = Offset(8, 16);
    double _scale = 3;
    Offset _gradeSize = Offset(4, 1);
    int framesCount = 0;

    width = 6 * _scale;
    height = 6 * _scale;

    walkSprites = new SpriteController(spriteFolder + "/walk", _viewPort,
        _pivot, _scale, _gradeSize, framesCount, this);
    attackSprites = new SpriteController(spriteFolder + "/attack", _viewPort,
        _pivot, _scale, _gradeSize, framesCount, this);

    currentSprite = walkSprites;
  }

  @override
  void onAnimationEnd() {
    if (currentSprite == attackSprites) {
      currentSprite = walkSprites;
    }
  }
}
