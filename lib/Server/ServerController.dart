import 'dart:async';
import 'dart:convert';

import 'package:BWO/Entity/Enemys/Enemy.dart';
import 'package:BWO/Entity/Enemys/Skull.dart';
import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Server/NetworkServer.dart';
import 'package:BWO/Utils/TapState.dart';
import 'package:BWO/game_controller.dart';
import 'package:flutter/material.dart';

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

  void updatePlayer(jsonData) async {
    if (offlineMode) return;

    sendMessage("onUpdate", jsonData);
  }

  void hitTree(int targetX, int targetY, int damage) async {
    if (offlineMode) return;
    String jsonData =
        '{"name":"${player.name}", "targetX":$targetX, "targetY":$targetY, "damage":$damage }';
    sendMessage("onTreeHit", jsonData);
  }

  void attackPlayer(int damage, String targetId) {
    var jsonData = {"playerId": targetId, "damage": damage};
    sendMessage("onEnemyAttackPlayer", jsonData);
  }

  @override
  onPlayerEnterScreen(data) {
    super.onPlayerEnterScreen(data);
    print("onPlayerEnterScreen ${data}");
    Map<String, dynamic> user = data;

    user.forEach((key, value) {
      String name = value["name"].toString();
      double newX = double.parse(value['x'].toString());
      double newY = double.parse(value['y'].toString());
      String sprite = value['sprite'].toString();
      String playerId = value['playerId'].toString();

      if (name == player.name) {
        if (firstMove == true) {
          firstMove = false;
          player.x = newX;
          player.y = newY;
        }
      } else {
        print("creating sprite from getPlayers sprite= $sprite");
        _addEntityIfNotExist(Player(
            newX, newY, map, false, name, playerId, null,
            spriteFolder: sprite));
      }
    });
  }

  @override
  onEnemysWalk(data) {
    super.onEnemysWalk(data);
    print("onEnemysWalk ${data}");
    /**
     * Fire when enemy walk by it self
     */

    data.forEach((key, value) {
      if (key == 'enemys') {
        value.forEach((keyEnemy, enemy) {
          String name = enemy["name"].toString();
          String enemyId = enemy["enemyId"].toString();
          double x = double.parse(enemy['x'].toString());
          double y = double.parse(enemy['y'].toString());
          double newX = double.parse(enemy['toX'].toString());
          double newY = double.parse(enemy['toY'].toString());
          String targetId = enemy['target'];

          if (name == 'Skull') {
            Skull skull =
                Skull(x, y, map, name, enemyId, moveTo: Offset(newX, newY));

            Entity playerFound = map.entityList.firstWhere(
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
  onEnemysEnterScreen(data) {
    super.onEnemysEnterScreen(data);
    //print("onEnemysEnterScreen ${data}");
    /**
     * Fired when the player walks
     */

    List<Entity> spawnedEntitys = [];

    data.forEach((keyEnemy, enemy) {
      String name = enemy["name"].toString();
      String enemyId = enemy["enemyId"].toString();
      double x = double.parse(enemy['x'].toString());
      double y = double.parse(enemy['y'].toString());
      double newX = double.parse(enemy['toX'].toString());
      double newY = double.parse(enemy['toY'].toString());
      String targetId = enemy['target'];

      if (name == 'Skull') {
        Skull skull =
            Skull(x, y, map, name, enemyId, moveTo: Offset(newX, newY));
        spawnedEntitys.add(skull);

        Entity playerFound = map.entityList.firstWhere(
            (element) => element.id == targetId,
            orElse: () => null);
        skull.iaController.target = playerFound;

        _addEntityIfNotExist(skull);
      }
    });

    map.entitysOnViewport.forEach((entityOnMap) {
      if (entityOnMap is Enemy) {
        Entity foundEntity = spawnedEntitys.firstWhere(
            (element) => element.name == entityOnMap.name,
            orElse: () => null);

        if (foundEntity == null) {
          entityOnMap.destroy();
          print(
              "### Destroying ENEMY ${entityOnMap.name} that is not on my Screen anymore");
        }
      }
    });
  }

  @override
  onAddPlayer(data) {
    super.onAddPlayer(data);
    print("onAddPlayer ${data}");

    Map<String, dynamic> user = data;
    double newX = double.parse(user['x'].toString());
    double newY = double.parse(user['y'].toString());

    String pName = user['name'].toString();
    String pId = user['playerId'].toString();
    String sprite = user['sprite'].toString();

    Entity e =
        Player(newX, newY, map, false, pName, pId, null, spriteFolder: sprite);

    _addEntityIfNotExist(e);
  }

  @override
  onRemovePlayer(data) {
    super.onRemovePlayer(data);
    print("onRemovePlayer ${data}");

    String pName = data['name'].toString();
    print(pName);

    map.entityList.removeWhere((element) => element.name == pName);
  }

  @override
  void onMove(data) {
    super.onMove(data);
    print("onMove ${data}");

    double newX = double.parse(data['x'].toString());
    double newY = double.parse(data['y'].toString());
    double xSpeed = double.parse(data['xSpeed'].toString());
    double ySpeed = double.parse(data['ySpeed'].toString());
    String sprite = data['sprite'].toString();
    String pId = data['playerId'].toString();

    String pName = data['name'].toString();

    Entity foundEntity = map.entitysOnViewport
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
      _addEntityIfNotExist(Player(newX, newY, map, false, pName, pId, null,
          spriteFolder: sprite));
    }
  }

  void _addEntityIfNotExist(Entity newEntity, {update = true}) {
    Entity foundEntity = map.entityList.firstWhere(
        (element) => element.id == newEntity.id,
        orElse: () => null);

    if (foundEntity == null) {
      map.addEntity(newEntity);
    } else {
      if (foundEntity is Enemy && newEntity is Enemy && update) {
        Offset dest = newEntity.iaController.getDestination();
        double distance = (dest - Offset(newEntity.x, newEntity.y)).distance;

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
  void onTreeHit(data) {
    super.onTreeHit(data);
    print("onTreeHit ${data}");

    double targetX = double.parse(data['targetX'].toString());
    double targetY = double.parse(data['targetY'].toString());

    String pName = data['name'].toString();
    if (pName == player.name) {
      return;
    }
    Entity foundEntity = map.entityList
        .firstWhere((element) => element.name == pName, orElse: () => null);

    if (foundEntity != null && foundEntity is Player) {
      foundEntity.playerNetwork.hitTreeAnimation(targetX, targetY);
    }
  }

  @override
  void onEnemyTargetingPlayer(data) {
    super.onEnemyTargetingPlayer(data);
    print("onEnemyTargetingPlayer ${data}");

    var targetId = data['playerId'];
    var enemys = data['enemys'];

    Entity playerFound = map.entityList
        .firstWhere((element) => element.id == targetId, orElse: () => null);

    enemys.forEach((enemyID, enemyData) {
      String enemyId = enemyData['enemyId'].toString();
      double x = double.parse(enemyData['x'].toString());
      double y = double.parse(enemyData['y'].toString());

      int damage = int.parse(
          (enemyData['damage'] != null ? enemyData['damage'] : 0).toString());

      int target_hp = int.parse(
          (enemyData['target_hp'] != null ? enemyData['target_hp'] : 0)
              .toString());

      Entity foundEntity = map.entityList
          .firstWhere((element) => element.id == enemyId, orElse: () => null);

      if (foundEntity is Enemy && playerFound != null) {
        //print('Enemy $foundEntity attacking player $playerFound with damage $damage');

        foundEntity.iaController
            .attackTarget(playerFound, damage: damage, target_hp: target_hp);
      }
    });
  }
}
