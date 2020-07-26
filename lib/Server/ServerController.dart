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
    initializeServer(player.name, player.spriteFolder);
  }

  void movePlayer() async {
    if (offlineMode) return;
    String jsonData =
        '{"name":"${player.name}", "sprite":"${player.spriteFolder}", "x":${player.x.toInt()}, "y":${player.y.toInt()}, "xSpeed":"${player.xSpeed.round()}", "ySpeed":"${player.ySpeed.round()}"}';
    socketIO.sendMessage("onMove", jsonData);
  }

  void hitTree(int targetX, int targetY, int damage) async {
    if (offlineMode) return;
    String jsonData =
        '{"name":"${player.name}", "action":"hitTree", "targetX":$targetX, "targetY":$targetY, "damage":$damage }';
    socketIO.sendMessage("onAction", jsonData);
  }

  @override
  getPlayers(data) {
    super.getPlayers(data);
    //print("getPlayers ${data}");
    Map<String, dynamic> user = jsonDecode(data);

    user.forEach((key, value) {
      String name = value["name"].toString();
      double newX = double.parse(value['x'].toString());
      double newY = double.parse(value['y'].toString());
      String sprite = value['sprite'].toString();

      if (name == player.name) {
        if (firstMove == true) {
          firstMove = false;
          player.x = newX;
          player.y = newY;
        }
      } else {
        print("creating sprite from getPlayers sprite= $sprite");
        _addEntityIfNotExist(
            Player(newX, newY, map, false, name, null, spriteFolder: sprite));
      }
    });
  }

  @override
  getEnemys(data) {
    super.getEnemys(data);
    print("getEnemys ${data}");
    Map<String, dynamic> user = jsonDecode(data);

    user.forEach((key, value) {
      print("getEnemys ${key} ${value}");
      if (key == 'enemys') {
        value.forEach((keyEnemy, enemy) {
          print("enemy: ${keyEnemy} ${enemy}");
          String name = enemy["name"].toString();
          double newX = double.parse(enemy['x'].toString());
          double newY = double.parse(enemy['y'].toString());

          print('creating enemy ${name}');
          if (name.startsWith('Skull')) {
            _addEntityIfNotExist(Skull(newX, newY, map, name));
          }
        });
      }
    });
  }

  @override
  onAddPlayer(data) {
    super.onAddPlayer(data);
    print("onAddPlayer ${data}");

    Map<String, dynamic> user = jsonDecode(data);
    double newX = double.parse(user['x'].toString());
    double newY = double.parse(user['y'].toString());

    String pName = user['name'].toString();
    String sprite = user['sprite'].toString();
    print("adding p= ${pName}");
    Entity e =
        Player(newX, newY, map, false, pName, null, spriteFolder: sprite);
    print("adding p= ${e}");
    _addEntityIfNotExist(e);
  }

  @override
  onRemovePlayer(data) {
    super.onRemovePlayer(data);
    print("onRemovePlayer ${data}");

    Map<String, dynamic> user = jsonDecode(data);
    String pName = user['name'].toString();
    print(pName);

    map.entityList.removeWhere((element) => element.name == pName);
  }

  @override
  void onMove(data) {
    super.onMove(data);
    //print("onMove ${data}");
    Map<String, dynamic> user = jsonDecode(data);
    double newX = double.parse(user['x'].toString());
    double newY = double.parse(user['y'].toString());
    double xSpeed = double.parse(user['xSpeed'].toString());
    double ySpeed = double.parse(user['ySpeed'].toString());
    String sprite = user['sprite'].toString();

    String pName = user['name'].toString();

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
      _addEntityIfNotExist(
          Player(newX, newY, map, false, pName, null, spriteFolder: sprite));
    }
  }

  void _addEntityIfNotExist(Entity newEntity) {
    print("_addEntityIfNotExist");
    Entity foundEntity = map.entitysOnViewport.firstWhere(
        (element) => element.name == newEntity.name,
        orElse: () => null);
    print("foundEntity = ");
    print("foundEntity = ${foundEntity}");
    if (foundEntity == null) {
      map.addEntity(newEntity);
    } else {
      print("> entity already exists ${newEntity.name}. Ignoring...");
      if (foundEntity is Enemy) {
        foundEntity.iaController.moveTo(newEntity.x, newEntity.y);
      }
    }
  }

  @override
  void onActionAll(data) {
    super.onActionAll(data);
    print("onActionAll ${data}");

    Map<String, dynamic> user = jsonDecode(data);
    double targetX = double.parse(user['targetX'].toString());
    double targetY = double.parse(user['targetY'].toString());

    String pName = user['name'].toString();
    if (pName == player.name) {
      return;
    }
    Entity foundEntity = map.entityList
        .firstWhere((element) => element.name == pName, orElse: () => null);

    if (foundEntity != null && foundEntity is Player) {
      foundEntity.playerNetwork.hitTreeAnimation(targetX, targetY);
    }
  }
}
