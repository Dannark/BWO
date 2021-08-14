import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../../utils/preload_assets.dart';
import 'furniture.dart';

class Door extends Furniture {
  Sprite openDoor;
  bool show = true;
  bool isOpen = false;

  Door(double newPosX, double newPosY, double width, double height,
      String imageId)
      : super(newPosX, newPosY, width, height, imageId) {
    loadsprite();
  }

  void loadsprite() {
    openDoor = PreloadAssets.getFurnitureSprite('${imageId}_open');
  }

  @override
  void draw(Canvas c) {
    if (isOpen) {
      currentSprite = openDoor;
      isActive = false;
    } else {
      currentSprite = sprite;
      isActive = true;
    }
    super.draw(c);
    //sprite?.renderScaled(c, Position(x, y), scale: 1);
  }
}
