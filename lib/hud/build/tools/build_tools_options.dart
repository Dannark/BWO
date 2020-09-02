import 'package:flutter/material.dart';

import '../../../game_controller.dart';
import '../../../map/map_controller.dart';
import '../../../ui/hud.dart';
import '../../../utils/tap_state.dart';
import '../build_subtools_bar.dart';
import '../tool_item.dart';

class BuildToolsOptions extends BuildSubToolsBar {
  MapController _map;

  String btSelected;

  BuildToolsOptions(this._map, HUD hudRef) {
    buttonList = [
      ToolItem("handsaw", "Delete Wall", hudRef, onDeleteWall),
      ToolItem("cancel", "Cancel", hudRef, onCancelPress),
      ToolItem("accept", "Save", hudRef, onAccept),
    ];
  }

  @override
  void draw(Canvas c) {
    super.draw(c);

    if (GameController.tapState == TapState.pressing &&
        btSelected == 'Delete Wall') {
      deleteWall();
    }
  }

  void deleteWall() {
    _map.buildFoundation.deleteWall();
  }

  void onDeleteWall(dynamic bt) {
    selectButtonHighlight(bt);
    btSelected = bt.name;
  }

  void onCancelPress(dynamic bt) {
    selectButtonHighlight(bt);
  }

  void onAccept(dynamic bt) {
    selectButtonHighlight(bt);

    _map.buildFoundation.myFoundation.save();
  }
}
