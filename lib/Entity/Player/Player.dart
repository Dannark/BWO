import 'dart:ui';

import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Entity/Items/Items.dart';
import 'package:BWO/Entity/Player/Inventory.dart';
import 'package:BWO/Entity/Player/PlayerActions.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Utils/Frame.dart';
import 'package:BWO/Utils/OnAnimationEnd.dart';
import 'package:BWO/Utils/SpriteController.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/anchor.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/sprite_batch.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';

class Player extends Entity implements OnAnimationEnd {
  TextConfig config =
      TextConfig(fontSize: 12.0, color: Colors.white, fontFamily: "Blocktopia");

  int accelerationSpeed = 4;
  double maxAngle = 5;
  double speedMultiplier = .6;

  double previousY = 0;
  double defaultY = 6.9; //angle standing up

  Paint boxPaint = Paint();
  Rect boxRect;

  SpriteController walkSprites;
  SpriteController attackSprites;
  SpriteController currentSprite;
  Sprite deathSprite = Sprite("effects/rip.png");
  double timeToRespawn = 0;

  PlayerActions _playerActions;
  MapController map;

  Inventory inventory;

  Player(double x, double y, this.map) : super(x, y) {
    _playerActions = PlayerActions(this);
    inventory = Inventory(this);

    accelerometerEvents.listen((AccelerometerEvent event) {
      double eventX = event.x;
      double eventY = event.y;
      if (event.z < 0) {
        eventX = eventX * 1;
        eventY = eventY * -1;
      }

      if (TapState.isTapingRight()) {
        xSpeed =
            (eventX * accelerationSpeed).clamp(-maxAngle, maxAngle).toDouble() *
                speedMultiplier;
        ySpeed = ((eventY - defaultY) * -accelerationSpeed)
                .clamp(-maxAngle, maxAngle)
                .toDouble() *
            speedMultiplier;
      } else {
        previousY = eventY;
        xSpeed = 0;
        ySpeed = 0;
      }

      if (ySpeed.abs() + xSpeed.abs() < 0.6 || _playerActions.isDoingAction) {
        xSpeed = 0;
        ySpeed = 0;
      }
    });

    _loadSprites();
  }

  void draw(Canvas c) {
    die(c);
    if (isActive == false) {
      return;
    }
    mapHeight = map.map[posY][posX][0].height;

    var maxWalkSpeed = (maxAngle * speedMultiplier);
    var walkSpeed = max(xSpeed.abs(), ySpeed.abs());
    var deltaSpeed = (walkSpeed / maxWalkSpeed);
    var animSpeed = 0.07 + (0.1 - (deltaSpeed * 0.1));
    //var playAnim = animSpeed < .17;

    if (currentSprite != null) {
      bool stopAnimWhenIdle = true;
      if (currentSprite.folder == "human/attack") {
        stopAnimWhenIdle = false;
        animSpeed = 0.07;
      }

      currentSprite.draw(c, x, y, xSpeed, ySpeed, animSpeed, stopAnimWhenIdle,
          mapHeight); //0.125 = 12fps
    }

    config.render(c, "Player", Position(x, y - 45),
        anchor: Anchor.bottomCenter);

    //inventory.drawPosition(c, x, y);
  }

  void update() {
    if (isActive == false) {
      return;
    }
    if (GameController.tapState == TapState.DOWN) {
      defaultY = previousY;
    }
    slowSpeedWhenItSinks(mapHeight);
    moveWithPhysics();
    _playerActions.interactWithTrees(map);
  }

  void die(Canvas c) {
    if (status.isAlive() == false) {
      isActive = false;
      deathSprite.renderScaled(c, Position(x - 16, y - 32), scale: 2);

      if (timeToRespawn == 0) {
        timeToRespawn = GameController.time + 5;
      }
      if (GameController.time > timeToRespawn) {
        timeToRespawn = 0;
        x = 0;
        y = 0;
        status.refillStatus();
        isActive = true;
      }
    }
  }

  void setDirection(Offset target) {
    currentSprite.setDirection(target, Offset(x, y));
  }

  @override
  void getHut(int damage) {
    // TODO: implement getHut
    super.getHut(damage);
  }

  @override
  void onTriggerStay(Entity entity) {
    if (entity is Item) {
      inventory.addItem(entity) ? entity.destroy() : null;
      status.addExp(2);

      Flame.audio.play("pickup_item1.mp3", volume: 0.9);
    }
  }

  void _loadSprites() {
    Rect _viewPort = Rect.fromLTWH(0, 0, 16, 16);
    Offset _pivot = Offset(8, 16);
    double _scale = 3;
    Offset _gradeSize = Offset(4, 1);
    int framesCount = 0;

    width = 12 * _scale;
    height = 6 * _scale;

    walkSprites = new SpriteController(
        "human/walk", _viewPort, _pivot, _scale, _gradeSize, framesCount, this);
    attackSprites = new SpriteController("human/attack", _viewPort, _pivot,
        _scale, Offset(5, 1), framesCount, this);

    currentSprite = walkSprites;
  }

  @override
  void onAnimationEnd() {
    if (currentSprite == attackSprites) {
      currentSprite = walkSprites;
    }
  }
}
