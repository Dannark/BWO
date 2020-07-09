import 'dart:math';
import 'dart:ui';
import 'package:BWO/Effects/EffectsController.dart';
import 'package:BWO/Entity/Enemys/Enemy.dart';
import 'package:BWO/Entity/Enemys/Skull.dart';
import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Server/ServerController.dart';
import 'package:BWO/ui/UIController.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Utils/PhysicsController.dart';
import 'package:BWO/Utils/TapState.dart';
import 'package:flame/anchor.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

class GameController extends Game with PanDetector, WidgetsBindingObserver {
  static Size screenSize;
  double fps;
  TextConfig config =
      TextConfig(fontSize: 12.0, color: Colors.white, fontFamily: "Blocktopia");

  static const int worldSize = 16;
  static double deltaTime = 0;
  static double time = 0;
  static int tapState = TapState.UP;
  static int preTapState = TapState.UP;
  MapController mapController = new MapController();
  PhysicsController physicsController;
  static final UIController uiController = UIController();
  static ServerController serverController;
  Player player;
  Skull skull;

  GameController() {
    serverController = ServerController(mapController);

    physicsController = new PhysicsController(mapController);
    player = new Player(0, 0, mapController, true, "Sansung");
    serverController.setPlayer(player);

    skull = new Skull(-300, 32, mapController);
    mapController.addEntity(player);
    mapController.addEntity(skull);

    Flame.bgm.initialize();
    //Flame.bgm.play('recovery.mp3', volume: .2);
    Flame.audio.disableLog();
    Flame.audio.loadAll(['footstep_grass1.mp3', 'footstep_grass2.mp3']);
  }

  void render(Canvas c) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff000000);
    c.drawRect(bgRect, bgPaint);

    mapController.drawMap(c, player.x, player.y, bgRect,
        movimentType: MovimentType.FOLLOW, tileSize: worldSize);

    config.render(c, "FPS: ${fps.isNaN || fps.isInfinite ? 0 : fps.toInt()}",
        Position(10, 10),
        anchor: Anchor.topLeft);
    config.render(c, "HP: ${player.status.getHP()}", Position(10, 20),
        anchor: Anchor.topLeft);
    config.render(c, "Energy: ${player.status.getEnergy()}", Position(10, 30),
        anchor: Anchor.topLeft);
    config.render(
        c, "Location: ${player.posX}, ${player.posY}", Position(10, 40),
        anchor: Anchor.topLeft);
    physicsController.update();

    EffectsController.draw(c);

    uiController.draw(c);

    if (tapState == TapState.DOWN) {
      tapState = TapState.PRESSING;
    }
  }

  void update(double dt) {
    fps = 1.0 / dt;
    deltaTime = dt;
    time += dt;

    if (preTapState == TapState.DOWN) {
      tapState = TapState.DOWN;
      preTapState = TapState.UP;
    }

    for (var entity in mapController.entitysOnViewport) {
      if (entity is Player || entity is Enemy) {
        entity.update();
      }
    }

    physicsController.update();
    serverController.update();
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
  }

  @override
  void onPanDown(DragDownDetails details) {
    preTapState = TapState.DOWN;
    TapState.localPosition = details.localPosition;
  }

  @override
  void onPanEnd(DragEndDetails details) {
    tapState = TapState.UP;
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    // TODO: implement lifecycleStateChange
    super.lifecycleStateChange(state);
    print("state = ${state}");
  }
}
