import 'package:BWO/Entity/Enemys/Enemy.dart';
import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Scene/SceneObject.dart';
import 'package:BWO/Server/ServerController.dart';
import 'package:BWO/Utils/PhysicsController.dart';
import 'package:BWO/game_controller.dart';
import 'package:BWO/ui/HUD.dart';
import 'package:flame/anchor.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

class GameScene extends SceneObject {
  static const int worldSize = 16;

  TextConfig config =
      TextConfig(fontSize: 12.0, color: Colors.white, fontFamily: "Blocktopia");

  Player player;
  MapController mapController = new MapController();
  PhysicsController physicsController;
  static ServerController serverController;

  static HUD hud = HUD();

  GameScene() {
    serverController = ServerController(mapController);

    physicsController = new PhysicsController(mapController);
    player = new Player(0, 0, mapController, true, "Dannark");
    serverController.setPlayer(player);
    mapController.addPlayerRef(player);

    Flame.bgm.initialize();
    //Flame.bgm.play('recovery.mp3', volume: .2);
    Flame.audio.disableLog();
    Flame.audio.loadAll(['footstep_grass1.mp3', 'footstep_grass2.mp3']);
  }

  @override
  void draw(Canvas c) {
    Rect bgRect = Rect.fromLTWH(0, 0, GameController.screenSize.width,
        GameController.screenSize.height);

    mapController.drawMap(c, player.x, player.y, bgRect,
        movimentType: MovimentType.FOLLOW, tileSize: worldSize);
    int i = 0;
    mapController.entityList.forEach((e) {
      if (e is Player) {
        i++;
        config.render(c, "ON: ${e.name}", Position(10, 50 + (i * 10.0)),
            anchor: Anchor.topLeft);
      }
    });

    config.render(
        c,
        "FPS: ${GameController.fps.isNaN || GameController.fps.isInfinite ? 0 : GameController.fps.toInt()}",
        Position(10, 10),
        anchor: Anchor.topLeft);
    config.render(c, "HP: ${player.status.getHP()}", Position(10, 20),
        anchor: Anchor.topLeft);
    config.render(c, "Energy: ${player.status.getEnergy()}", Position(10, 30),
        anchor: Anchor.topLeft);
    config.render(
        c, "Location: ${player.posX}, ${player.posY}", Position(10, 40),
        anchor: Anchor.topLeft);

    hud.draw(c);
  }

  @override
  void update() {
    for (var entity in mapController.entitysOnViewport) {
      if (entity is Player || entity is Enemy) {
        entity.update();
      }
    }

    physicsController.update();
    serverController.update();
  }
}
