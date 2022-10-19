import 'dart:developer';

import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

import '../../utils/preload_assets.dart';
import '../../utils/sprite_controller.dart';
import 'furniture.dart';

class Door extends Furniture {
  Sprite openDoor;
  Sprite sprite;
  bool show = true;
  bool isOpen = false;

  Door(double newPosX, double newPosY, double width, double height,
      String imageId)
      : super(newPosX, newPosY, width, height, imageId) {
    loadsprite();
  }

  void loadsprite() {
    openDoor = PreloadAssets.getFurnitureSprite('${imageId}_open');
    sprite = PreloadAssets.getFurnitureSprite(imageId);
  }

  @override
  void draw(Canvas c) {
    var pivot = Offset((zoom * 16) / 2, height);
    if (isOpen) {
      currentSprite = openDoor;
      isActive = false;
    } else {
      currentSprite = sprite;
      isActive = true;
    }
    log('${x - pivot.dy}, $y + ${pivot.dy}');
    currentSprite?.render(c,
        position: Vector2(x - pivot.dx, y - SpriteController.spriteSize * 5),
        size:
            Vector2(currentSprite.srcSize.x * 2, currentSprite.srcSize.y * 2));
    // super.draw(c);
  }
}
