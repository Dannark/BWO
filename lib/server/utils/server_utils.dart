import 'package:flutter/material.dart';

import '../../entity/enemys/enemy.dart';
import '../../entity/entity.dart';
import '../../entity/player/player.dart';
import '../../map/map_controller.dart';

class ServerUtils {
  //static const String server = "https://3000-e92204fd-e411-4285-8fd3-cf3515d1c358.ws-us02.gitpod.io";
  //static const String server = "http://192.168.1.111:3000";
  static const String server = "https://borderless-world.herokuapp.com";
  static const String database = 'production'; // production
  static const bool isOffline = false;

  static void addEntityIfNotExist(MapController map, Entity newEntity,
      {bool updateIfExist = true}) {
    var foundEntity = map.entityList.firstWhere(
        (element) => element.id == newEntity.id,
        orElse: () => null);

    if (foundEntity == null) {
      map.addEntity(newEntity);
    } else {
      if (foundEntity is Enemy && newEntity is Enemy && updateIfExist) {
        var dest = newEntity.iaController.getDestination();
        var distance = (dest - Offset(foundEntity.x, foundEntity.y)).distance;

        if (distance > 250) {
          foundEntity.x = newEntity.x;
          foundEntity.y = newEntity.y;
        }

        foundEntity.updatePhysics();
        foundEntity.iaController.moveTo(dest.dx, dest.dy);
      }

      if (foundEntity is Player && updateIfExist) {
        if (foundEntity.isMine == false) {
          foundEntity.setTargetPosition(newEntity.x, newEntity.y);
          foundEntity.xSpeed = newEntity.xSpeed;
          foundEntity.ySpeed = newEntity.ySpeed;
        }
      }
    }
  }
}
