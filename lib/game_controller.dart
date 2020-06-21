import 'dart:ui';
import 'package:BWO/Entity/Player.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:flame/anchor.dart';
import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

class GameController extends Game {
  Size screenSize;
  double fps;
  TextConfig config = TextConfig(fontSize: 12.0, color: Colors.white);

  static const int worldSize = 14;
  static double deltaTime;
  static double time = 0;
  MapController mapController = new MapController(27, 47); // (27, 47)=15
  Player player = new Player(0, 0, worldSize);

  GameController() {
    mapController.addEntity(player);
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
    config.render(c, "Trees: ${mapController.treesGenerated}", Position(10, 20),
        anchor: Anchor.topLeft);
    config.render(c, "Tiles: ${mapController.tilesGenerated}", Position(10, 30),
        anchor: Anchor.topLeft);
    config.render(c, "Location: ${player.posX},${player.posY}", Position(10, 40),
        anchor: Anchor.topLeft);
  }

  void update(double dt) {
    fps = 1.0 / dt;
    deltaTime = dt;
    time += dt;
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
  }
}
