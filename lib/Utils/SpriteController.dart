import 'dart:math';

import 'package:BWO/game_controller.dart';
import 'package:flame/sprite_batch.dart';
import 'package:flutter/material.dart';

class SpriteController {
  int _dir = 0;

  SpriteBatch _forward;
  SpriteBatch _backward;
  SpriteBatch _left;
  SpriteBatch _right;
  SpriteBatch _forward_left;
  SpriteBatch _forward_right;
  SpriteBatch _backward_left;
  SpriteBatch _backward_right;

  Rect _viewPort;
  Offset _pivot;
  double _scale;
  Offset _gradeSize;
  int framesCount;

  SpriteBatch _currentFrame;

  int _currentFrameId = 0;
  double _timeInFuture = 0;

  SpriteController(
      this._forward,
      this._backward,
      this._left,
      this._right,
      this._forward_left,
      this._forward_right,
      this._backward_left,
      this._backward_right,
      this._viewPort,
      this._pivot,
      this._scale,
      this._gradeSize,
      this.framesCount) {
    if (framesCount == 0) {
      framesCount = (_gradeSize.dx * _gradeSize.dy).toInt();
    }
  }

  void draw(Canvas c, double moveX, double moveY, double xSpeed, double ySpeed,
      double delay, bool playAnim) {
    if (playAnim) {
      var walkAngle = 180 * Offset(xSpeed, ySpeed).direction / pi;
      
      _dir = (walkAngle / 22.5).toInt();
      
    } else {
      delay = 0;
    }

    if (GameController.time > _timeInFuture) {
      _timeInFuture = GameController.time + delay;

      _currentFrameId++;

      if (_currentFrameId >= framesCount) {
        _currentFrameId = 0;
      }
    }

    if (delay <= 0.01) {
      _currentFrameId = 0;
    }

    if (_dir >= -1 && _dir <= 0) {
      updateFrame(_left, Offset(moveX, moveY));
    } else if (_dir == -7 || _dir == 7) {
      updateFrame(_right, Offset(moveX, moveY));
    } else if (_dir >= 3 && _dir <= 4) {
      updateFrame(_backward, Offset(moveX, moveY));
    } else if (_dir >= 5 && _dir <= 6) {
      updateFrame(_backward_right, Offset(moveX, moveY));
    } else if (_dir >= 1 && _dir <= 2) {
      updateFrame(_backward_left, Offset(moveX, moveY));
    } else if (_dir >= -4 && _dir <= -3) {
      updateFrame(_forward, Offset(moveX, moveY));
    }else if (_dir == -2) {
      updateFrame(_forward_left, Offset(moveX, moveY));
    }else if (_dir >= -6 && _dir <= -5) {
      updateFrame(_forward_right, Offset(moveX, moveY));
    }

    _currentFrame.render(c);
  }

  void updateFrame(SpriteBatch newFrame, Offset newPosition) {
    var maxImageHeight = _gradeSize.dy * _viewPort.height;

    var x = (_currentFrameId % _gradeSize.dx) * _viewPort.width;
    var y = ((_currentFrameId * _viewPort.height) / maxImageHeight)
            .floorToDouble() *
        _viewPort.height;

    Rect frame = Rect.fromLTWH(
      x,
      y,
      x + _viewPort.width,
      y + _viewPort.height,
    );

    //print( ((_viewPort.width * _currentFrameId) % _frameSize.dx + 1) );

    _currentFrame = newFrame;
    _currentFrame.clear();
    _currentFrame.add(
      rect: frame,
      offset: newPosition, //Offset(moveX, moveY),
      anchor: _pivot, //Offset(4, 7),
      scale: _scale,
    );
  }
}
