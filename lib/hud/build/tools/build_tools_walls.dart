import 'package:flutter/material.dart';

import '../../../entity/player/player.dart';
import '../../../map/map_controller.dart';
import '../../../ui/hud.dart';
import '../build_subtools_bar.dart';
import '../tool_item.dart';

class BuildToolsWall extends BuildSubToolsBar {
  Player _player;
  MapController _map;

  BuildToolsWall(this._player, this._map, HUD hudRef) {
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
  }

  void delete() {
    _map.buildFoundation.deleteWall();
  }

  void onWallPress(dynamic bt) {}
}
