import 'package:BWO/scene/game_scene.dart';
import 'package:flutter/material.dart';

import '../utils/on_animation_end.dart';
import '../utils/sprite_controller.dart';
import 'items/items.dart';

class Equipment implements OnAnimationEnd {
  SpriteController equipmentAttack;
  SpriteController equipmentWalk;
  SpriteController currentSprite;

  String spriteFolder;
  Item item;

  Equipment(this.item) {
    spriteFolder = item.proprieties.equipmentFolderSprite;
    loadSprite(spriteFolder);
  }

  void loadSprite(String spriteFolder) async {
    var _viewPort = Rect.fromLTWH(0, 0, 32, 32);
    var _pivot = Offset(16, 24);
    var _scale = 3.0;
    var framesCount = 0;

    equipmentWalk = SpriteController("equipment/weapons/$spriteFolder/walk",
        _viewPort, _pivot, _scale, Offset(4, 1), framesCount, this);
    equipmentAttack = SpriteController("equipment/weapons/$spriteFolder/attack",
        _viewPort, _pivot, _scale, Offset(5, 1), framesCount, this);

    currentSprite = equipmentWalk;
  }

  @override
  void onAnimationEnd() {
    if (currentSprite == equipmentAttack) {
      currentSprite = equipmentWalk;
      currentSprite.direcion = equipmentAttack.direcion;
    }
  }
}
