import 'dart:math';
import 'dart:ui';

import 'package:BWO/utils/preload_assets.dart';
import 'package:flame/anchor.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

import '../../game_controller.dart';
import '../../hud/build/build_foundation.dart';
import '../../hud/build/build_hud.dart';
import '../../hud/inventory.dart';
import '../../hud/player_hud.dart';
import '../../map/map_controller.dart';
import '../../scene/scene_object.dart' '';
import '../../utils/on_animation_end.dart';
import '../../utils/sprite_controller.dart' '';
import '../entity.dart';
import '../equipment_controller.dart';
import '../items/items.dart';
import 'input_controller.dart';
import 'player_actions.dart';
import 'player_network.dart';

class Player extends Entity implements OnAnimationEnd {
  final TextConfig _text =
      TextConfig(fontSize: 12.0, color: Colors.white, fontFamily: "Blocktopia");

  SpriteController walkSprites;
  SpriteController attackSprites;
  SpriteController currentSprite;
  Sprite _deathSprite;
  double _timeToRespawn = 0;

  PlayerActions playerActions;
  InputController _inputController;
  final MapController _map;

  Inventory _inventory;
  // ignore: unused_field
  PlayerHUD _playerHUD;
  PlayerNetwork playerNetwork;
  bool isMine;
  SceneObject sceneObject;
  String spriteFolder;

  EquipmentController equipmentController;

  bool canWalk = true;

  Player(double x, double y, this._map, String myName, String myId,
      this.sceneObject,
      {this.spriteFolder = "human/male1", this.isMine = false})
      : super(x, y) {
    playerActions = PlayerActions(this);
    playerNetwork = PlayerNetwork(this);

    if (isMine) {
      _inventory = Inventory(this, sceneObject.hud);
      _playerHUD = PlayerHUD(this, sceneObject.hud);
      BuildHUD(this, _map, sceneObject.hud);
      _map.buildFoundation = BuildFoundation(this, _map);
      equipmentController = EquipmentController(this);
      _inputController = InputController(this);
    }
    id = myId;
    name = myName;

    _loadSprites();
  }

  void draw(Canvas c) {
    die(c);
    if (isActive == false) {
      return;
    }
    mapHeight = _map.getHeightOnPos(posX, posY);

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
      var stopAnimWhenIdle = true;
      if (currentSprite.folder.contains("/attack")) {
        stopAnimWhenIdle = false;
        animSpeed = 0.07;
      }

      currentSprite.draw(c, x, y, xSpeed, ySpeed, animSpeed, mapHeight,
          stopAnimWhenIdle: stopAnimWhenIdle); //0.125 = 12fps

      equipmentController?.draw(c, animSpeed,
          stopAnimWhenIdle: stopAnimWhenIdle);
    }
    //debugDraw(c);
    _text.render(c, name, Position(x, y - 45), anchor: Anchor.bottomCenter);
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
    playerActions.interactWithTrees(_map);
    playerNetwork.update();
  }

  void die(Canvas c) {
    if (status.isAlive() == false) {
      isActive = false;
      _deathSprite?.renderScaled(c, Position(x - 16, y - 32), scale: 2);

      if (!isMine) return;

      if (_timeToRespawn == 0) {
        _timeToRespawn = GameController.time + 5;
      }
      if (GameController.time > _timeToRespawn) {
        _timeToRespawn = 0;
        //x = 0;
        //y = 0;
        //status.refillStatus();
        //isActive = true;

        playerNetwork.refillStatus();
      }
    }
  }

  void respawn() {
    x = 0;
    y = 0;
    playerNetwork.setTargetPosition(x, y);
    isActive = true;
    status.refillStatus();
  }

  void setDirection(Offset target) {
    currentSprite.setDirection(target, Offset(x, y));
    equipmentController?.setDirection(target, Offset(x, y));
  }

  void setTargetPosition(double newX, double newY) {
    playerNetwork.setTargetPosition(newX, newY);
  }

  @override
  void getHut(int damage, Entity other, {bool isMine = false}) {
    super.getHut(damage, other, isMine: isMine);
  }

  @override
  void onTriggerStay(Entity entity) {
    if (!isMine) return;
    if (entity is Item) {
      _inventory.addItem(entity) ? entity.destroy() : null;

      Flame.audio.play("pickup_item1.mp3", volume: 0.9);
    }
  }

  void _loadSprites() {
    _deathSprite = PreloadAssets.getEffectSprite('rip');
    var _viewPort = Rect.fromLTWH(0, 0, 16, 16);
    var _pivot = Offset(8, 16);
    var _scale = 3.0;
    var _gradeSize = Offset(4, 1);
    var _framesCount = 0;

    width = 10 * _scale;
    height = 6 * _scale;

    walkSprites = SpriteController("$spriteFolder/walk", _viewPort, _pivot,
        _scale, _gradeSize, _framesCount, this);
    attackSprites = SpriteController("$spriteFolder/attack", _viewPort, _pivot,
        _scale, Offset(5, 1), _framesCount, this);

    currentSprite = walkSprites;
  }

  @override
  void onAnimationEnd() {
    if (currentSprite == attackSprites) {
      currentSprite = walkSprites;
      currentSprite.direcion = attackSprites.direcion;
    }
  }
}
