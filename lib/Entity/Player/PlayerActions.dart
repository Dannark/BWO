import 'package:BWO/Entity/Items.dart';
import 'package:BWO/Entity/Player.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Map/tree.dart';
import 'package:BWO/Utils/SpriteController.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';

class PlayerActions {
  Player player;
  PlayerActions(this.player);

  bool isDoingAction = false;

  void interactWithTrees(MapController map) {
    isDoingAction = false;

    if (TapState.isTapingLeft()) {
      for (var entity in map.entitysOnViewport) {
        Offset target = Offset(entity.x, entity.y);
        double distance = (Offset(player.x, player.y) - target).distance;

        if (distance <= 3.5 * player.worldSize) {
          if (entity is Tree) {
            isDoingAction = true;

            if (player.currentSprite != player.attackSprites) {
              player.currentSprite = player.attackSprites;
              entity.playAnimation();

              Item maca = entity.dropApple();
              if (maca != null) {
                map.addEntity(maca);
              }
              Flame.audio.play("impact_tree.mp3", volume: 0.5);
            }
            player.setDirection(target);
          }
        }
      }
    } else {
      //player.currentSprite = player.walkSprites;
    }
  }
}
