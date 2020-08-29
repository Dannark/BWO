import 'dart:ui';

import 'package:flutter/material.dart';

import '../../game_controller.dart';
import '../../ui/hud.dart';
import '../../ui/ui_element.dart';
import 'tool_item.dart';

class BuildToolsBar extends UIElement {
  final Paint _p = Paint();

  double _boxHeight = -64;
  double _heightTarget = -64;

  bool _isActive = false;

  List<ToolItem> buttonList = [];

  BuildToolsBar(HUD hudRef) : super(hudRef) {
    drawOnHUD = true;

    buttonList.add(ToolItem(
        "foundation", Offset(-32, -32), hudRef, onFoundationBtPressed,
        isBtSelected: true));
    buttonList
        .add(ToolItem("wall", Offset(-32, -32), hudRef, onWallButtonPressed));
    buttonList.add(
        ToolItem("floor_icon", Offset(-32, -32), hudRef, onTileFloorPressed));
    buttonList.add(
        ToolItem("furniture", Offset(-32, -32), hudRef, onFurniturePressed));
  }

  void draw(Canvas c) {
    _p.color = Color.fromRGBO(244, 223, 168, 1);
    bounds = Rect.fromLTRB(
      45,
      GameController.screenSize.height - _boxHeight,
      GameController.screenSize.width - 45,
      GameController.screenSize.height + 15,
    );
    var rBounds = RRect.fromLTRBR(bounds.left, bounds.top, bounds.right,
        bounds.bottom, Radius.circular(15));

    openCloseAnimation();

    if (rBounds.top <= GameController.screenSize.height) {
      c.drawRRect(rBounds, _p);
      drawButtonsOnPosition(c);
    }
  }

  void openCloseAnimation() {
    _boxHeight =
        lerpDouble(_boxHeight, _heightTarget, GameController.deltaTime * 5);
  }

  // ignore: avoid_positional_boolean_parameters
  void setActive(bool isActive) {
    _isActive = isActive;

    if (_isActive) {
      _heightTarget = 64;
    } else {
      _heightTarget = -15;
    }
  }

  void drawButtonsOnPosition(Canvas c) {
    for (var i = 0; i < buttonList.length; i++) {
      var spaceBetween = (bounds.width / buttonList.length);
      buttonList[i].pos = Offset(
        bounds.left + (spaceBetween * i) + spaceBetween / 2,
        bounds.top + 30,
      );
      buttonList[i].draw(c);
    }
  }

  void onFoundationBtPressed(ToolItem bt) {
    bt.isSelected = true;

    for (var button in buttonList) {
      button.isSelected = button == bt;
    }
  }

  void onWallButtonPressed(ToolItem bt) {
    for (var button in buttonList) {
      button.isSelected = button == bt;
    }
  }

  void onTileFloorPressed(ToolItem bt) {
    for (var button in buttonList) {
      button.isSelected = button == bt;
    }
  }

  void onFurniturePressed(ToolItem bt) {
    for (var button in buttonList) {
      button.isSelected = button == bt;
    }
  }
}
