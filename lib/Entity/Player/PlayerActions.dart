import 'package:BWO/Entity/Enemys/Enemy.dart';
import 'package:BWO/Entity/Items/Items.dart';
import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Map/tree.dart';
import 'package:BWO/Utils/SpriteController.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:BWO/Utils/TapState.dart';

class PlayerActions {
  Player player;
  PlayerActions(this.player);

  bool isDoingAction = false;

  void interactWithTrees(MapController map) {
    if (!player.isMine) {
      return;
    }
    isDoingAction = false;

    if (TapState.isTapingLeft()) {
      for (var entity in map.entitysOnViewport) {
        Offset target = Offset(entity.x, entity.y);
        double distance = (Offset(player.x, player.y) - target).distance;

        if (distance <= 3.0 * player.worldSize && isDoingAction == false) {
          if (entity is Tree && entity.status.isAlive()) {
            isDoingAction = true;

            if (player.currentSprite != player.attackSprites) {
              bool hasEnergy = player.status.useEnergy(1);
              if (hasEnergy) {
                player.currentSprite = player.attackSprites;

                player.playerNetwork
                    .sendHitTree(entity.x.round(), entity.y.round(), 1);
                entity.doAction(map);
              }
            }
            player.setDirection(target);
          } else if (entity is Enemy) {
            isDoingAction = true;

            if (player.currentSprite != player.attackSprites &&
                entity.status.isAlive()) {
              player.currentSprite = player.attackSprites;

              entity.getHut(player.status.getMaxAttackPoint());
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
