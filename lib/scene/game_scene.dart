import 'package:BWO/hud/build/build_hud.dart';
import 'package:flame/anchor.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

import '../entity/enemys/enemy.dart';
import '../entity/player/player.dart';
import '../game_controller.dart';
import '../map/map_controller.dart';
import '../server/domain/usecases/server_controller.dart';
import '../server/utils/server_utils.dart';
import '../utils/physics_controller.dart';
import '../utils/tap_state.dart';
import 'scene_object.dart';

class GameScene extends SceneObject {
  static int tilePixels = 8;
  static double pixelsPerTile = 8;
  static const int maxZoom = 4;

  TextConfig config =
      TextConfig(fontSize: 12.0, color: Colors.white, fontFamily: "Blocktopia");

  Player player;
  Offset mapOffset, touchOffset;
  bool allowMapPan;
  MapController mapController;
  PhysicsController physicsController;
  static ServerController serverController;

  GameScene(String playerName, Offset startPosition, String spriteFolder,
      int hp, int xp, int lv) {
    mapController = MapController(startPosition, this);
    serverController = ServerController(mapController);

    physicsController = PhysicsController(mapController);
    player = Player(
      startPosition.dx,
      startPosition.dy,
      mapController,
      playerName,
      playerName,
      this,
      spriteFolder: spriteFolder,
      isMine: true,
    );
    player.status.setLife(hp);
    player.status.setExp(xp);
    player.status.setLevel(lv, 1);
    mapOffset = Offset(player.x, player.y);

    serverController.setPlayer(player);
    mapController.addPlayerRef(player);

    Flame.audio.disableLog();
    Flame.bgm.dispose();
    Flame.bgm.initialize();
    if (ServerUtils.database == 'production') {
      if (!Flame.bgm.isPlaying) {
        Flame.bgm.play('recovery.mp3', volume: .2);
      }
    }
    Flame.audio.loadAll(['footstep_grass1.mp3', 'footstep_grass2.mp3']);
  }

  @override
  void draw(Canvas c) {
    var bgRect = Rect.fromLTWH(0, 0, GameController.screenSize.width,
        GameController.screenSize.height);
    var scale = pixelsPerTile/16;

    if (player.id == null) return; //wait player log it

    var movementType = MovimentType.move;
    if (player.canWalk) {
      movementType = MovimentType.follow;
      mapOffset = Offset(player.x*scale, player.y*scale);
    }

    mapController.drawMap(c, mapOffset.dx, mapOffset.dy, bgRect,
              movimentType: movementType, tileSize: tilePixels);

    config.render(
        c, "FPS: ${getFps()}", Position(GameController.screenSize.width-6, 0),
        anchor: Anchor.topRight);


    hud.draw(c);
    /// hud.draw will tell us if map is allowed to be panned by dragging
    /// Also don't allow pan if touch is inside my foundation
    if (mapController?.buildFoundation?.myFoundation != null &&
        BuildHUD.buildBtState != BuildButtonState.none &&
        mapController.buildFoundation.myFoundation.bounds.contains
          (TapState.currentPosition)) {
      allowMapPan = false;
    }

    if (!player.canWalk && allowMapPan) {
      if (GameController.tapState == TapState.pressing &&
          TapState.currentPosition.dy < bgRect.height - 200) {
        var diff = (touchOffset - TapState.currentPosition);
        mapOffset += diff;
      }
    }
    allowMapPan = true;
    touchOffset = TapState.currentPosition;
  }

  int getFps() {
    return (GameController.fps.isNaN || GameController.fps.isInfinite
        ? 0
        : GameController.fps.toInt());
  }

  @override
  void update() {
    var bgRect = Rect.fromLTWH(0, 0, GameController.screenSize.width,
        GameController.screenSize.height);
    mapController.updateMap(mapOffset.dx, mapOffset.dy, bgRect,
        movimentType: MovimentType.move, tileSize: tilePixels);

    for (var entity in mapController.entitysOnViewport) {
      if (entity is Player || entity is Enemy) {
        entity.update();
      }
    }



    physicsController.update();
  }

  /// Zoom levels change the pixels per tile used for the draw() functions
  /// (but world units per tile stays as 16 units/tile)
  void setZoom (int zoom) {
    /// zoom 0 -> 24 pixels per tile, 1 -> 16, 2 -> 8, 3 -> 4, 4 -> 1;
    mapController.zoom = zoom;
    tilePixels = 24 - zoom * 8;
    if (zoom == 3) {
      tilePixels = 4;
    }
    if (zoom == 4) {
      tilePixels = 1;
      player.canWalk = false;
    } else {
      player.canWalk = true;
    }

    pixelsPerTile = tilePixels.toDouble();
    mapController.scale = GameScene.pixelsPerTile/16;
    mapOffset = Offset(player.x*mapController.scale,
        player.y*mapController.scale);
  }

  void zoom (int zoom) {
    if (mapController.zoom + zoom <= maxZoom
        && mapController.zoom + zoom >= 0) {
      setZoom (mapController.zoom + zoom);
    }
  }
}
