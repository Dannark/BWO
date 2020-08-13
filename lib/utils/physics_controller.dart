import 'dart:math';

import 'package:flutter/material.dart';

import '../entity/player/player.dart';
import '../map/map_controller.dart';

class PhysicsController {
  final MapController _map;

  PhysicsController(this._map);

  void update() {
    calculateCollisions();
  }

  void calculateCollisions() {
    var entityList = _map.entitysOnViewport;

    for (var e1 in entityList) {
      if (e1 is Player) {
        e1.updatePhysics();

        for (var e2 in entityList) {
          if (e1 != e2 && e2.isActive && e1.isActive) {
            var maxAmountOfTimesToPushPlayerOutPerLoop = 10;

            while (maxAmountOfTimesToPushPlayerOutPerLoop > 0) {
              var r1 = Rectangle(e1.collisionBox.left, e1.collisionBox.top,
                  e1.collisionBox.width, e1.collisionBox.height);
              var r2 = Rectangle(e2.collisionBox.left, e2.collisionBox.top,
                  e2.collisionBox.width, e2.collisionBox.height);

              if (r1.intersects(r2)) {
                if (e2.isCollisionTrigger == false) {
                  var direction = (Offset(e1.x, e1.y) - Offset(e2.x, e2.y));
                  e1.x += direction.dx.clamp(-1, 1);
                  e1.y += direction.dy.clamp(-1, 1);
                  e1.updatePhysics();
                } else {
                  e1.onTriggerStay(e2);
                  break;
                }
                //Rectangle intersection = r1.intersection(r2);

                maxAmountOfTimesToPushPlayerOutPerLoop--;
              } else {
                break;
              }
            }
          }
        }
      }
    }
  }
}
