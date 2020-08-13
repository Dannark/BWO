import 'package:flutter/material.dart';

import '../entity/enemys/enemy.dart';
import '../entity/enemys/skull.dart';
import '../entity/entity.dart';
import '../entity/player/player.dart';
import '../map/map_controller.dart';
import 'network_server.dart';

class ServerController extends NetworkServer {
  MapController map;
  Player player;
  bool firstMove = true;

  ServerController(this.map) {
    //initFirebase();
  }

  void update() {}

  void setPlayer(Player player) {
    if (offlineMode) return;
    this.player = player;

    initializeClient(player, (id) {
      player.id = id;
    });
  }

  void movePlayer() async {
    if (offlineMode) return;
    var jsonData = {
      "name": player.name,
      "x": player.x.toInt(),
      "y": player.y.toInt(),
      "xSpeed": player.xSpeed.round(),
      "ySpeed": player.ySpeed.round()
    };
    sendMessage("onMove", jsonData);
  }

  void hitTree(int targetX, int targetY, int damage) async {
    if (offlineMode) return;
    var jsonData = {
      "name": "${player.name}",
      "targetX": targetX,
      "targetY": targetY,
      "damage": damage
    };
    sendMessage("onTreeHit", jsonData);
  }

  void attackPlayer(int damage, String targetId) {
    var jsonData = {"playerId": targetId, "damage": damage};
    sendMessage("onEnemyAttackPlayer", jsonData);
  }

  @override
  void onPlayerEnterScreen(dynamic data) {
    super.onPlayerEnterScreen(data);
    Map<String, dynamic> user = data;

    user.forEach((key, value) {
      var name = value["name"].toString();
      var newX = double.parse(value['x'].toString());
      var newY = double.parse(value['y'].toString());
      var sprite = value['sprite'].toString();
      var playerId = value['playerId'].toString();

      if (name == player.name) {
        if (firstMove == true) {
          firstMove = false;
          player.x = newX;
          player.y = newY;
        }
      } else {
        _addEntityIfNotExist(Player(newX, newY, map, name, playerId, null,
            spriteFolder: sprite, isMine: false));
      }
    });
  }

  @override
  void onEnemysWalk(dynamic data) {
    super.onEnemysWalk(data);
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
                Skull(x, y, map, name, enemyId, moveTo: Offset(newX, newY));

            var playerFound = map.entityList.firstWhere(
                (element) => element.id == targetId,
                orElse: () => null);
            skull.iaController.target = playerFound;

            _addEntityIfNotExist(skull);
          }
        });
      }
    });
  }

  @override
  void onEnemysEnterScreen(dynamic data) {
    super.onEnemysEnterScreen(data);
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
        var skull = Skull(x, y, map, name, enemyId, moveTo: Offset(newX, newY));
        spawnedEntitys.add(skull);

        var playerFound = map.entityList.firstWhere(
            (element) => element.id == targetId,
            orElse: () => null);
        skull.iaController.target = playerFound;

        _addEntityIfNotExist(skull);
      }
    });

    for (var entityOnMap in map.entitysOnViewport) {
      if (entityOnMap is Enemy) {
        var foundEntity = spawnedEntitys.firstWhere(
            (element) => element.name == entityOnMap.name,
            orElse: () => null);

        if (foundEntity == null) {
          entityOnMap.destroy();
          print("""
### Destroying ENEMY ${entityOnMap.name} that is not on my Screen anymore""");
        }
      }
    }
  }

  @override
  void onAddPlayer(dynamic data) {
    super.onAddPlayer(data);

    Map<String, dynamic> user = data;
    var newX = double.parse(user['x'].toString());
    var newY = double.parse(user['y'].toString());

    var pName = user['name'].toString();
    var pId = user['playerId'].toString();
    var sprite = user['sprite'].toString();

    var e = Player(newX, newY, map, pName, pId, null,
        spriteFolder: sprite, isMine: false);

    _addEntityIfNotExist(e);
  }

  @override
  void onRemovePlayer(dynamic data) {
    super.onRemovePlayer(data);

    var pName = data['name'].toString();

    map.entityList.removeWhere((element) => element.name == pName);
  }

  @override
  void onPlayerUpdate(dynamic data) {
    super.onPlayerUpdate(data);

    var x = double.parse(data['x'].toString());
    var y = double.parse(data['y'].toString());
    // var xSpeed = double.parse(data['xSpeed'].toString());
    // var ySpeed = double.parse(data['ySpeed'].toString());
    // var sprite = data['sprite'].toString();
    // var hp = int.parse(data['hp'].toString());

    var playerId = data['playerId'].toString();

    var foundEntity = map.entitysOnViewport
        .firstWhere((element) => element.id == playerId, orElse: () => null);
    print('onPlayerUpdate $foundEntity');
    if (foundEntity != null) {
      foundEntity.x = x;
      foundEntity.y = y;
      //foundEntity.xSpeed = xSpeed;
      //foundEntity.ySpeed = ySpeed;

      if (foundEntity is Player) {
        //foundEntity.spriteFolder = sprite;
      }
    }
  }

  @override
  void onMove(dynamic data) {
    super.onMove(data);

    var newX = double.parse(data['x'].toString());
    var newY = double.parse(data['y'].toString());
    var xSpeed = double.parse(data['xSpeed'].toString());
    var ySpeed = double.parse(data['ySpeed'].toString());
    var sprite = data['sprite'].toString();
    var pId = data['playerId'].toString();

    var pName = data['name'].toString();

    var foundEntity = map.entitysOnViewport
        .firstWhere((element) => element.name == pName, orElse: () => null);

    if (foundEntity != null) {
      if (foundEntity.name != player.name) {
        if (foundEntity is Player) {
          foundEntity.setTargetPosition(newX, newY);
          foundEntity.xSpeed = xSpeed;
          foundEntity.ySpeed = ySpeed;
        } else {
          foundEntity.x = newX;
          foundEntity.y = newY;
        }
      }
    } else {
      _addEntityIfNotExist(Player(newX, newY, map, pName, pId, null,
          spriteFolder: sprite, isMine: false));
    }
  }

  void _addEntityIfNotExist(Entity newEntity, {update = true}) {
    var foundEntity = map.entityList.firstWhere(
        (element) => element.id == newEntity.id,
        orElse: () => null);

    if (foundEntity == null) {
      map.addEntity(newEntity);
    } else {
      if (foundEntity is Enemy && newEntity is Enemy && update) {
        var dest = newEntity.iaController.getDestination();
        var distance = (dest - Offset(newEntity.x, newEntity.y)).distance;

        foundEntity.iaController.moveTo(newEntity.x, newEntity.y);

        if (newEntity.iaController.target != null && distance > 24) {
          //foundEntity.x = newEntity.x;
          //foundEntity.y = newEntity.y;
        }

        //foundEntity.iaController.moveTo(foundEntity.x, foundEntity.y);
        //foundEntity.iaController.target = newEntity.iaController.target;
      }
    }
  }

  @override
  void onTreeHit(dynamic data) {
    super.onTreeHit(data);

    var targetX = double.parse(data['targetX'].toString());
    var targetY = double.parse(data['targetY'].toString());
    var pName = data['name'].toString();

    if (pName == player.name) {
      return;
    }
    var foundEntity = map.entityList
        .firstWhere((element) => element.name == pName, orElse: () => null);

    if (foundEntity != null && foundEntity is Player) {
      foundEntity.playerNetwork.hitTreeAnimation(targetX, targetY);
    }
  }

  @override
  void onEnemyTargetingPlayer(dynamic data) {
    super.onEnemyTargetingPlayer(data);

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

      var playerFound = map.entityList
          .firstWhere((element) => element.id == targetId, orElse: () => null);

      var foundEntity = map.entityList
          .firstWhere((element) => element.id == enemyId, orElse: () => null);

      if (foundEntity is Enemy && playerFound != null) {
        foundEntity.iaController
            .attackTarget(playerFound, damage: damage, targetHp: targetHp);
      }
    });
  }
}
