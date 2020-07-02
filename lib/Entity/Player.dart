import 'dart:ui';

import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Entity/Items/Items.dart';
import 'package:BWO/Entity/Player/Inventory.dart';
import 'package:BWO/Entity/Player/PlayerActions.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Utils/Frame.dart';
import 'package:BWO/Utils/SpriteController.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/anchor.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite_batch.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';

class Player extends Entity {
  TextConfig config =
      TextConfig(fontSize: 12.0, color: Colors.white, fontFamily: "Blocktopia");

  double xSpeed = 0;
  double ySpeed = 0;

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

  PlayerActions _playerActions;
  MapController map;

  Inventory inventory;

  Player(double x, double y, this.map) : super(x, y) {
    _playerActions = PlayerActions(this);
    inventory = Inventory(this);

    accelerometerEvents.listen((AccelerometerEvent event) {
      if (TapState.isTapingRight()) {
        xSpeed = (event.x * accelerationSpeed)
                .clamp(-maxAngle, maxAngle)
                .toDouble() *
            speedMultiplier;
        ySpeed = ((event.y - defaultY) * -accelerationSpeed)
                .clamp(-maxAngle, maxAngle)
                .toDouble() *
            speedMultiplier;
      } else {
        previousY = event.y;
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
    debugDraw(c);

    //inventory.drawPosition(c, x, y);
  }

  void update() {
    if (GameController.tapState == TapState.DOWN) {
      defaultY = previousY;
    }
    slowSpeedWhenItSinks(mapHeight);
    moveWithPhysics(xSpeed, ySpeed);
    _playerActions.interactWithTrees(map);
  }

  void setDirection(Offset target) {
    currentSprite.setDirection(target, Offset(x, y));
  }

  void slowSpeedWhenItSinks(int mapHeight, {double slowSpeedFactor = 0.6}) {
    var sink = ((105 - mapHeight) * 0.2).clamp(0, 4);
    double slowFactor = 1 - ((sink * 0.25) * slowSpeedFactor);

    xSpeed *= slowFactor;
    ySpeed *= slowFactor;
  }

  @override
  void onTriggerStay(Entity entity) {
    if (entity is Item) {
      inventory.addItem(entity) ? entity.destroy() : null;

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

    walkSprites = new SpriteController("human/walk", _viewPort, _pivot, _scale,
        _gradeSize, framesCount, this, null);
    attackSprites = new SpriteController("human/attack", _viewPort, _pivot,
        _scale, Offset(5, 1), framesCount, this, walkSprites);

    currentSprite = walkSprites;
  }
}
