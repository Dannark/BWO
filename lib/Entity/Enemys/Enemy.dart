import 'dart:math';

import 'package:BWO/Entity/Enemys/IAController.dart';
import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Utils/OnAnimationEnd.dart';
import 'package:BWO/Utils/SpriteController.dart';
import 'package:flutter/material.dart';

class Enemy extends Entity implements OnAnimationEnd {
  MapController map;
  IAController iaController;

  Enemy(double x, double y, this.map, String spriteFolder) : super(x, y) {
    _loadSprites(spriteFolder);
    shadownSize = 1.2;

    iaController = IAController(this);
  }

  SpriteController walkSprites;
  SpriteController attackSprites;
  SpriteController currentSprite;

  void draw(Canvas c) {
    mapHeight = map.map[posY][posX][0].height;

    var maxWalkSpeed = 2;
    var walkSpeed = max(xSpeed.abs(), ySpeed.abs());
    var deltaSpeed = (walkSpeed / maxWalkSpeed);
    var animSpeed = 0.07 + (0.1 - (deltaSpeed * 0.1));

    if (currentSprite != null) {
      var stopAnimWhenIdle = true;

      currentSprite.draw(
          c, x, y, xSpeed, ySpeed, animSpeed, stopAnimWhenIdle, mapHeight);
    }
  }

  void update() {
    iaController.update();
    slowSpeedWhenItSinks(mapHeight);
    moveWithPhysics();
    updatePhysics();
  }

  void _loadSprites(spriteFolder) {
    Rect _viewPort = Rect.fromLTWH(0, 0, 16, 16);
    Offset _pivot = Offset(8, 16);
    double _scale = 3;
    Offset _gradeSize = Offset(4, 1);
    int framesCount = 0;

    width = 12 * _scale;
    height = 6 * _scale;

    walkSprites = new SpriteController(
        spriteFolder, _viewPort, _pivot, _scale, _gradeSize, framesCount, this);
    attackSprites = new SpriteController(
        spriteFolder, _viewPort, _pivot, _scale, _gradeSize, framesCount, this);

    currentSprite = walkSprites;
  }

  @override
  void onAnimationEnd() {
    currentSprite = walkSprites;
  }
}
