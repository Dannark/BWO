import 'dart:math';

import 'package:BWO/ui/HUD.dart';
import 'package:BWO/ui/Keyboard/KeyboardUI.dart';
import 'package:BWO/ui/UIElement.dart';
import 'package:flutter/material.dart';

import '../game_controller.dart';

class TapState {
  static const int UP = 0;
  static const int DOWN = 1;
  static const int PRESSING = 2;
  static const int CANCEL = 3;

  static Offset pressedPosition = Offset(0, 0);
  static Offset lastPosition = Offset(0, 0);
  static Offset currentPosition = Offset(0, 0);
  //static Offset localPosition = Offset(0, 0);

  static bool isTapingLeft() {
    return GameController.tapState == PRESSING &&
        pressedPosition.dx < GameController.screenSize.width / 2;
  }

  static bool isTapingRight() {
    return GameController.tapState == PRESSING &&
        pressedPosition.dx > GameController.screenSize.width / 2;
  }

  static bool instersect(Rect r) {
    Rectangle r1 = Rectangle(r.left, r.top, r.width, r.height);
    Rectangle r2 = Rectangle(pressedPosition.dx, pressedPosition.dy, 1, 1);
    return r1.intersects(r2);
  }

  static bool clickedAt(Rect r) {
    return (instersect(r) && GameController.tapState == DOWN);
  }

  static bool clickedAtButton(UIElement button) {
    bool isAboveAllElements = true;

    int indexButton = 0;
    for (var i = 0; i < button.hudRef.uiElelements.length; i++) {
      var otherUI = button.hudRef.uiElelements[i];
      if (otherUI == button) {
        indexButton = i;
      }
    }

    for (var i = 0; i < button.hudRef.uiElelements.length; i++) {
      var otherUI = button.hudRef.uiElelements[i];

      if (instersect(otherUI.bounds) && otherUI != button) {
        if (i > indexButton) {
          isAboveAllElements = false;
          break;
        }
      }
    }
    return (instersect(button.bounds) &&
        GameController.tapState == DOWN &&
        isAboveAllElements &&
        !KeyboardUI.isEnable);
  }

  static bool currentClickingAt(Rect r) {
    return (instersect(r) && GameController.tapState == PRESSING);
  }

  static bool currentClickingAtInside(Rect r) {
    Rectangle r1 = Rectangle(r.left, r.top, r.width, r.height);
    Rectangle r2 = Rectangle(currentPosition.dx, currentPosition.dy, 1, 1);
    return (r1.intersects(r2) && GameController.tapState == PRESSING);
  }

  static Offset deltaPositionFromStart({double limit = double.infinity}) {
    Offset offset = pressedPosition - currentPosition;
    return Offset(
        offset.dx.clamp(-limit, limit), offset.dy.clamp(-limit, limit));
  }

  static Offset deltaPosition() {
    return lastPosition - currentPosition;
  }
}
