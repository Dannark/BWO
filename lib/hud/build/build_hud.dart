import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../../entity/player/player.dart';
import '../../entity/wall/wall.dart';
import '../../game_controller.dart';
import '../../map/map_controller.dart';
import '../../ui/hud.dart';
import '../../ui/ui_element.dart';
import '../../utils/tap_state.dart';
import 'build_tools_bar.dart';

class BuildHUD extends UIElement {
  final Player _player;
  Sprite _buildSprite;
  Sprite _buildSpriteOpen;
  Sprite _deleteSprite;

  Sprite _lowWallSprite;
  Sprite _fullWallSprite;
  Sprite _upstairSprite;
  Sprite _switchLevelButtonSprite;

  Position bPos = Position.empty();
  Position sPos = Position.empty();

  BuildButtonState _buildBtState = BuildButtonState.none;

  BuildToolsBar _buildToolsBar;

  final MapController _map;

  BuildHUD(this._player, this._map, HUD hudRef) : super(hudRef) {
    drawOnHUD = true;
    loadSprite();
    _buildToolsBar = BuildToolsBar(_player, _map, hudRef);
  }

  void loadSprite() async {
    _buildSprite = await Sprite.loadSprite("ui/hammer.png");
    _buildSpriteOpen = await Sprite.loadSprite("ui/hammer_open.png");
    _deleteSprite = await Sprite.loadSprite("ui/handsaw.png");

    _lowWallSprite = await Sprite.loadSprite("ui/low_wall.png");
    _fullWallSprite = await Sprite.loadSprite("ui/full_wall.png");
    _upstairSprite = await Sprite.loadSprite("ui/upstair.png");

    _switchLevelButtonSprite = _upstairSprite;
  }

  void draw(Canvas c) {
    if (_buildSprite == null ||
        _buildSpriteOpen == null ||
        _deleteSprite == null) return;

    bPos = Position(10, GameController.screenSize.height - 176);
    if (_buildBtState == BuildButtonState.build) {
      _buildSpriteOpen.renderScaled(c, bPos, scale: 2);
    } else if (_buildBtState == BuildButtonState.delete) {
      _deleteSprite.renderScaled(c, bPos, scale: 2);
    } else {
      _buildSprite.renderScaled(c, bPos, scale: 2);
    }
    _handlerBuildButtonClick();

    if (_buildBtState == BuildButtonState.build ||
        _buildBtState == BuildButtonState.delete) {
      _map.buildFoundation.myFoundation?.drawArea(c);
    }

    // Switch level button
    if (_map.buildFoundation.myFoundation != null) {
      sPos = Position(10, GameController.screenSize.height - 224);
      var sRect = Rect.fromLTWH(sPos.x, sPos.y, 32, 32);
      if (TapState.clickedAt(sRect)) {
        _handlerWallLevelButtonClick();
      }
      _switchLevelButtonSprite?.renderScaled(c, sPos, scale: 2);
      var isBuildingMode = _buildBtState != BuildButtonState.none;
      _map.buildFoundation.myFoundation
          ?.switchWallHeight(isBuildingMode: isBuildingMode);
    }
  }

  void _handlerBuildButtonClick() {
    var bRect = Rect.fromLTWH(bPos.x, bPos.y, 32, 32);
    if (TapState.clickedAt(bRect)) {
      if (_buildBtState == BuildButtonState.none) {
        _buildToolsBar.setActive(true);
        _buildBtState = BuildButtonState.build;
        _player.canWalk = false;
      } else {
        //finish building
        _buildBtState = BuildButtonState.none;
        _player.canWalk = true;
        _buildToolsBar.setActive(false);
      }
    }
  }

  void _handlerWallLevelButtonClick() {
    if (_map.buildFoundation.myFoundation != null) {
      if (_map.buildFoundation.myFoundation.showWallLevel == WallLevel.auto) {
        _map.buildFoundation.myFoundation.showWallLevel = WallLevel.hight;
        _switchLevelButtonSprite = _fullWallSprite;
      } else if (_map.buildFoundation.myFoundation.showWallLevel ==
          WallLevel.hight) {
        _map.buildFoundation.myFoundation.showWallLevel = WallLevel.low;
        _switchLevelButtonSprite = _lowWallSprite;
      } else if (_map.buildFoundation.myFoundation.showWallLevel ==
          WallLevel.low) {
        _map.buildFoundation.myFoundation.showWallLevel = WallLevel.auto;
        _switchLevelButtonSprite = _upstairSprite;
      }
    }
  }
}

enum BuildButtonState {
  none,
  build,
  delete,
}

/// not implemented yet
class BuildWindows extends UIElement {
  BuildWindows(HUD hudRef) : super(hudRef);

  void draw(Canvas c) {}
}
