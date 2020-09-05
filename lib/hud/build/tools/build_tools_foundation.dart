import 'package:flutter/material.dart';

import '../../../entity/player/player.dart';
import '../../../game_controller.dart';
import '../../../map/map_controller.dart';
import '../../../ui/hud.dart';
import '../../../utils/tap_state.dart';
import '../build_subtools_bar.dart';
import '../tool_item.dart';

class BuildToolsFoundation extends BuildSubToolsBar {
  final Player _player;
  final MapController _map;

  int width = 16;
  int height = 16;

  BuildToolsFoundation(this._player, this._map, HUD hudRef) {
    buttonList = [
      ToolItem("foundation", "8x8", hudRef, onFoundationPress),
      ToolItem("foundation", "16x8", hudRef, onFoundationPress),
      ToolItem("foundation", "16x16", hudRef, onFoundationPress),
      ToolItem("foundation", "24x16", hudRef, onFoundationPress),
      ToolItem("foundation", "24x24", hudRef, onFoundationPress),
    ];
  }

  @override
  void draw(Canvas c) {
    super.draw(c);

    if (GameController.tapState == TapState.pressing) {
      var tapOnWorld =
          TapState.screenToWorldPoint(TapState.currentPosition, _map) / 16;
      var tapOnScreen = TapState.currentPosition;

      var verticalBarButtons =
          Rect.fromLTWH(0, GameController.screenSize.height - 235, 48, 235);

      if (tapOnScreen.dy < GameController.screenSize.height - 200 &&
          TapState.currentClickingAtInside(verticalBarButtons) == false) {
        previewFoundation(tapOnWorld.dx.floor() + 1, tapOnWorld.dy.floor());
      }
    }
  }

  void onFoundationPress(dynamic bt) {
    selectButtonHighlight(bt);

    width = 16;
    height = 16;

    width = bt.name == '8x8' ? 8 : width;
    width = bt.name == '16x8' ? 16 : width;
    width = bt.name == '16x16' ? 16 : width;
    width = bt.name == '24x16' ? 24 : width;
    width = bt.name == '24x24' ? 24 : width;

    height = bt.name == '8x8' ? 8 : height;
    height = bt.name == '16x8' ? 8 : height;
    height = bt.name == '16x16' ? 16 : height;
    height = bt.name == '24x16' ? 16 : height;
    height = bt.name == '24x24' ? 24 : height;
    previewFoundation(_player.posX, _player.posY);
  }

  //create foundation
  void previewFoundation(int posX, int posY) {
    var x = posX - (width / 2.0).floor();
    var y = posY - (height / 2.0).floor();

    dynamic foundationData = {
      'owner': _player.name,
      'name': 'Home sweet home',
      'x': x,
      'y': y,
      'w': width,
      'h': height,
      'walls': [],
      'floors': [],
      'furnitures': []
    };
    // _map.buildFoundation.createFoundationIfDoesntExists(foundationData,
    //     (wasCreated) {

    // });
    _map.buildFoundation.updateOrInstantiateFoundation(foundationData);

    var isValid =
        _map.buildFoundation.checkIfTerrainLocationIsValid(x, y, width, height);
    _map.buildFoundation.myFoundation.isValidTerrain = isValid;
  }
}
