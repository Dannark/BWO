import 'package:flutter/material.dart';

import '../../entity/enemys/enemy.dart';
import '../../entity/entity.dart';
import '../../map/map_controller.dart';

class ServerUtils {
  //static const String server = "https://3000-e92204fd-e411-4285-8fd3-cf3515d1c358.ws-us02.gitpod.io";
  static const String server = "http://192.168.1.111:3000";

  static const bool offlineMode = false;

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
}
