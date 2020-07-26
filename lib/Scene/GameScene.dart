import 'package:BWO/Entity/Enemys/Enemy.dart';
import 'package:BWO/Entity/Enemys/Skull.dart';
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
  MapController mapController;
  PhysicsController physicsController;
  static ServerController serverController;

  GameScene(String playerName, Offset startPosition, String spriteFolder) {
    mapController = new MapController(startPosition);
    serverController = ServerController(mapController);

    physicsController = new PhysicsController(mapController);
    player = new Player(
      startPosition.dx,
      startPosition.dy,
      mapController,
      true,
      playerName,
      this,
      spriteFolder: spriteFolder,
    );
    serverController.setPlayer(player);
    mapController.addPlayerRef(player);

    //Skull skull2 = new Skull(300, 32, mapController);
    //mapController.addEntity(new Skull(-300, 32, mapController));
    //mapController.addEntity(new Skull(300, 32, mapController));
    //mapController.addEntity(new Skull(-250, 250, mapController));
    //mapController.addEntity(new Skull(-350, 10, mapController));
    //mapController.addEntity(new Skull(350, -200, mapController));
    //mapController.addEntity(new Skull(0, -200, mapController));
    //mapController.addEntity(new Skull(100, -400, mapController));
    //mapController.addEntity(new Skull(-400, -400, mapController));
    //mapController.addEntity(new Skull(400, 400, mapController));

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

    config.render(
        c,
        "FPS: ${GameController.fps.isNaN || GameController.fps.isInfinite ? 0 : GameController.fps.toInt()}",
        Position(GameController.screenSize.width, 0),
        anchor: Anchor.topRight);

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
