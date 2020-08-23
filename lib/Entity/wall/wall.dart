import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../entity.dart';

class Wall extends Entity {
  Sprite sprite;
  String _imgPath;
  final double zoom = 1;

  Wall(double newPosX, double newPosY, int imageId)
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
    sprite = await Sprite.loadSprite(_imgPath);
  }

  void draw(Canvas c) {
    if (sprite == null) return;
    var pivot = Offset((zoom * 16) / 2, height);
    sprite.renderScaled(c, Position(x - pivot.dx, y - pivot.dy - z), scale: 1);

    //debugDraw(c);
  }

  String getImageId(int imageId) {
    return 'walls/wall$imageId.png';
  }
}
