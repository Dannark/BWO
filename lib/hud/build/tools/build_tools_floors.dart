import 'package:flutter/material.dart';

import '../../../game_controller.dart';
import '../../../map/map_controller.dart';
import '../../../ui/hud.dart';
import '../../../utils/tap_state.dart';
import '../build_subtools_bar.dart';
import '../tool_item.dart';

class BuildToolsFloors extends BuildSubToolsBar {
  final MapController _map;

  int selectedFloor = -1;

  BuildToolsFloors(this._map, HUD hudRef) {
    buttonList = [
      ToolItem("floor1", "Floor 1", hudRef, onFloorSelect),
      ToolItem("floor2", "Floor 2", hudRef, onFloorSelect),
      ToolItem("floor3", "Floor 3", hudRef, onFloorSelect),
      ToolItem("floor4", "Floor 4", hudRef, onFloorSelect),
      ToolItem("floor5", "Floor 5", hudRef, onFloorSelect),
      ToolItem("floor6", "Floor 6", hudRef, onFloorSelect),
      ToolItem("floor7", "Floor 7", hudRef, onFloorSelect),
      ToolItem("floor8", "Floor 8", hudRef, onFloorSelect),
      ToolItem("floor9", "Floor 9", hudRef, onFloorSelect),
      ToolItem("floor10", "Floor 10", hudRef, onFloorSelect),
      ToolItem("floor11", "Floor 11", hudRef, onFloorSelect),
      ToolItem("floor12", "Floor 12", hudRef, onFloorSelect),
      ToolItem("floor13", "Floor 13", hudRef, onFloorSelect),
      ToolItem("floor14", "Floor 14", hudRef, onFloorSelect),
      ToolItem("floor15", "Floor 15", hudRef, onFloorSelect),
    ];
  }

  @override
  void draw(Canvas c) {
    super.draw(c);

    if (GameController.tapState == TapState.pressing) {
      var tapOnScreen = TapState.currentPosition;

      if (tapOnScreen.dy < GameController.screenSize.height - 200 &&
          tapOnScreen.dx > 48) {
        _map.gameScene.allowMapPan = false;
        placeFloor();
      }
    }
  }

  void onFloorSelect(dynamic bt) {
    selectButtonHighlight(bt);

    String idName = bt.spriteName;
    var id = int.parse(idName.replaceAll("floor", ""));
    selectedFloor = id;
  }

  void placeFloor() {
    if (selectedFloor != -1) _map.buildFoundation.placeFloor(selectedFloor);
  }
}
