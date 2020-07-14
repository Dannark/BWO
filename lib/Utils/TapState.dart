import 'dart:math';

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
