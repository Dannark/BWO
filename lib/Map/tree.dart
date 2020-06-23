import 'dart:math';
import 'dart:ui';
import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Map/tile.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/sprite.dart';
import 'package:flame/sprite_batch.dart';
import 'package:flutter/material.dart';

class Tree extends Entity {
  int _tileSize;
  SpriteBatch _tree;
  String _spriteImage;
  double delay = 0.05;
  bool _playAnimation = false;

  int _currentRotationId = 0;
  List<double> rotationList = [0, -0.05, 0.04, -0.02, 0.01, 0];
  double _timeInFuture = 0;

  Tree(int posX, int posY, this._tileSize, this._spriteImage)
      : super((posX.toDouble() * GameController.worldSize),
            (posY.toDouble() * GameController.worldSize)) {
    width = 2.0 * _tileSize;
    height = 2.0 * _tileSize;
    updatePhysics();
    loadSprite();
  }
  void loadSprite() async {
    _tree = await SpriteBatch.withAsset('trees/${_spriteImage}.png');
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
      if (GameController.time > _timeInFuture && _playAnimation) {
        _timeInFuture = GameController.time + delay;

        _currentRotationId++;

        if (_currentRotationId >= rotationList.length) {
          _currentRotationId = 0;
          _playAnimation = false;
        }
      }

      if (delay <= 0.01) {
        _currentRotationId = 0;
      }

      _updateFrame();
      _tree.render(c);
    }
    debugDraw(c);
  }

  void _updateFrame() {
    _tree.clear();
    _tree.add(
        rect: Rect.fromLTWH(0, 0, 16, 16),
        offset: Offset(
            posX.toDouble() * _tileSize, (posY.toDouble() - 1) * _tileSize),
        anchor: Offset(8, 14),
        scale: _tileSize.toDouble(),
        rotation: rotationList[_currentRotationId] //-0.05
        );
  }

  void playAnimation() {
    _playAnimation = true;
  }
}
