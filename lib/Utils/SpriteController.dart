import 'dart:math';

import 'package:BWO/game_controller.dart';
import 'package:flame/sprite_batch.dart';
import 'package:flutter/material.dart';

class SpriteController {
  int _dir = -3;

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
      double delay, bool playAnim, int height) {
    if (playAnim) {
      var walkAngle = 180 * Offset(xSpeed, ySpeed).direction / pi;
      
      _dir = walkAngle ~/ 22.5;
      
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
      updateFrame(_left, Offset(moveX, moveY), height);
    } else if (_dir == -7 || _dir == 7) {
      updateFrame(_right, Offset(moveX, moveY), height);
    } else if (_dir >= 3 && _dir <= 4) {
      updateFrame(_backward, Offset(moveX, moveY), height);
    } else if (_dir >= 5 && _dir <= 6) {
      updateFrame(_backward_right, Offset(moveX, moveY), height);
    } else if (_dir >= 1 && _dir <= 2) {
      updateFrame(_backward_left, Offset(moveX, moveY), height);
    } else if (_dir >= -4 && _dir <= -3) {
      updateFrame(_forward, Offset(moveX, moveY), height);
    }else if (_dir == -2) {
      updateFrame(_forward_left, Offset(moveX, moveY), height);
    }else if (_dir >= -6 && _dir <= -5) {
      updateFrame(_forward_right, Offset(moveX, moveY), height);
    }

    _currentFrame.render(c);
  }

  void updateFrame(SpriteBatch newFrame, Offset newPosition, int height) {
    var maxImageHeight = _gradeSize.dy * _viewPort.height;
    
    var x = (_currentFrameId % _gradeSize.dx) * _viewPort.width;
    var y = ((_currentFrameId * _viewPort.height) / maxImageHeight)
            .floorToDouble() *
        _viewPort.height;

    var sink = ((105-height)*0.15).clamp(0, 4);
    var offsetToPlayerFeet = 2;
    Rect frame = Rect.fromLTWH(
      x,
      y,
      _viewPort.width,
      _viewPort.height - sink - offsetToPlayerFeet,
    );

    //print( ((_viewPort.width * _currentFrameId) % _frameSize.dx + 1) );

    _currentFrame = newFrame;
    _currentFrame.clear();
    _currentFrame.add(
      rect: frame,
      offset: newPosition, //Offset(moveX, moveY),
      anchor: Offset(_pivot.dx, _pivot.dy - sink),
      scale: _scale,
    );
  }

  void setDirection(Offset targetPos, Offset playerPos){
    var direction = (playerPos - targetPos).direction;
    var walkAngle = 180 * direction / pi;
    _dir = walkAngle ~/ 22.5;
  }
}
