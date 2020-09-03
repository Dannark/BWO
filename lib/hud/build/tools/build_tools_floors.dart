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
    ];
  }

  @override
  void draw(Canvas c) {
    super.draw(c);

    if (GameController.tapState == TapState.pressing) {
      var tapOnScreen = TapState.currentPosition;

      if (tapOnScreen.dy < GameController.screenSize.height - 200 &&
          tapOnScreen.dx > 48) {
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
