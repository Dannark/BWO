import 'package:flutter/material.dart';

import '../../map/map_controller.dart';
import '../../map/tree.dart';
import '../../utils/tap_state.dart';
import '../enemys/enemy.dart';
import 'player.dart';

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
        var target = Offset(entity.x, entity.y);
        var distance = (Offset(player.x, player.y) - target).distance;

        if (distance <= 3.0 * player.worldSize && isDoingAction == false) {
          if (entity is Tree && entity.status.isAlive()) {
            isDoingAction = true;

            if (player.currentSprite != player.attackSprites) {
              var hasEnergy = player.status.useEnergy(1);
              if (hasEnergy) {
                player.status.consumeHungriness(0.3);
                player.currentSprite = player.attackSprites;
                player.equipmentController.setAction(DoAction.attack);

                player.playerNetwork
                    .sendHitTree(entity.x.round(), entity.y.round(), 1);
                entity.doDamage(
                    map, player.equipmentController.getMaxCutTreeDamage());
              }
            }
            player.setDirection(target);
          } else if (entity is Enemy) {
            isDoingAction = true;

            if (player.currentSprite != player.attackSprites &&
                entity.status.isAlive()) {
              player.currentSprite = player.attackSprites;
              player.equipmentController.setAction(DoAction.attack);

              entity.getHut(
                  player.equipmentController.getMaxAttackDamage(), player,
                  isMine: true);
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

enum DoAction { attack }
