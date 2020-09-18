import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../game_controller.dart';
import '../map/map_controller.dart';
import '../ui/keyboard/keyboard_ui.dart';
import '../ui/ui_element.dart';

// ignore: avoid_classes_with_only_static_members
class TapState {
  static const int up = 0;
  static const int down = 1;
  static const int pressing = 2;
  static const int cancel = 3;

  static Offset pressedPosition = Offset(0, 0);
  static Offset lastPosition = Offset(0, 0);
  static Offset currentPosition = Offset(0, 0);
  //static Offset localPosition = Offset(0, 0);

  static bool isTapingLeft() {
    return GameController.tapState == pressing &&
        pressedPosition.dx < GameController.screenSize.width / 2;
  }

  static bool isTapingRight() {
    return GameController.tapState == pressing &&
        pressedPosition.dx > GameController.screenSize.width / 2;
  }

  static bool isTapingBottom() {
    return GameController.tapState == pressing &&
        pressedPosition.dy > GameController.screenSize.height / 2;
  }

  static bool instersect(Rect r) {
    var r1 = Rectangle(r.left, r.top, r.width, r.height);
    var r2 = Rectangle(pressedPosition.dx, pressedPosition.dy, 1, 1);
    return r1.intersects(r2);
  }

  static bool clickedAt(Rect r) {
    return (instersect(r) && GameController.tapState == down);
  }

  static bool clickedAtButton(UIElement button) {
    var isAboveAllElements = true;

    var indexButton = 0;
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
        GameController.tapState == down &&
        isAboveAllElements &&
        !KeyboardUI.isEnable);
  }

  static bool currentClickingAt(Rect r) {
    return (instersect(r) && GameController.tapState == pressing);
  }

  static bool currentClickingAtInside(Rect r) {
    var r1 = Rectangle(r.left, r.top, r.width, r.height);
    var r2 = Rectangle(currentPosition.dx, currentPosition.dy, 1, 1);
    return (r1.intersects(r2) && GameController.tapState == pressing);
  }

  static Offset deltaPositionFromStart({double limit = double.infinity}) {
    var offset = pressedPosition - currentPosition;
    return Offset(
        offset.dx.clamp(-limit, limit), offset.dy.clamp(-limit, limit));
  }

  static Offset deltaPosition() {
    lastPosition = Offset.lerp(
        lastPosition, currentPosition, GameController.deltaTime * 4);
    return lastPosition - currentPosition;
  }

  static Offset screenToWorldPoint(Offset point, MapController map) {
    var midBorder = (map.border) * 16;
    var mapPos = Offset(map.posX - midBorder, map.posY - midBorder);

    var tap = (point - mapPos);
    return tap;
  }

  static Offset worldToScreenPoint(MapController map) {
    var midBorder = (map.border) * 16;
    var tap = Offset(map.posX - midBorder, map.posY - midBorder);

    return tap;
  }
}
