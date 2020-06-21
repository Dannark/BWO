import 'package:BWO/Entity/Player.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Map/tree.dart';
import 'package:BWO/Utils/SpriteController.dart';
import 'package:BWO/game_controller.dart';
import 'package:flutter/cupertino.dart';

class PlayerActions {
  Player player;
  PlayerActions(this.player);

  bool isDoingAction = false;

  void interactWithTrees(MapController map, int posX, int posY) {
    isDoingAction = false;

    if (GameController.tapState == TapState.DOWN) {
      for (var entity in map.entity) {
        Offset target =
            Offset(entity.posX.toDouble(), entity.posY.toDouble() + 1);
        double distance =
            (Offset(posX.toDouble(), posY.toDouble()) - target).distance;

        if (distance <= 3) {
          if (entity is Tree) {
            isDoingAction = true;
            entity.playAnimation();

            player.setDirection(target);
          }
        }
      }
    }
  }
}
