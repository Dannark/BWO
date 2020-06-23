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

  void interactWithTrees(MapController map) {
    isDoingAction = false;

    if (GameController.tapState == TapState.DOWN) {

      for (var entity in map.entitysOnViewport) {
        Offset target = Offset(entity.x, entity.y);
        double distance = (Offset(player.x, player.y) - target).distance;
        
        if (distance <= 3 * player.worldSize) {
          
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
