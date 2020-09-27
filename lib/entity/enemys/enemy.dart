import 'dart:math';

import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

import '../../game_controller.dart';
import '../../map/map_controller.dart';
import '../../utils/on_animation_end.dart';
import '../../utils/sprite_controller.dart';
import '../entity.dart';
import 'ia_controller.dart';
import 'ia_network_controller.dart';

class Enemy extends Entity implements OnAnimationEnd {
  MapController map;
  IAController iaController;
  bool respawn = false;
  double respawnTime = 0;
  String spriteFolder;

  Enemy(double x, double y, this.map, this.spriteFolder, String myId)
      : super(x, y) {
    _loadSprites(spriteFolder);
    shadownSize = 1.2;
    id = myId;
    iaController = IANetworkController(this);
  }

  SpriteController walkSprites;
  SpriteController attackSprites;
  SpriteController currentSprite;

  void draw(Canvas c) {
    if (isActive == false) {
      return;
    }
    mapHeight = map.getHeightOnPos(posX, posY);

    var maxWalkSpeed = 2;
    var walkSpeed = max(xSpeed.abs(), ySpeed.abs());
    var deltaSpeed = (walkSpeed / maxWalkSpeed);
    var animSpeed = 0.07 + (0.1 - (deltaSpeed * 0.1));

    if (currentSprite != null) {
      var stopAnimWhenIdle = true;
      if (currentSprite.folder.contains("attack")) {
        stopAnimWhenIdle = false;
        animSpeed = 0.07;
      }

      currentSprite.draw(c, x*map.scale, y*map.scale, xSpeed, ySpeed, animSpeed, mapHeight,
          stopAnimWhenIdle: stopAnimWhenIdle);
    }
    //debugDraw(c);
    TextConfig(fontSize: 11.0, color: Colors.white, fontFamily: "Blocktopia")
        .render(c, name, Position(x*map.scale, y*map.scale - 32*map.scale), anchor: Anchor.bottomCenter);
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
        isActive = false;
        if (respawn) {
          respawnTime = GameController.time + 10;
        } else {
          destroy();
        }
      }
      if (GameController.time > respawnTime) {
        isActive = true;
        status.refillStatus();
      }
    }
  }

  @override
  void getHut(int damage, Entity other, {bool isMine = false}) {
    super.getHut(damage, other, isMine: isMine);
    iaController.target = other;
  }

  void _loadSprites(spriteFolder) {
    var _viewPort = Rect.fromLTWH(0, 0, 16, 16);
    var _pivot = Offset(8, 16);
    var _scale = 3.0;
    var _gradeSize = Offset(4, 1);
    var framesCount = 0;

    width = 6 * _scale;
    height = 6 * _scale;

    walkSprites = SpriteController("$spriteFolder/walk", _viewPort, _pivot,
        _scale, _gradeSize, framesCount, this);
    attackSprites = SpriteController("$spriteFolder/attack", _viewPort, _pivot,
        _scale, _gradeSize, framesCount, this);

    currentSprite = walkSprites;
  }

  @override
  void onAnimationEnd() {
    if (currentSprite == attackSprites) {
      currentSprite = walkSprites;
    }
  }
}
