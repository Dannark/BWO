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
  Position bPos = Position.empty();

  bool isOpen = false;

  final MapController _map;
  Foundation foundation;

  BuildHUD(this._player, this._map, HUD hudRef) : super(hudRef) {
    drawOnHUD = true;
    loadSprite();
  }

  void loadSprite() async {
    _buildSprite = await Sprite.loadSprite("ui/hammer.png");
    _buildSpriteOpen = await Sprite.loadSprite("ui/hammer_open.png");
  }

  void draw(Canvas c) {
    if (_buildSprite == null || _buildSpriteOpen == null) return;

    var bPos = Position(10, GameController.screenSize.height - 176);
    if (isOpen) {
      _buildSpriteOpen.renderScaled(c, bPos, scale: 2);
    } else {
      _buildSprite.renderScaled(c, bPos, scale: 2);
    }

    var bRect = Rect.fromLTWH(bPos.x, bPos.y, 32, 32);
    if (TapState.clickedAt(bRect)) {
      isOpen = !isOpen;
      _player.canWalk = !isOpen;

      print('bulding mode: $isOpen');
      print('creating foundation');
      createFoundationIfDoesntExists();
    }

    if (isOpen) {
      //clicking anywhere on the map
      if (GameController.tapState == TapState.pressing &&
          TapState.currentClickingAtInside(bRect) == false) {
        addBuilding();
      }

      foundation?.drawArea(c);
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
      foundation = Foundation(foundationData, _map);
    }
  }

  void addBuilding() {
    if (!isOpen || foundation == null) return;

    var selectedWall = 2;
    var tap = TapState.screenToWorldPoint(TapState.currentPosition, _map) / 16;
    foundation.addWall(tap.dx, tap.dy, selectedWall);
  }
}

/// not implemented yet
class BuildWindows extends UIElement {
  BuildWindows(HUD hudRef) : super(hudRef) {}

  void draw(Canvas c) {}
}
