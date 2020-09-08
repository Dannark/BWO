import 'package:flutter/material.dart';

import '../../../game_controller.dart';
import '../../../map/map_controller.dart';
import '../../../ui/hud.dart';
import '../../../utils/tap_state.dart';
import '../build_subtools_bar.dart';
import '../tool_item.dart';

class BuildToolsWall extends BuildSubToolsBar {
  final MapController _map;

  int selectedWall = -1;

  BuildToolsWall(this._map, HUD hudRef) {
    buttonList = [
      ToolItem("wall1", "Wall 1", hudRef, onWallPress),
      ToolItem("wall2", "Wall 2", hudRef, onWallPress),
      ToolItem("wall3", "Wall 3", hudRef, onWallPress),
      ToolItem("wall4", "Wall 4", hudRef, onWallPress),
      ToolItem("wall5", "Wall 5", hudRef, onWallPress),
      ToolItem("wall6", "Wall 6", hudRef, onWallPress),
      ToolItem("wall7", "Wall 7", hudRef, onWallPress),
      ToolItem("wall8", "Wall 8", hudRef, onWallPress),
      ToolItem("wall9", "Wall 9", hudRef, onWallPress),
      ToolItem("wall10", "Wall 10", hudRef, onWallPress),
      ToolItem("wall11", "Wall 11", hudRef, onWallPress),
      ToolItem("wall12", "Wall 12", hudRef, onWallPress),
      ToolItem("wall13", "Wall 13", hudRef, onWallPress),
      ToolItem("wall14", "Wall 14", hudRef, onWallPress),
    ];
  }

  @override
  void draw(Canvas c) {
    super.draw(c);

    if (GameController.tapState == TapState.pressing) {
      var tapOnScreen = TapState.currentPosition;

      var verticalBarButtons =
          Rect.fromLTWH(0, GameController.screenSize.height - 235, 48, 235);

      if (tapOnScreen.dy < GameController.screenSize.height - 200 &&
          TapState.currentClickingAtInside(verticalBarButtons) == false) {
        placeWall();
      }
    }
  }

  void delete() {
    _map.buildFoundation.deleteWall();
  }

  void onWallPress(dynamic bt) {
    selectButtonHighlight(bt);

    String idName = bt.spriteName;
    var id = int.parse(idName.replaceAll("wall", ""));
    selectedWall = id;
  }

  void placeWall() {
    if (selectedWall != -1) _map.buildFoundation.placeWall(selectedWall);
  }
}
