import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../../utils/preload_assets.dart';

class Roof {
  int selectedIndex = 0;
  List<Sprite> roofSprite = [];
  bool show = true;
  Roof() {
    loadsprite();
  }

  void loadsprite() {
    roofSprite.add(PreloadAssets.getRoofSprite('roof1'));
    roofSprite.add(PreloadAssets.getRoofSprite('roof2'));
  }

  void draw(Canvas c, double x, double y) {
    selectedIndex = (x ~/ 16) % roofSprite.length;
    roofSprite[selectedIndex]?.renderScaled(c, Position(x, y - 80), scale: 1);
  }
}
