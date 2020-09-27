import 'package:BWO/scene/game_scene.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../utils/preload_assets.dart';

class Tile {
  int posX;
  int posY;
  int size = 15;
  Color color;

  ///ground height from 0 to 255
  int height = 255;

  Paint boxPaint = Paint();
  Rect boxRect;
  List<Offset> points;

  String tileSpritePath;
  int idImg;
  Sprite tileSprite;

  Tile(this.posX, this.posY, this.height, this.size, this.color,
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
    if (path != null)
      tileSprite = PreloadAssets.getFloorSprite(path);
  }

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
        points.add(Offset(posX.toDouble(), posY.toDouble()));
      }
    }
    //c.drawRect(boxRect, boxPaint);
    double scale = GameScene.pixelsPerTile/16;
    if (size > 1) {
      tileSprite?.renderScaled(
          c, Position(boxRect.left, boxRect.top), scale: scale);
    }
  }

  dynamic toObject() {
    return {'id': idImg, 'x': posX, 'y': posY};
  }
}
