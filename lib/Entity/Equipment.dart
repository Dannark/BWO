import 'package:BWO/Entity/Items/Items.dart';
import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Utils/OnAnimationEnd.dart';
import 'package:BWO/Utils/SpriteController.dart';
import 'package:flutter/material.dart';

class Equipment implements OnAnimationEnd {
  SpriteController equipmentAttack;
  SpriteController equipmentWalk;
  SpriteController currentSprite;

  String spriteFolder;
  Item item;

  Equipment(this.item) {
    this.spriteFolder = item.proprieties.equipmentFolderSprite;
    loadSprite(spriteFolder);
  }

  void loadSprite(spriteFolder) async {
    Rect _viewPort = Rect.fromLTWH(0, 0, 32, 32);
    Offset _pivot = Offset(16, 24);
    double _scale = 3;
    int framesCount = 0;

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
    }
  }
}
