import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../../utils/preload_assets.dart';

class Roof {
  Sprite roofSprite;
  bool show = true;
  Roof() {
    loadsprite();
  }

  void loadsprite() {
    roofSprite = PreloadAssets.getRoofSprite('roof1');
  }

  void draw(Canvas c, double x, double y) {
    roofSprite?.renderScaled(c, Position(x, y - 64), scale: 1);
  }
}
