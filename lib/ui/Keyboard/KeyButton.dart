import 'dart:ui';

import 'package:BWO/Utils/TapState.dart';
import 'package:BWO/game_controller.dart';
import 'package:BWO/ui/Keyboard/KeyModel.dart';
import 'package:BWO/ui/Keyboard/KeyboardUI.dart';
import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';

class KeyButton {
  KeyboardUI _keyboard;
  Rect bounds;

  Position pos;
  double width;
  double height;

  double padding = 1;

  Paint p = Paint();

  String keyText;

  TextConfig valueText;
  double widthMultiplier = 1;

  Offset animatePos = Offset(0, 0);
  double animationZoom = 0;
  double animSpeed = 8;

  KeyButton(this._keyboard, Position gridPos, KeyModel keyVal) {
    p.color = _keyboard.keyBGColor;

    keyText = keyVal.value;
    p.color = keyVal.color != null ? keyVal.color : p.color;
    Color txtColor =
        keyVal.txtColor != null ? keyVal.txtColor : _keyboard.keyTxtColor;
    widthMultiplier = keyVal.widthOnGrid;

    double viewWidth = (GameController.screenSize.width - _keyboard.paddingX);
    double defaultWidth = viewWidth * 0.1;

    width = viewWidth * (0.1 * widthMultiplier);
    height = _keyboard.keyHeight;

    pos = Position(
      (gridPos.x * defaultWidth +
          _keyboard.bounds.left +
          _keyboard.paddingX / 2),
      gridPos.y * height + _keyboard.bounds.top + _keyboard.paddingY / 2,
    );

    valueText =
        TextConfig(fontSize: 16.0, color: txtColor, fontFamily: "Blocktopia");

    initializeAnimation(AnimationType.roll3dCenter);
  }

  void draw(Canvas c) {
    fadeAnimation();

    bounds = Rect.fromLTWH(
      pos.x + padding + animatePos.dx,
      pos.y + padding + animatePos.dy,
      width - padding * 2,
      height - padding * 2,
    ).inflate(animationZoom);

    c.drawRRect(RRect.fromRectAndRadius(bounds, Radius.circular(5)), p);

    Position textPosition = Position(pos.x + width / 2, pos.y + height / 2);
    textPosition += Position(animatePos.dx, animatePos.dy);

    valueText.render(c, keyText, textPosition, anchor: Anchor.center);

    detectClick();
  }

  fadeAnimation() {
    animatePos = Offset.lerp(
      animatePos,
      Offset.zero,
      GameController.deltaTime * animSpeed,
    );
    animationZoom = lerpDouble(
      animationZoom,
      0,
      GameController.deltaTime * animSpeed,
    );
  }

  void detectClick() {
    if (TapState.clickedAt(bounds)) {
      animationZoom = 5 * 100 * 0.01;
      _keyboard.onPressed(keyText);
    }
  }

  void initializeAnimation(AnimationType animType) {
    if (animType == AnimationType.roll3dCenter) {
      Offset difference = (_keyboard.bounds.center -
          Offset(pos.x + width / 2, pos.y + height / 2));
      animatePos = Offset(difference.direction * -difference.distance,
          difference.direction * difference.distance);
    } else if (animType == AnimationType.roll3dCenter2) {
      Offset difference = (_keyboard.bounds.center -
          Offset(pos.x + width / 2, pos.y + height / 2));
      animatePos = Offset(difference.direction * difference.distance,
          difference.direction * -difference.distance);
    } else if (animType == AnimationType.roll3dBottomCenter) {
      Offset difference =
          (_keyboard.bounds.bottomCenter - Offset(pos.x, pos.y));
      animatePos = Offset(difference.direction * difference.distance,
          difference.direction * difference.distance);
    } else if (animType == AnimationType.zoomIn) {
      double distanceX = (_keyboard.bounds.center.dx - pos.x);
      double distanceY = (_keyboard.bounds.center.dy - pos.y);
      animatePos = Offset(distanceX, distanceY);
    } else if (animType == AnimationType.explosion) {
      Offset diff = (TapState.pressedPosition -
          Offset(pos.x + width / 2, pos.y + height / 2));

      double x = (diff.dx * GameController.screenSize.width / diff.distance);
      var y = (diff.dy * GameController.screenSize.height / diff.distance);

      animatePos = Offset(x * -0.01, y * -0.01);
    }
  }
}

enum AnimationType {
  none,
  roll3dCenter,
  roll3dCenter2,
  roll3dBottomCenter,
  zoomIn,
  explosion
}
