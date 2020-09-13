import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../../utils/preload_assets.dart';

class Door {
  Sprite sprite;
  bool show = true;
  Door() {
    loadsprite();
  }

  void loadsprite() {
    sprite = PreloadAssets.getFurnitureSprite('roof1');
  }

  void draw(Canvas c, double x, double y) {
    sprite?.renderScaled(c, Position(x, y), scale: 1);
  }
}
