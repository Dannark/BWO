import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../scene/game_scene.dart';
import '../utils/preload_assets.dart';
import 'map_controller.dart';

class Tile {
  int posX;
  int posY;
  int size = 15;
  Color color;
  double shade = 0;

  ///ground height from 0 to 255
  int height = 255;
  final MapController map;

  Paint boxPaint = Paint();
  Rect boxRect;
  List<Offset> points;
  Vertices vertices;

  String tileSpritePath;
  int idImg;
  Sprite tileSprite;

  Tile(this.posX, this.posY, this.map, this.height, this.size, this.color,
      {this.tileSpritePath, this.idImg}) {
    if (size > 1) {
      boxRect = Rect.fromLTWH(
        posX.toDouble() * size.toDouble(),
        posY.toDouble() * size.toDouble(),
        size.toDouble() + 1,
        size.toDouble() + 1,
      );
    } else {
      points = [Offset(posX.toDouble(), posY.toDouble())];
      boxPaint.strokeWidth = 2;
    }
    boxPaint.color = color != null ? color : Colors.white;

    loadSprite(tileSpritePath);
  }

  void loadSprite(String path) async {
    if (path != null) {
      tileSprite = PreloadAssets.getFloorSprite(path);
    }
  }

  void update () {}
  void draw(Canvas c) {
    if (size != GameScene.tilePixels) {
      size = GameScene.tilePixels;
      if (size > 1) {
        boxRect = Rect.fromLTWH(
          posX.toDouble() * size.toDouble(),
          posY.toDouble() * size.toDouble(),
          size.toDouble() + 1,
          size.toDouble() + 1,
        );
      } else {
        points = [Offset(posX.toDouble(), posY.toDouble())];
        //points.add(Offset(posX.toDouble(), posY.toDouble()));
      }
    }
    //c.drawRect(boxRect, boxPaint);
    var scale = GameScene.pixelsPerTile/16;
    if (size > 1) {
      tileSprite?.renderScaled(
          c, Position(boxRect.left, boxRect.top), scale: scale);
    }
  }

  dynamic toObject() {
    return {'id': idImg, 'x': posX, 'y': posY};
  }
}
