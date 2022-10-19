import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../utils/preload_assets.dart';
import '../../utils/sprite_controller.dart';

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
    roofSprite[selectedIndex]?.render(c,
        position: Vector2(x, y - 80),
        size: Vector2(
            SpriteController.spriteSize, SpriteController.spriteSize * 5));
  }
}
