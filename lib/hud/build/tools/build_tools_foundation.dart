import 'package:BWO/utils/tap_state.dart';
import 'package:flutter/material.dart';

import '../../../entity/player/player.dart';
import '../../../game_controller.dart';
import '../../../map/map_controller.dart';
import '../../../ui/hud.dart';
import '../build_subtools_bar.dart';
import '../tool_item.dart';

class BuildToolsFoundation extends BuildSubToolsBar {
  Player _player;
  MapController _map;

  int width = 16;
  int height = 16;

  BuildToolsFoundation(this._player, this._map, HUD hudRef) {
    buttonList = [
      ToolItem("foundation", "8x8", hudRef, onFoundationPress),
      ToolItem("foundation", "16x8", hudRef, onFoundationPress),
      ToolItem("foundation", "16x16", hudRef, onFoundationPress),
      ToolItem("foundation", "24x16", hudRef, onFoundationPress),
    ];
  }

  @override
  void draw(Canvas c) {
    super.draw(c);

    if (GameController.tapState == TapState.pressing) {
      var tapOnWorld =
          TapState.screenToWorldPoint(TapState.currentPosition, _map) / 16;
      var tapOnScreen = TapState.currentPosition;

      if (tapOnScreen.dy < GameController.screenSize.height - 200 &&
          tapOnScreen.dx > 48) {
        previewFoundation(tapOnWorld.dx.floor() + 1, tapOnWorld.dy.floor());
      }
    }
  }

  void onFoundationPress(dynamic bt) {
    selectButtonHightlight(bt);

    width = 16;
    height = 16;

    width = bt.name == '8x8' ? 8 : width;
    width = bt.name == '16x8' ? 16 : width;
    width = bt.name == '16x16' ? 16 : width;
    width = bt.name == '24x16' ? 24 : width;

    height = bt.name == '8x8' ? 8 : height;
    height = bt.name == '16x8' ? 8 : height;
    height = bt.name == '16x16' ? 16 : height;
    height = bt.name == '24x16' ? 16 : height;
    previewFoundation(_player.posX, _player.posY);
  }

  //create foundation
  void previewFoundation(int posX, int posY) {
    var x = posX - (width / 2.0).floor() - 1;
    var y = posY - (height / 2.0).floor();

    dynamic foundationData = {
      'owner': _player.name,
      'name': 'Home sweet home',
      'x': x,
      'y': y,
      'w': width,
      'h': height,
      'walls': []
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
