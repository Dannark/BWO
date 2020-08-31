import 'package:flutter/material.dart';

import '../../../game_controller.dart';
import '../../../map/map_controller.dart';
import '../../../ui/hud.dart';
import '../../../utils/tap_state.dart';
import '../build_subtools_bar.dart';
import '../tool_item.dart';

class BuildToolsWall extends BuildSubToolsBar {
  MapController _map;

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
    ];
  }

  @override
  void draw(Canvas c) {
    super.draw(c);

    if (GameController.tapState == TapState.pressing) {
      var tapOnScreen = TapState.currentPosition;

      if (tapOnScreen.dy < GameController.screenSize.height - 200 &&
          tapOnScreen.dx > 48) {
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
