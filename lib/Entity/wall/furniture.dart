import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../../utils/preload_assets.dart';
import '../entity.dart';

class Furniture extends Entity {
  Sprite sprite;
  String imageId;
  final double zoom = 1;

  bool showLow = false;
  bool showCollisionBox = false;

  double width, height;

  Furniture(
      double newPosX, double newPosY, this.width, this.height, this.imageId)
      : super(newPosX.floor() * 16.0 + 8, (newPosY.ceil() + 1) * 16.0) {
    loadSprite();

    shadownSize = 1;
    //shadownLarge = PreloadAssets.getEffectSprite('shadown_square');
    shadownLarge = null;
    shadownOffset = Offset(0, 14);

    id = '_${newPosX.floor()}_${posY.ceil() + 1}';

    width *= 16;
    height *= 16;
    collisionBox = Rect.fromLTWH(x - 8, y - 16, width, height);
  }

  void loadSprite() {
    sprite = PreloadAssets.getFurnitureSprite(imageId);
    //sprite = await Sprite.loadSprite('walls/$_imgPath');
    //lowSprite = await Sprite.loadSprite('walls/low_$_imgPath');
  }

  void draw(Canvas c) {
    if (sprite == null) return;
    var pivot = Offset((zoom * 16) / 2, (sprite.size.y * 2) - height + 16);

    showCollisionBox = true;
    sprite.renderScaled(c, Position(x - pivot.dx, y - pivot.dy - z), scale: 2);

    showCollisionBox ? debugDraw(c) : null;
  }

  @override
  String toString() {
    return """id:$imageId, x:$posX y:$posY""";
  }

  dynamic toObject() {
    return {'id': imageId, 'x': posX, 'y': posY};
  }
}
