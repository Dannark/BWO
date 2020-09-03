import 'dart:ui';

import 'package:flutter/material.dart';

import '../../game_controller.dart';
import '../../utils/tap_state.dart';
import 'tool_item.dart';

class BuildSubToolsBar {
  final Paint _p = Paint();
  Rect bounds;

  double _boxHeight = -144;
  double _heightTarget = -144;
  Offset _offsetMove = Offset.zero;
  Offset _moveSpeed = Offset.zero;

  List<ToolItem> buttonList = [];

  bool _isActive = false;

  BuildSubToolsBar() {
    setActive(true);
  }

  void draw(Canvas c) {
    _p.color = Color.fromRGBO(220, 210, 150, 1);
    bounds = Rect.fromLTRB(
      55,
      GameController.screenSize.height - _boxHeight,
      GameController.screenSize.width - 55,
      GameController.screenSize.height + 15,
    );
    var rBounds = RRect.fromLTRBR(bounds.left, bounds.top, bounds.right,
        bounds.bottom, Radius.circular(15));

    openCloseAnimation();
    c.drawRRect(rBounds, _p);

    if (rBounds.top <= GameController.screenSize.height) {
      c.drawRRect(rBounds, _p);
      drawButtonsOnPosition(c);
    }

    smoothDragWindows();
  }

  void openCloseAnimation() {
    _boxHeight =
        lerpDouble(_boxHeight, _heightTarget, GameController.deltaTime * 5);
  }

  // ignore: avoid_positional_boolean_parameters
  void setActive(bool isActive) {
    _isActive = isActive;

    if (_isActive) {
      _boxHeight = -15;
      _heightTarget = 144;
    } else {
      _boxHeight = 144;
      _heightTarget = -15;
    }
  }

  void smoothDragWindows() {
    if (TapState.currentClickingAt(bounds)) {
      _moveSpeed = TapState.deltaPosition() * 2.5;
    }
    //desaceleraction Speed
    _moveSpeed =
        Offset.lerp(_moveSpeed, Offset.zero, GameController.deltaTime * 5);
    _offsetMove -= _moveSpeed;

    clampMoviment();
  }

  void clampMoviment() {
    if (GameController.tapState != TapState.pressing) {
      if (_offsetMove.dx > 0) {
        _offsetMove = Offset(
          _offsetMove.dx - GameController.deltaTime * 100,
          _offsetMove.dy,
        );
      }
      var right = buttonList.last.bounds.right;
      if (right + 10 < bounds.right) {
        _offsetMove = Offset(
          _offsetMove.dx + GameController.deltaTime * 100,
          _offsetMove.dy,
        );
      }
    }
  }

  void drawButtonsOnPosition(Canvas c) {
    c.save();
    c.clipRect(bounds);
    for (var i = 0; i < buttonList.length; i++) {
      var spaceBetween = (bounds.width / buttonList.length);
      spaceBetween = spaceBetween.clamp(64.0, double.infinity);

      buttonList[i].pos = Offset(
        bounds.left + _offsetMove.dx + (spaceBetween * i) + spaceBetween / 2,
        bounds.top + 30,
      );
      buttonList[i].draw(c);
    }
    c.restore();
  }

  void selectButtonHighlight(ToolItem bt) {
    for (var button in buttonList) {
      button.isSelected = button == bt;
    }
  }
}
