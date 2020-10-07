import 'dart:math';
import 'dart:ui';

import 'package:flame/flame_audio.dart';
import 'package:flame/sprite_batch.dart';
import 'package:flutter/material.dart';

import '../entity/entity.dart';
import '../entity/items/item_database.dart';
import '../entity/items/items.dart';
import '../game_controller.dart';
import '../utils/preload_assets.dart';
import 'map_controller.dart';

class Tree extends Entity {
  final int _tileSize;
  SpriteBatch _tree;
  final String _spriteImage;
  final double _delay = 0.05;
  bool _isPlaingAnimation = false;

  int _currentRotationId = 0;
  final List<double> _rotationList = [0, 0, -0.05, 0.04, -0.02, 0.01, 0];
  double _timeInFuture = 0;

  int _applesLeft = 1;

  final FlameAudio _audio = FlameAudio();
  double _deadRotation = 0;
  double _gravityRotation = 0;

  final MapController _map;
  double _deleteTime = double.infinity;

  Tree(this._map, int posX, int posY, this._tileSize, this._spriteImage)
      : super((posX.toDouble() * 16),
            (posY.toDouble() * 16)) {
    id = '_${x.toInt()}_${y.toInt()}';

    width = 2.0 * _tileSize;
    height = 2.0 * _tileSize;
    updatePhysics();
    loadSprite();

    status.setLife(20);

    shadownSize = 4;
    _applesLeft = Random().nextInt(1) + 1;
  }

  void loadSprite() async {
    //_tree = await SpriteBatch.withAsset('trees/${_spriteImage}.png');
    _tree = PreloadAssets.getTreeSprite(_spriteImage);
    if (posX == null || posY == null || _tileSize == null) {
      return;
    }
    _tree.add(
        rect: Rect.fromLTWH(0, 0, _tree.width.toDouble(), _tree.height.toDouble()),  // (0, 0, 16, 16),
        offset: Offset(
            posX.toDouble() * _tileSize*_map.scale, (posY.toDouble() - 1)
                          * _tileSize*_map.scale),
        anchor: Offset(_tree.width/2, _tree.height.toDouble()-2),
        scale: _tileSize.toDouble()*_map.scale*16/_tree.height,
        rotation: 0 //-0.05
        );
  }

  @override
  void draw(Canvas c) {
    if (_map.tilePix == 1) {
      return;
    }
    if (_tree != null) {
      if (status.isAlive()) {
        hitted();
      } else {
        _chopDownTree();
        _checksDeath();
      }
      isActive ? _tree.render(c) : null;
    }

    //isActive ? debugDraw(c) : null;
  }

  void _checksDeath() {
    if (_deleteTime == double.infinity) {
      _deleteTime = GameController.time + 4;
    }
    if (GameController.time > _deleteTime && isActive) {
      _dropLogs();
      disable();
    }
  }

  void disable({int respawnSecTimeout = 190}) {
    isActive = false;
    _gravityRotation = 0;
    _deadRotation = 0;
  }

  void resetTree() {
    isActive = true;
    _gravityRotation = 0;
    _deadRotation = 0;
    status.refillStatus();
    _applesLeft = Random().nextInt(1) + 1;
    _deleteTime = double.infinity;
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
        rect: Rect.fromLTWH(0, 0, _tree.width.toDouble(), _tree.height.toDouble()),
        offset: Offset(
            posX.toDouble() * _tileSize*_map.scale, (posY.toDouble() - 1)
                        * _tileSize*_map.scale),
        anchor: Offset(_tree.width/2, _tree.height.toDouble()-2),
        scale: _tileSize.toDouble()*_map.scale*16/_tree.height,
        rotation: rot //-0.05
        );
  }

  void hitted() {
    if (GameController.time > _timeInFuture && _isPlaingAnimation) {
      _timeInFuture = GameController.time + _delay;

      _currentRotationId++;

      if (_currentRotationId >= _rotationList.length) {
        _currentRotationId = 0;
        _isPlaingAnimation = false;
      }
    }

    if (_delay <= 0.01) {
      _currentRotationId = 0;
    }

    _updateFrame(_rotationList[_currentRotationId]);
  }

  void _playAnimation() {
    _isPlaingAnimation = true;
  }

  void setHealth(int hp) {
    if (isActive && status.isAlive()) {
      _playAnimation();

      var maca = _dropApple();
      if (maca != null) {
        _map.addEntity(maca);
      }

      if (status.isAlive() == false && hp > 0) {
        //is time to revive
        resetTree();
      }

      status.setLife(hp);

      _audio.play('punch.mp3', volume: 0.4);
    }
  }

  Item _dropApple() {
    if (Random().nextInt(100) < 3 && _applesLeft > 0) {
      _applesLeft--;
      return Item(x - 32, y, 100, itemListDatabase[0]);
    }
    return null;
  }

  void _dropLogs() {
    var logAmount = Random().nextInt(3) + 1;

    for (var i = 0; i < logAmount; i++) {
      var rPosX = x + Random().nextInt(130).toDouble() - 30;
      var rPosY = y + Random().nextInt(50).toDouble() - 25;
      var zPosZ = Random().nextInt(30).toDouble() + 10;

      _map.addEntity(Item(rPosX, rPosY, zPosZ, itemListDatabase[1]));
    }
  }
}
