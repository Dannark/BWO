import 'dart:math';

import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Utils/OnAnimationEnd.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/sprite_batch.dart';
import 'package:flutter/material.dart';

class SpriteController {
  int _dir = -3;
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

  Rect _viewPort;
  Offset _pivot;
  double _scale;
  Offset _gradeSize;
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
    _forward = await SpriteBatch.withAsset('${folder}/forward.png');
    _backward = await SpriteBatch.withAsset('${folder}/backward.png');
    _left = await SpriteBatch.withAsset('${folder}/left.png');
    _right = await SpriteBatch.withAsset('${folder}/right.png');
    _forwardLeft = await SpriteBatch.withAsset('${folder}/forward_left.png');
    _forwardRight = await SpriteBatch.withAsset('${folder}/forward_right.png');
    _backwardLeft = await SpriteBatch.withAsset('${folder}/backward_left.png');
    _backwardRight =
        await SpriteBatch.withAsset('${folder}/backward_right.png');
    _spritesLoaded = true;
  }

  void draw(Canvas c, double moveX, double moveY, double xSpeed, double ySpeed,
      double delay, bool stopAnimWhenIdle, int height) {
    if (_spritesLoaded == false) {
      return;
    }

    if (stopAnimWhenIdle) {
      if (delay < .17) {
        var walkAngle = 180 * Offset(xSpeed, ySpeed).direction / pi;
        _dir = walkAngle ~/ 22.5;
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

    if (_dir >= -1 && _dir <= 0) {
      updateFrame(_left, Offset(moveX, moveY), height);
    } else if (_dir == -7 || _dir == -8 || _dir == 7) {
      updateFrame(_right, Offset(moveX, moveY), height);
    } else if (_dir >= 3 && _dir <= 4) {
      updateFrame(_backward, Offset(moveX, moveY), height);
    } else if (_dir >= 5 && _dir <= 6) {
      updateFrame(_backwardRight, Offset(moveX, moveY), height);
    } else if (_dir >= 1 && _dir <= 2) {
      updateFrame(_backwardLeft, Offset(moveX, moveY), height);
    } else if (_dir >= -4 && _dir <= -3) {
      updateFrame(_forward, Offset(moveX, moveY), height);
    } else if (_dir == -2) {
      updateFrame(_forwardLeft, Offset(moveX, moveY), height);
    } else if (_dir >= -6 && _dir <= -5) {
      updateFrame(_forwardRight, Offset(moveX, moveY), height);
    } else {
      updateFrame(_right, Offset(moveX, moveY), height);
    }

    _currentFrame.render(c);
  }

  void updateFrame(SpriteBatch newFrame, Offset newPosition, int height) {
    var maxImageWidth = _gradeSize.dx * _viewPort.width;
    //_currentFrameId = 4;
    var x = (_currentFrameId % _gradeSize.dx) * _viewPort.width;
    var y =
        ((_currentFrameId * _viewPort.width) / maxImageWidth).floorToDouble() *
            _viewPort.height;

    var sink = ((105 - height) * 0.15).clamp(0, 5);
    var offsetToPlayerFeet = 0;
    Rect frame = Rect.fromLTWH(
      x,
      y,
      _viewPort.width,
      _viewPort.height - sink - offsetToPlayerFeet,
    );

    _currentFrame = newFrame;
    _currentFrame.clear();
    _currentFrame.add(
      rect: frame,
      offset: newPosition, //Offset(moveX, moveY),
      anchor: Offset(_pivot.dx, _pivot.dy - sink),
      scale: _scale,
    );
  }

  void setDirection(Offset targetPos, Offset playerPos) {
    var direction = (playerPos - targetPos).direction;
    var walkAngle = 180 * direction / pi;
    _dir = walkAngle ~/ 22.5;
  }

  void setDirectionAngle(int dir) {
    _dir = dir;
  }

  int getDirectionAngle() {
    return _dir;
  }
}
