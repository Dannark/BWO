import 'dart:async';
import 'dart:convert';

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
  int lastX = 0;
  int lastY = 0;

  ServerController(this.map) {
    //initFirebase();
  }

  void update() {}

  void setPlayer(Player player) {
    this.player = player;
    initializeServer(player.name);
  }

  void movePlayer() async {
    String jsonData =
        '{"name":"${player.name}", "x":${player.x.toInt()}, "y":${player.y.toInt()}, "xSpeed":"${player.xSpeed}", "ySpeed":"${player.ySpeed}"}';
    socketIO.sendMessage("onMove", jsonData);
  }

  @override
  onSetup(data) {
    super.onSetup(data);
    print("onSetup");
    Map<String, dynamic> user = jsonDecode(data);

    user.forEach((key, value) {
      print("$key $value");
      String name = value["name"].toString();
      double newX = double.parse(value['x'].toString());
      double newY = double.parse(value['y'].toString());

      print("$name $newX $newY");

      if (name == player.name) {
        player.x = newX;
        player.y = newY;
      } else {
        map.addEntity(Player(newX, newY, map, false, name));
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

    Entity foundEntity = map.entitysOnViewport
        .firstWhere((element) => element.name == pName, orElse: () => null);

    print(foundEntity);
    if (foundEntity == null) {
      map.addEntity(Player(newX, newY, map, false, pName));
    } else {
      print("skipping to Add new player, already exist: ${pName}");
    }
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
    print("onMove ${data}");
    Map<String, dynamic> user = jsonDecode(data);
    double newX = double.parse(user['x'].toString());
    double newY = double.parse(user['y'].toString());
    double xSpeed = double.parse(user['xSpeed'].toString());
    double ySpeed = double.parse(user['ySpeed'].toString());

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
      print("cant move: ${pName}");
    }
  }
}
