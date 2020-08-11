import 'dart:ui';

import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Entity/EquipmentController.dart';
import 'package:BWO/Entity/Items/Items.dart';
import 'package:BWO/Entity/Player/InputController.dart';
import 'package:BWO/Entity/Player/Inventory.dart';
import 'package:BWO/Entity/Player/PlayerActions.dart';
import 'package:BWO/Entity/Player/PlayerHUD.dart';
import 'package:BWO/Entity/Player/PlayerNetwork.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Scene/SceneObject.dart';
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

  Paint boxPaint = Paint();
  Rect boxRect;

  SpriteController walkSprites;
  SpriteController attackSprites;
  SpriteController currentSprite;
  Sprite deathSprite = Sprite("effects/rip.png");
  double timeToRespawn = 0;

  PlayerActions playerActions;
  InputController _inputController;
  MapController map;

  Inventory inventory;
  PlayerHUD _playerHUD;
  PlayerNetwork playerNetwork;
  bool isMine;
  SceneObject sceneObject;
  String spriteFolder;

  EquipmentController equipmentController;

  Player(double x, double y, this.map, this.isMine, String myName, String myId,
      this.sceneObject,
      {String spriteFolder = "human/male1"})
      : super(x, y) {
    this.spriteFolder = spriteFolder;
    playerActions = PlayerActions(this);
    playerNetwork = PlayerNetwork(this);

    if (isMine) {
      inventory = Inventory(this, sceneObject.hud);
      _playerHUD = PlayerHUD(this, sceneObject.hud);
      equipmentController = EquipmentController(this);
      _inputController = InputController(this);
    }
    id = myId;
    name = myName;
    //print("adding player [$name] with sprite: $spriteFolder");
    _loadSprites();
  }

  void draw(Canvas c) {
    die(c);
    if (isActive == false) {
      return;
    }
    mapHeight = map.getHeightOnPos(posX, posY);

    var maxWalkSpeed = 3.0;
    if (_inputController != null) {
      maxWalkSpeed =
          (_inputController.maxAngle * _inputController.speedMultiplier);
    }
    var walkSpeed = max(xSpeed.abs(), ySpeed.abs()) * maxSpeedEnergyMultiplier;
    var deltaSpeed = (walkSpeed / maxWalkSpeed);
    var animSpeed = 0.07 + (0.1 - (deltaSpeed * 0.1));
    //var playAnim = animSpeed < .17;

    if (currentSprite != null) {
      bool stopAnimWhenIdle = true;
      if (currentSprite.folder.contains("/attack")) {
        stopAnimWhenIdle = false;
        animSpeed = 0.07;
      }

      currentSprite.draw(c, x, y, xSpeed, ySpeed, animSpeed, stopAnimWhenIdle,
          mapHeight); //0.125 = 12fps

      equipmentController?.draw(c, stopAnimWhenIdle, animSpeed);
    }

    config.render(c, name, Position(x, y - 45), anchor: Anchor.bottomCenter);
  }

  @override
  void update() {
    super.update();
    if (isActive == false) {
      return;
    }
    _inputController?.update();

    slowSpeedWhenItSinks(mapHeight);
    moveWithPhysics();
    playerActions.interactWithTrees(map);
    playerNetwork.update();
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

        playerNetwork.refillStatus();
      }
    }
  }

  void setDirection(Offset target) {
    currentSprite.setDirection(target, Offset(x, y));
    equipmentController?.setDirection(target, Offset(x, y));
  }

  void setTargetPosition(double newX, double newY) {
    playerNetwork.setTargetPosition(newX, newY);
  }

  @override
  void getHut(int damage, bool isMine, Entity other) {
    // TODO: implement getHut
    super.getHut(damage, isMine, other);
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

    walkSprites = new SpriteController("$spriteFolder/walk", _viewPort, _pivot,
        _scale, _gradeSize, framesCount, this);
    attackSprites = new SpriteController("$spriteFolder/attack", _viewPort,
        _pivot, _scale, Offset(5, 1), framesCount, this);

    currentSprite = walkSprites;
  }

  @override
  void onAnimationEnd() {
    if (currentSprite == attackSprites) {
      currentSprite = walkSprites;
      currentSprite.setDirectionAngle(attackSprites.getDirectionAngle());
    }
  }
}
