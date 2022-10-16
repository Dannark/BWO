import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../game_controller.dart';
import 'on_animation_end.dart';

class SpriteController {
  int direcion = -3;
  bool _spritesLoaded = false;
  String folder;

  SpriteBatch _forward;
  SpriteBatch _backward;
  SpriteBatch _left;
  SpriteBatch _right;
  SpriteBatch _forwardLeft;
  SpriteBatch _forwardRight;
  SpriteBatch _backwardLeft;
  SpriteBatch _backwardRight;

  final Rect _viewPort;
  final Offset _pivot;
  final double _scale;
  final Offset _gradeSize;
  int framesCount;

  SpriteBatch _currentFrame;

  int _currentFrameId = 0;
  double _timeInFuture = 0;

  OnAnimationEnd onAnimEndCallback;

  SpriteController(this.folder, this._viewPort, this._pivot, this._scale,
      this._gradeSize, this.framesCount, this.onAnimEndCallback) {
    loadSprites(folder);
    if (framesCount == 0) {
      framesCount = (_gradeSize.dx * _gradeSize.dy).toInt();
    }
  }

  void loadSprites(String folder) async {
    _forward = await SpriteBatch.load('$folder/forward.png');
    _backward = await SpriteBatch.load('$folder/backward.png');
    _left = await SpriteBatch.load('$folder/left.png');
    _right = await SpriteBatch.load('$folder/right.png');
    _forwardLeft = await SpriteBatch.load('$folder/forward_left.png');
    _forwardRight = await SpriteBatch.load('$folder/forward_right.png');
    _backwardLeft = await SpriteBatch.load('$folder/backward_left.png');
    _backwardRight = await SpriteBatch.load('$folder/backward_right.png');
    _spritesLoaded = true;
  }

  void draw(Canvas c, double moveX, double moveY, double xSpeed, double ySpeed,
      double delay, int height,
      {bool stopAnimWhenIdle}) {
    if (_spritesLoaded == false) {
      return;
    }

    if (stopAnimWhenIdle) {
      if (delay < .17) {
        var walkAngle = 180 * Offset(xSpeed, ySpeed).direction / pi;
        direcion = walkAngle ~/ 22.5;
      } else {
        delay = 0;
      }
    } else {}

    if (GameController.time > _timeInFuture) {
      _timeInFuture = GameController.time + delay;

      _currentFrameId++;

      if (_currentFrameId >= framesCount) {
        _currentFrameId = 0;
        if (onAnimEndCallback != null) {
          onAnimEndCallback.onAnimationEnd();
        }
      }
    }

    if (delay == 0) {
      _currentFrameId = 0;
    }

    if (direcion >= -1 && direcion <= 0) {
      updateFrame(_left, Vector2(moveX, moveY), height);
    } else if (direcion == -7 || direcion == -8 || direcion == 7) {
      updateFrame(_right, Vector2(moveX, moveY), height);
    } else if (direcion >= 3 && direcion <= 4) {
      updateFrame(_backward, Vector2(moveX, moveY), height);
    } else if (direcion >= 5 && direcion <= 6) {
      updateFrame(_backwardRight, Vector2(moveX, moveY), height);
    } else if (direcion >= 1 && direcion <= 2) {
      updateFrame(_backwardLeft, Vector2(moveX, moveY), height);
    } else if (direcion >= -4 && direcion <= -3) {
      updateFrame(_forward, Vector2(moveX, moveY), height);
    } else if (direcion == -2) {
      updateFrame(_forwardLeft, Vector2(moveX, moveY), height);
    } else if (direcion >= -6 && direcion <= -5) {
      updateFrame(_forwardRight, Vector2(moveX, moveY), height);
    } else {
      updateFrame(_right, Vector2(moveX, moveY), height);
    }

    _currentFrame.render(c);
  }

  void updateFrame(SpriteBatch newFrame, Vector2 newPosition, int height) {
    var maxImageWidth = _gradeSize.dx * _viewPort.width;
    //_currentFrameId = 4;
    var x = (_currentFrameId % _gradeSize.dx) * _viewPort.width;
    var y =
        ((_currentFrameId * _viewPort.width) / maxImageWidth).floorToDouble() *
            _viewPort.height;

    var sink = ((105 - height) * 0.15).clamp(0, 5);
    var offsetToPlayerFeet = 0;
    var frame = Rect.fromLTWH(
      x,
      y,
      _viewPort.width,
      _viewPort.height - sink - offsetToPlayerFeet,
    );

    _currentFrame = newFrame;
    _currentFrame.clear();
    _currentFrame.add(
      source: frame,
      offset: newPosition, //Offset(moveX, moveY),
      anchor: Vector2(_pivot.dx, _pivot.dy - sink),
      scale: _scale,
    );
  }

  void setDirection(Offset targetPos, Offset playerPos) {
    var myDirection = (playerPos - targetPos).direction;
    var walkAngle = 180 * myDirection / pi;
    direcion = walkAngle ~/ 22.5;
  }
}
