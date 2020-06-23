import 'dart:math';

import 'package:BWO/Entity/Player.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Map/tree.dart';
import 'package:flutter/material.dart';

class PhysicsController {
  MapController map;

  PhysicsController(this.map) {}

  void update() {
    calculateCollisions();
  }

  void calculateCollisions() {
    var entityList = map.entitysOnViewport;
    entityList.forEach((e1) {
      if (e1 is Player) {
        e1.updatePhysics();

        entityList.forEach((e2) {
          if (e1 != e2) {
            int maxAmountOfTimesToPushPlayerOutPerLoop = 10;
            while (maxAmountOfTimesToPushPlayerOutPerLoop > 0) {
              Rectangle r1 = Rectangle(e1.colisionBox.left, e1.colisionBox.top,
                  e1.colisionBox.width, e1.colisionBox.height);
              Rectangle r2 = Rectangle(e2.colisionBox.left, e2.colisionBox.top,
                  e2.colisionBox.width, e2.colisionBox.height);

              if (r1.intersects(r2)) {
                //Rectangle intersection = r1.intersection(r2);
                var direction = (Offset(e1.x, e1.y) - Offset(e2.x, e2.y));
                e1.x += direction.dx.clamp(-1, 1);
                e1.y += direction.dy.clamp(-1, 1);
                e1.updatePhysics();
                
                maxAmountOfTimesToPushPlayerOutPerLoop --;
              }
              else{
                break;
              }
            }
          }
        });
      }
    });
  }
}
