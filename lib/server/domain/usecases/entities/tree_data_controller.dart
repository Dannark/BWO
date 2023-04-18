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
      var deadTime = int.tryParse(value['dead_time'].toString());
      var hp = int.tryParse(value['hp'].toString());
      var damage = int.tryParse(value['damage'].toString());

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
    for (var foundation in map.buildFoundation.foundationList) {
      if (foundation.isInsideFoundation(posX, posY)) {
        continue;
      }
    }
    return false;
  }
}
