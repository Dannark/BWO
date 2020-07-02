import 'package:BWO/Entity/Items/Items.dart';
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

        if (distance <= 3.0 * player.worldSize && isDoingAction == false) {
          if (entity is Tree && entity.status.isAlive()) {
            isDoingAction = true;

            if (player.currentSprite != player.attackSprites) {
              player.currentSprite = player.attackSprites;

              entity.doAction(map);
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
