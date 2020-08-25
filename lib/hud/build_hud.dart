import 'package:BWO/entity/wall/wall.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../entity/player/player.dart';
import '../entity/wall/foundation.dart';
import '../game_controller.dart';
import '../map/map_controller.dart';
import '../ui/hud.dart';
import '../ui/ui_element.dart';
import '../utils/tap_state.dart';

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

  final MapController _map;
  Foundation foundation;

  BuildHUD(this._player, this._map, HUD hudRef) : super(hudRef) {
    drawOnHUD = true;
    loadSprite();
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
      foundation?.drawArea(c);
    }

    // Switch level button
    if (foundation != null) {
      sPos = Position(10, GameController.screenSize.height - 224);
      var sRect = Rect.fromLTWH(sPos.x, sPos.y, 32, 32);
      if (TapState.clickedAt(sRect)) {
        _handlerWallLevelButtonClick();
      }
      _switchLevelButtonSprite.renderScaled(c, sPos, scale: 2);
      foundation?.switchWallHeight();
    }
  }

  void _handlerBuildButtonClick() {
    var bRect = Rect.fromLTWH(bPos.x, bPos.y, 32, 32);
    if (TapState.clickedAt(bRect)) {
      if (_buildBtState == BuildButtonState.none) {
        _buildBtState = BuildButtonState.build;
        _player.canWalk = false;
      } else if (_buildBtState == BuildButtonState.build) {
        _buildBtState = BuildButtonState.delete;
        _player.canWalk = false;
      } else {
        _buildBtState = BuildButtonState.none;
        _player.canWalk = true;
      }

      createFoundationIfDoesntExists();
    }

    if (_buildBtState == BuildButtonState.build) {
      //clicking anywhere on the map
      if (GameController.tapState == TapState.pressing &&
          TapState.currentClickingAtInside(bRect) == false) {
        addBuilding();
      }
    } else if (_buildBtState == BuildButtonState.delete) {
      deleteWall();
    }
  }

  void createFoundationIfDoesntExists() {
    if (foundation == null) {
      /*var tap =
          TapState.screenToWorldPoint(TapState.currentPosition, _map) / 16;*/

      dynamic foundationData = [
        {
          'owner': 'Someone',
          'name': 'Home sweet home',
          'x': _player.posX - 8, //tap.dx.floor() - 8,
          'y': _player.posY - 8, //tap.dy.ceil() - 8,
          'w': 16,
          'h': 16
        },
        []
      ];
      foundation = Foundation(foundationData, _map, _player);
    }
  }

  void addBuilding() {
    if (_buildBtState != BuildButtonState.build || foundation == null) return;

    var selectedWall = 3;
    var tap = TapState.screenToWorldPoint(TapState.currentPosition, _map) / 16;
    foundation.addWall(tap.dx, tap.dy, selectedWall);
  }

  void deleteWall() {
    if (_buildBtState != BuildButtonState.delete || foundation == null) return;

    var tap = TapState.screenToWorldPoint(TapState.currentPosition, _map) / 16;
    foundation.deleteWall(tap.dx, tap.dy);
  }

  void _handlerWallLevelButtonClick() {
    if (foundation != null) {
      if (foundation.showWallLevel == WallLevel.auto) {
        foundation.showWallLevel = WallLevel.hight;
        _switchLevelButtonSprite = _fullWallSprite;
      } else if (foundation.showWallLevel == WallLevel.hight) {
        foundation.showWallLevel = WallLevel.low;
        _switchLevelButtonSprite = _lowWallSprite;
      } else if (foundation.showWallLevel == WallLevel.low) {
        foundation.showWallLevel = WallLevel.auto;
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
  BuildWindows(HUD hudRef) : super(hudRef) {}

  void draw(Canvas c) {}
}
