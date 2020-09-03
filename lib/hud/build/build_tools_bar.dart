import 'dart:ui';

import 'package:flutter/material.dart';

import '../../entity/player/player.dart';
import '../../game_controller.dart';
import '../../map/map_controller.dart';
import '../../ui/hud.dart';
import '../../ui/ui_element.dart';
import 'build_subtools_bar.dart';
import 'tool_item.dart';
import 'tools/build_tools_floors.dart';
import 'tools/build_tools_foundation.dart';
import 'tools/build_tools_options.dart';
import 'tools/build_tools_walls.dart';

class BuildToolsBar extends UIElement {
  final Paint _p = Paint();
  final Player _player;
  final MapController _map;

  double _boxHeight = -72;
  double _heightTarget = -72;

  bool _isActive = false;

  List<ToolItem> buttonList = [];

  BuildSubToolsBar _subtoolsSelected;

  BuildToolsBar(this._player, this._map, HUD hudRef) : super(hudRef) {
    drawOnHUD = true;

    buttonList.add(
        ToolItem("foundation", "Foundation", hudRef, onFoundationBtPressed));
    buttonList.add(ToolItem("wall", "Wall", hudRef, onWallButtonPressed));
    buttonList.add(ToolItem("floor_icon", "Floor", hudRef, onTileFloorPressed));
    buttonList
        .add(ToolItem("furniture", "Furniture", hudRef, onFurniturePressed));
    buttonList.add(ToolItem("config", "Config", hudRef, onConfigPressed));
  }

  void draw(Canvas c) {
    _subtoolsSelected?.draw(c);

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
      _heightTarget = 72;
      _boxHeight = -15;
    } else {
      _heightTarget = -15;
      _boxHeight = 72;
      _subtoolsSelected?.setActive(false);
      _subtoolsSelected = null;

      for (var button in buttonList) {
        button.isSelected = false;
      }
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
    _selectButtonHightlight(bt);
    _subtoolsSelected = BuildToolsFoundation(_player, _map, hudRef);
  }

  void onWallButtonPressed(ToolItem bt) {
    _selectButtonHightlight(bt);
    _subtoolsSelected = BuildToolsWall(_map, hudRef);
  }

  void onTileFloorPressed(ToolItem bt) {
    _selectButtonHightlight(bt);
    _subtoolsSelected = BuildToolsFloors(_map, hudRef);
  }

  void onFurniturePressed(ToolItem bt) {
    _selectButtonHightlight(bt);
    _subtoolsSelected = null;
  }

  void onConfigPressed(ToolItem bt) {
    _selectButtonHightlight(bt);
    _subtoolsSelected = BuildToolsOptions(_map, hudRef);
  }

  void _selectButtonHightlight(ToolItem bt) {
    for (var button in buttonList) {
      button.isSelected = button == bt;
    }
  }
}
