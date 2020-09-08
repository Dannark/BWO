import 'package:flutter/material.dart';

import '../../../entity/wall/furniture.dart';
import '../../../game_controller.dart';
import '../../../map/map_controller.dart';
import '../../../ui/hud.dart';
import '../../../utils/tap_state.dart';
import '../build_subtools_bar.dart';
import '../build_tools_bar.dart';
import '../furniture_build.dart';
import '../tool_item.dart';

class BuildToolsFurniture extends BuildSubToolsBar {
  final MapController _map;

  int width = 16;
  int height = 16;

  BuildToolsBar toolsBar;

  FurnitureBuild _furnitureBuild;
  String _selectedFurniture;
  Furniture _instatiatedFuniture;

  BuildToolsFurniture(this._map, this.toolsBar, HUD hudRef) {
    buttonList = [
      ToolItem("bed1", "Bed 1", hudRef, onPress, size: Offset(2, 3)),
      ToolItem("refrigerator", "Refrigerator", hudRef, onPress,
          size: Offset(2, 1)),
    ];
  }

  @override
  void draw(Canvas c) {
    super.draw(c);

    if (_selectedFurniture == null) return;

    _furnitureBuild?.drawCollisionArea(c);

    if (GameController.tapState == TapState.pressing) {
      var tapOnWorld =
          TapState.screenToWorldPoint(TapState.currentPosition, _map) / 16;
      var tapOnScreen = TapState.currentPosition;

      var verticalBarButtons =
          Rect.fromLTWH(0, GameController.screenSize.height - 235, 48, 235);

      if (tapOnScreen.dy < GameController.screenSize.height - 200 &&
          TapState.currentClickingAtInside(verticalBarButtons) == false) {
        previewFurniture(tapOnWorld.dx.floor(), tapOnWorld.dy.floor());
      }
    }
    if (GameController.tapState == TapState.up) {
      if (_furnitureBuild != null && _furnitureBuild.isValidTerrain) {
        addFurniture();
      }
    }
  }

  void onPress(ToolItem bt) {
    selectButtonHighlight(bt);

    width = bt.size.dx.floor();
    height = bt.size.dy.floor();

    print('onPress ${bt.spriteName}');
    _selectedFurniture = bt.spriteName;
  }

  //create foundation
  void previewFurniture(int posX, int posY) {
    var x = posX - (width / 2.0).floor();
    var y = posY - (height / 2.0).floor();

    var isValid = _map.buildFoundation.isValidAreaOnFoundation(
        x.toDouble(), y.toDouble(), width.toDouble(), height.toDouble());

    dynamic furnitureData = {
      'id': _selectedFurniture,
      'x': x,
      'y': y,
      'w': width,
      'h': height,
    };
    if (_furnitureBuild == null) {
      _furnitureBuild = FurnitureBuild(furnitureData, _map);
    }
    _furnitureBuild.isValidTerrain = isValid;
    _furnitureBuild.setup(furnitureData);
  }

  void addFurniture() {
    if (_instatiatedFuniture == null) {
      _instatiatedFuniture = _furnitureBuild.getFurniture();
      _map.buildFoundation.placeFurniture(_instatiatedFuniture);

      _selectedFurniture = null;
      _instatiatedFuniture = null;
      _furnitureBuild = null;

      selectButtonHighlight(null);
    } else {
      //update
    }
  }
}
