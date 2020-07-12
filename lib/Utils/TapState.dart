import 'dart:math';

import 'package:flutter/material.dart';

import '../game_controller.dart';

class TapState {
  static const int UP = 0;
  static const int DOWN = 1;
  static const int PRESSING = 2;
  static const int CANCEL = 3;

  static Offset localPosition = Offset(0, 0);

  static bool isTapingLeft() {
    return GameController.tapState == PRESSING &&
        localPosition.dx < GameController.screenSize.width / 2;
  }

  static bool isTapingRight() {
    return GameController.tapState == PRESSING &&
        localPosition.dx > GameController.screenSize.width / 2;
  }

  static bool instersect(Rect r) {
    Rectangle r1 = Rectangle(r.left, r.top, r.width, r.height);
    Rectangle r2 = Rectangle(localPosition.dx, localPosition.dy, 1, 1);
    return r1.intersects(r2);
  }

  static bool clickedAt(Rect r) {
    return (instersect(r) && GameController.tapState == DOWN);
  }
}
