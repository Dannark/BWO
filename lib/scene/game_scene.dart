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
import '../utils/physics_controller.dart';
import 'scene_object.dart';

class GameScene extends SceneObject {
  static const int worldSize = 16;

  TextConfig config =
      TextConfig(fontSize: 12.0, color: Colors.white, fontFamily: "Blocktopia");

  Player player;
  MapController mapController;
  PhysicsController physicsController;
  static ServerController serverController;

  GameScene(String playerName, Offset startPosition, String spriteFolder,
      int hp, int xp, int lv) {
    mapController = MapController(startPosition);
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

    serverController.setPlayer(player);
    mapController.addPlayerRef(player);

    Flame.audio.disableLog();
    Flame.bgm.dispose();
    if (Flame.bgm.isPlaying == false) {
      Flame.bgm.initialize();
      //Flame.bgm.play('recovery.mp3', volume: .2);
    }
    Flame.audio.loadAll(['footstep_grass1.mp3', 'footstep_grass2.mp3']);
  }

  @override
  void draw(Canvas c) {
    var bgRect = Rect.fromLTWH(0, 0, GameController.screenSize.width,
        GameController.screenSize.height);

    if (player.id == null) return; //wait player log it

    mapController.drawMap(c, player.x, player.y, bgRect,
        movimentType: MovimentType.follow, tileSize: worldSize);

    config.render(
        c, "FPS: ${getFps()}", Position(GameController.screenSize.width, 0),
        anchor: Anchor.topRight);

    hud.draw(c);
  }

  int getFps() {
    return (GameController.fps.isNaN || GameController.fps.isInfinite
        ? 0
        : GameController.fps.toInt());
  }

  @override
  void update() {
    for (var entity in mapController.entitysOnViewport) {
      if (entity is Player || entity is Enemy) {
        entity.update();
      }
    }

    physicsController.update();
  }
}
