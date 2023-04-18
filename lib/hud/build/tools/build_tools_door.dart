import 'package:flame/extensions.dart';

import '../../../entity/wall/door.dart';
import '../../../game_controller.dart';
import '../../../map/map_controller.dart';
import '../../../ui/hud.dart';
import '../../../utils/tap_state.dart';
import '../build_subtools_bar.dart';
import '../build_tools_bar.dart';
import '../furniture_build.dart';
import '../tool_item.dart';

class BuildToolsDoor extends BuildSubToolsBar {
  final MapController _map;

  int width = 16;
  int height = 16;

  BuildToolsBar toolsBar;

  FurnitureBuild _furnitureBuild;
  String _selectedDoor;
  Door _instatiatedDoor;

  BuildToolsDoor(this._map, this.toolsBar, HUD hudRef) {
    buttonList = [
      ToolItem("door1", "Door 1", hudRef, onPress, size: Vector2(2, 1)),
      ToolItem("door2", "Door 2", hudRef, onPress, size: Vector2(2, 1)),
      ToolItem("door3", "Door 3", hudRef, onPress, size: Vector2(2, 1)),
    ];
  }

  @override
  void draw(Canvas c) {
    super.draw(c);

    if (_selectedDoor == null) return;

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
        addDoor();
      }
    }
  }

  void onPress(ToolItem bt) {
    selectButtonHighlight(bt);

    width = bt.size[0].floor();
    height = bt.size[1].floor();

    print('onPress ${bt.spriteName}');
    _selectedDoor = bt.spriteName;
  }

  //create foundation
  void previewFurniture(int posX, int posY) {
    var x = posX - (width / 2.0).floor();
    var y = posY - (height / 2.0).floor();

    var isValid = _map.buildFoundation.isValidAreaOnFoundation(
        x.toDouble(), y.toDouble(), width.toDouble(), height.toDouble());

    dynamic doorData = {
      'id': _selectedDoor,
      'x': x,
      'y': y,
      'w': width,
      'h': height,
    };
    if (_furnitureBuild == null) {
      _furnitureBuild = FurnitureBuild(doorData, _map);
    }
    _furnitureBuild.isValidTerrain = isValid;
    _furnitureBuild.setup(doorData);
  }

  void addDoor() {
    if (_instatiatedDoor == null) {
      _instatiatedDoor = _furnitureBuild.getDoor();
      _map.buildFoundation.placeFurniture(_instatiatedDoor);

      _selectedDoor = null;
      _instatiatedDoor = null;
      _furnitureBuild = null;

      selectButtonHighlight(null);
    } else {
      //update
    }
  }
}
