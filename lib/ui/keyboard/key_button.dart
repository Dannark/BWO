import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';

import '../../game_controller.dart';
import '../../utils/tap_state.dart';
import 'key_model.dart';
import 'keyboard_ui.dart';

class KeyButton {
  Rect bounds;

  Position pos;
  double width;
  double height;

  final Position _gridPos;

  double padding = 1;

  Paint p = Paint();

  String keyText;

  TextConfig valueText;
  double widthMultiplier = 1;

  Offset animatePos = Offset(0, 0);
  double animationZoom = 0;
  double animSpeed = 8;

  KeyButton(this._gridPos, KeyModel keyVal) {
    p.color = KeyboardUI.keyBGColor;

    keyText = keyVal.value;
    p.color = keyVal.color != null ? keyVal.color : p.color;
    var txtColor =
        keyVal.txtColor != null ? keyVal.txtColor : KeyboardUI.keyTxtColor;
    widthMultiplier = keyVal.widthOnGrid;

    var viewWidth = (GameController.screenSize.width - KeyboardUI.paddingX);
    var defaultWidth = viewWidth * 0.1;

    width = viewWidth * (0.1 * widthMultiplier);
    height = KeyboardUI.keyHeight;

    pos = Position(
      (_gridPos.x * defaultWidth +
          KeyboardUI.bounds.left +
          KeyboardUI.paddingX / 2),
      _gridPos.y * height + KeyboardUI.bounds.top + KeyboardUI.paddingY / 2,
    );

    valueText =
        TextConfig(fontSize: 16.0, color: txtColor, fontFamily: "Blocktopia");

    initializeAnimation(AnimationType.roll3dCenter);
  }

  void draw(Canvas c) {
    pos = Position(
      pos.x,
      _gridPos.y * height + KeyboardUI.bounds.top + KeyboardUI.paddingY / 2,
    );
    fadeAnimation();

    bounds = Rect.fromLTWH(
      pos.x + padding + animatePos.dx,
      pos.y + padding + animatePos.dy,
      width - padding * 2,
      height - padding * 2,
    ).inflate(animationZoom);

    c.drawRRect(RRect.fromRectAndRadius(bounds, Radius.circular(5)), p);

    var textPosition = Position(pos.x + width / 2, pos.y + height / 2);
    textPosition += Position(animatePos.dx, animatePos.dy);

    valueText.render(c, keyText, textPosition, anchor: Anchor.center);

    detectClick();
  }

  void fadeAnimation() {
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
      KeyboardUI.onPressed(keyText);
    }
  }

  void initializeAnimation(AnimationType animType) {
    if (animType == AnimationType.roll3dCenter) {
      var difference = (KeyboardUI.bounds.center -
          Offset(pos.x + width / 2, pos.y + height / 2));
      animatePos = Offset(difference.direction * -difference.distance,
          difference.direction * difference.distance);
    } else if (animType == AnimationType.roll3dCenter2) {
      var difference = (KeyboardUI.bounds.center -
          Offset(pos.x + width / 2, pos.y + height / 2));
      animatePos = Offset(difference.direction * difference.distance,
          difference.direction * -difference.distance);
    } else if (animType == AnimationType.roll3dBottomCenter) {
      var difference = (KeyboardUI.bounds.bottomCenter - Offset(pos.x, pos.y));
      animatePos = Offset(difference.direction * difference.distance,
          difference.direction * difference.distance);
    } else if (animType == AnimationType.zoomIn) {
      var distanceX = (KeyboardUI.bounds.center.dx - pos.x);
      var distanceY = (KeyboardUI.bounds.center.dy - pos.y);
      animatePos = Offset(distanceX, distanceY);
    } else if (animType == AnimationType.explosion) {
      var diff = (TapState.pressedPosition -
          Offset(pos.x + width / 2, pos.y + height / 2));

      var x = (diff.dx * GameController.screenSize.width / diff.distance);
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
