import 'package:flutter/material.dart';

import '../../../../entity/enemys/enemy.dart';
import '../../../../entity/enemys/skull.dart';
import '../../../../map/map_controller.dart';
import '../../../../utils/timer_helper.dart';
import '../../../utils/server_utils.dart';

class EnemyDataController {
  //final Player _player;
  final MapController _map;

  EnemyDataController(this._map);

  void onEnemysWalk(dynamic data) {
    var t = TimerHelper();
    //print('onEnemysWalk $data');
    /**
     * Fire when enemy walk by him self
     */

    data.forEach((key, value) {
      if (key == 'enemys') {
        value.forEach((keyEnemy, enemy) {
          var name = enemy["name"].toString();
          var enemyId = enemy["enemyId"].toString();
          var x = double.parse(enemy['x'].toString());
          var y = double.parse(enemy['y'].toString());
          var newX = double.parse(enemy['toX'].toString());
          var newY = double.parse(enemy['toY'].toString());
          var targetId = enemy['target'];

          if (name == 'Skull') {
            var skull =
                Skull(x, y, _map, name, enemyId, moveTo: Offset(newX, newY));

            var playerFound = _map.entityList.firstWhere(
                (element) => element.id == targetId,
                orElse: () => null);
            skull.iaController.target = playerFound;

            ServerUtils.addEntityIfNotExist(_map, skull);
          }
        });
      }
    });
    t.logDelayPassed('onEnemysWalk:');
  }

  void onEnemysEnterScreen(dynamic data) {
    var t = TimerHelper();
    //print('onEnemysEnterScreen $data');
    /**
     * Fired when the player walks
     */

    var spawnedEntitys = [];

    data.forEach((keyEnemy, enemy) {
      var name = enemy["name"].toString();
      var enemyId = enemy["enemyId"].toString();
      var x = double.parse(enemy['x'].toString());
      var y = double.parse(enemy['y'].toString());
      var newX = double.parse(enemy['toX'].toString());
      var newY = double.parse(enemy['toY'].toString());
      var targetId = enemy['target'];

      if (name == 'Skull') {
        var skull =
            Skull(x, y, _map, name, enemyId, moveTo: Offset(newX, newY));
        spawnedEntitys.add(skull);

        var playerFound = _map.entityList.firstWhere(
            (element) => element.id == targetId,
            orElse: () => null);
        skull.iaController.target = playerFound;

        ServerUtils.addEntityIfNotExist(_map, skull);
      }
    });

    deleteEnemyFromList(_map, spawnedEntitys);
    t.logDelayPassed('onEnemysEnterScreen:');
  }

  void onEnemyTargetingPlayer(dynamic data) {
    var t = TimerHelper();
    //print('onEnemyTargetingPlayer, $data');
    var enemys = data['enemys'];

    enemys.forEach((enemyID, enemyData) {
      var enemyId = enemyData['enemyId'].toString();
      var targetId = enemyData['target'].toString();
      // var x = double.parse(enemyData['x'].toString());
      // var y = double.parse(enemyData['y'].toString());

      var damage = int.parse(
          (enemyData['damage'] != null ? enemyData['damage'] : 0).toString());

      var targetHp = int.parse(
          (enemyData['target_hp'] != null ? enemyData['target_hp'] : 0)
              .toString());

      var playerFound = _map.entityList
          .firstWhere((element) => element.id == targetId, orElse: () => null);

      var entityFound = _map.entityList
          .firstWhere((element) => element.id == enemyId, orElse: () => null);

      if (entityFound is Enemy && playerFound != null) {
        entityFound.iaController
            .attackTarget(playerFound, damage: damage, targetHp: targetHp);
      }
    });
    t.logDelayPassed('onEnemyTargetingPlayer:');
  }

  void deleteEnemyFromList(MapController _map, List<dynamic> spawnedEntitys) {
    var t = TimerHelper();
    for (var entityOnMap in _map.entitysOnViewport) {
      if (entityOnMap is Enemy) {
        var foundEntity = spawnedEntitys.firstWhere(
            (element) => element.id == entityOnMap.id,
            orElse: () => null);

        if (foundEntity == null) {
          entityOnMap.destroy();
          print("""
### Destroying ENEMY ${entityOnMap.name} that is not on my Screen anymore""");
        }
      }
    }
    t.logDelayPassed('deleteEnemyFromList:');
  }
}
