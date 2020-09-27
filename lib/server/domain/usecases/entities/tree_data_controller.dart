import 'package:BWO/scene/game_scene.dart';

import '../../../../entity/player/player.dart';
import '../../../../map/map_controller.dart';
import '../../../../map/tree.dart';

class TreeDataController {
  MapController map;

  TreeDataController(this.map);

  void updateTree(dynamic data) {
    //var pName = data['name'].toString();
  }

  void onTreeUpdate(dynamic data) {
    print('onTreeUpdate: $data');

    data.forEach((treeId, value) {
      var x = double.parse(value['x'].toString());
      var y = double.parse(value['y'].toString());
      var playerId = value['playerId'].toString();
      var deadTime =
          int.parse(value['dead_time'].toString(), onError: (source) => null);
      var hp = int.parse(value['hp'].toString(), onError: (source) => null);
      var damage =
          int.parse(value['damage'].toString(), onError: (source) => null);

      //Make the hit attack player animation
      var foundEntity = map.entityList
          .firstWhere((element) => element.id == playerId, orElse: () => null);
      if (foundEntity != null && foundEntity is Player) {
        foundEntity.playerNetwork.hitTreeAnimation(x, y);
      }

      //Set the tree health
      var foundTree = map.entitysOnViewport
          .firstWhere((element) => element.id == treeId, orElse: () => null);
      if (foundTree != null && foundTree is Tree) {
        if (hp != null) {
          if (damage != null) {
            //take damage
            foundTree.setHealth(hp);
          } else if (hp <= 0 && deadTime > 5) {
            //immediately dies (cancel die animation)
            foundTree.disable(respawnSecTimeout: 190 - deadTime);
          } else if (hp > 0 && damage == null) {
            //respawn
            if (isInsideFoundation(
                foundEntity.x.toDouble() / 16, foundEntity.y.toDouble() / 16)) ;
            foundTree.resetTree();
          }
        }
      }
    });
  }

  bool isInsideFoundation(double posX, double posY) {
    map.buildFoundation.foundationList.forEach((foundation) {
      if (foundation.isInsideFoundation(posX, posY)) {
        return true;
      }
    });
    return false;
  }
}
