import 'package:flutter/material.dart';

import '../../../entity/player/player.dart';
import '../../../map/map_controller.dart';
import '../../../ui/hud.dart';
import '../build_subtools_bar.dart';
import '../tool_item.dart';

class BuildToolsOptions extends BuildSubToolsBar {
  Player _player;
  MapController _map;

  BuildToolsOptions(this._player, this._map, HUD hudRef) {
    buttonList = [
      ToolItem("handsaw", "Delete Wall", hudRef, onDeleteWall),
      ToolItem("cancel", "Cancel", hudRef, onCancelPress),
      ToolItem("accept", "Save", hudRef, onAccept),
    ];
  }

  @override
  void draw(Canvas c) {
    super.draw(c);
  }

  void delete() {
    _map.buildFoundation.deleteWall();
  }

  void onDeleteWall(dynamic bt) {}

  void onCancelPress(dynamic bt) {}

  void onAccept(dynamic bt) {}
}
