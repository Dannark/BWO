import 'package:BWO/utils/preload_assets.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../entity.dart';

class Wall extends Entity {
  Sprite sprite;
  Sprite lowSprite;
  int imageId;
  String _imgPath;
  final double zoom = 1;

  bool showLow = false;
  bool showCollisionBox = false;

  Wall(double newPosX, double newPosY, this.imageId)
      : super(newPosX.floor() * 16.0 + 8, newPosY.ceil() * 16.0) {
    _imgPath = getImageId(imageId);
    loadSprite();

    shadownSize = 1;
    shadownLarge = Sprite("shadown_square.png");
    shadownOffset = Offset(0, 14);

    height = (zoom * 16) * 5;
    id = '_${newPosX.floor()}_${posY.ceil()}';
  }

  void loadSprite() async {
    //sprite = PreloadAssets.getWallSprite(_imgPath);
    //lowSprite = PreloadAssets.getWallSprite(_imgPath);
    sprite = await Sprite.loadSprite('walls/$_imgPath');
    lowSprite = await Sprite.loadSprite('walls/low_$_imgPath');
  }

  void draw(Canvas c) {
    if (sprite == null || lowSprite == null) return;
    var pivot = Offset((zoom * 16) / 2, height);

    if (showLow) {
      lowSprite.renderScaled(c, Position(x - pivot.dx, y - pivot.dy - z),
          scale: 1);
    } else {
      sprite.renderScaled(c, Position(x - pivot.dx, y - pivot.dy - z),
          scale: 1);
    }

    showCollisionBox ? debugDraw(c) : null;
  }

  String getImageId(int imageId) {
    return 'wall$imageId.png';
  }

  @override
  String toString() {
    return """id:$imageId, x:$posX y:$posY""";
  }

  dynamic toObject() {
    return {'id': imageId, 'x': posX, 'y': posY};
  }
}

enum WallLevel { hight, low, auto }
