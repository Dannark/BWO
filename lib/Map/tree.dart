import 'dart:math';
import 'dart:ui';
import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Entity/Items/ItemDatabase.dart';
import 'package:BWO/Entity/Items/Items.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Map/tile.dart';
import 'package:BWO/Scene/GameScene.dart';
import 'package:BWO/Utils/PreloadAssets.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/flame.dart';
import 'package:flame/flame_audio.dart';
import 'package:flame/sprite.dart';
import 'package:flame/sprite_batch.dart';
import 'package:flutter/material.dart';

class Tree extends Entity {
  int _tileSize;
  SpriteBatch _tree;
  String _spriteImage;
  double delay = 0.05;
  bool _isPlaingAnimation = false;

  int _currentRotationId = 0;
  List<double> rotationList = [0, 0, -0.05, 0.04, -0.02, 0.01, 0];
  double _timeInFuture = 0;

  int applesLeft = 1;

  FlameAudio audio = FlameAudio();
  double _deadRotation = 0;
  double _gravityRotation = 0;

  MapController map;
  double deleteTime = double.infinity;
  double respawnTime = double.infinity;

  Tree(int posX, int posY, this._tileSize, this._spriteImage)
      : super((posX.toDouble() * GameScene.worldSize),
            (posY.toDouble() * GameScene.worldSize)) {
    width = 2.0 * _tileSize;
    height = 2.0 * _tileSize;
    updatePhysics();
    loadSprite();

    status.setLife(20);

    shadownSize = 4;
    applesLeft = Random().nextInt(1) + 1;
  }

  void loadSprite() async {
    //_tree = await SpriteBatch.withAsset('trees/${_spriteImage}.png');
    _tree = PreloadAssets.getTreeSprite(_spriteImage);
    _tree.add(
        rect: Rect.fromLTWH(0, 0, 16, 16),
        offset: Offset(
            posX.toDouble() * _tileSize, (posY.toDouble() - 1) * _tileSize),
        anchor: Offset(8, 14),
        scale: _tileSize.toDouble(),
        rotation: 0 //-0.05
        );
  }

  @override
  void draw(Canvas c) {
    if (_tree != null) {
      if (status.isAlive()) {
        hitted();
      } else {
        _chopDownTree();
        _die();
      }
      isActive ? _tree.render(c) : null;
    }

    //isActive ? debugDraw(c) : null;
  }

  void _die() {
    if (deleteTime == double.infinity) {
      deleteTime = GameController.time + 4;
    }
    if (GameController.time > deleteTime && isActive) {
      _dropLogs();
      //destroy(); //make it inactive instead becase we want to respawn it
      isActive = false;
      respawnTime = GameController.time + 164;

      _gravityRotation = 0;
      _deadRotation = 0;
    }

    //resets
    if (GameController.time > respawnTime) {
      resetTree();
    }
  }

  void resetTree() {
    isActive = true;
    _gravityRotation = 0;
    _deadRotation = 0;
    status.refillStatus();
    applesLeft = Random().nextInt(1) + 1;
    respawnTime = double.infinity;
    deleteTime = double.infinity;
    updatePhysics();
  }

  void _chopDownTree() {
    _gravityRotation +=
        (GameController.deltaTime * .04) + (_gravityRotation.abs()) * 0.06;

    _deadRotation += _gravityRotation;

    if (_deadRotation > 1.5) {
      _deadRotation = 1.5;
      if (_gravityRotation > 0.02) {
        _gravityRotation = -_gravityRotation * bounciness;
      } else {
        _gravityRotation = 0;
      }
    }

    if (_deadRotation > .5) {
      collisionBox = Rect.fromLTWH(
        collisionBox.left,
        collisionBox.top,
        lerpDouble(collisionBox.width, 128, GameController.deltaTime * 2),
        collisionBox.height,
      );
    }

    _updateFrame(_deadRotation);
  }

  void _updateFrame(double rot) {
    _tree.clear();
    _tree.add(
        rect: Rect.fromLTWH(0, 0, 16, 16),
        offset: Offset(
            posX.toDouble() * _tileSize, (posY.toDouble() - 1) * _tileSize),
        anchor: Offset(8, 14),
        scale: _tileSize.toDouble(),
        rotation: rot //-0.05
        );
  }

  void hitted() {
    if (GameController.time > _timeInFuture && _isPlaingAnimation) {
      _timeInFuture = GameController.time + delay;

      _currentRotationId++;

      if (_currentRotationId >= rotationList.length) {
        _currentRotationId = 0;
        _isPlaingAnimation = false;
      }
    }

    if (delay <= 0.01) {
      _currentRotationId = 0;
    }

    _updateFrame(rotationList[_currentRotationId]);
  }

  void _playAnimation() {
    _isPlaingAnimation = true;
  }

  void doAction(MapController map) {
    if (isActive && status.isAlive()) {
      this.map = map;
      _playAnimation();

      Item maca = _dropApple();
      if (maca != null) {
        map.addEntity(maca);
      }
      status.takeDamage(1);

      //Flame.audio.play("impact_tree.mp3", volume: 0.5);
      audio.play('punch.mp3', volume: 0.4);
    }
  }

  Item _dropApple() {
    if (Random().nextInt(100) < 3 && applesLeft > 0) {
      applesLeft--;
      return Item(x - 32, y, 100, ItemDatabase.itemList[0]);
    }
    return null;
  }

  void _dropLogs() {
    var logAmount = Random().nextInt(3) + 1;

    for (var i = 0; i < logAmount; i++) {
      double rPosX = x + Random().nextInt(130).toDouble() - 30;
      double rPosY = y + Random().nextInt(50).toDouble() - 25;
      double zPosZ = Random().nextInt(30).toDouble() + 10;

      map.addEntity(Item(rPosX, rPosY, zPosZ, ItemDatabase.itemList[1]));
    }
  }

  void cutTree() {}
}
